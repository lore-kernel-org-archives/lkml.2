Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab0CWE1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 00:27:54 -0400
Received: from waste.org ([173.11.57.241]:54811 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab0CWE1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 00:27:53 -0400
Subject: Re: [RFC Patch 2/3] bridge: make bridge support netpoll
From: Matt Mackall <mpm@selenic.com>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, Andy Gospodarek <gospo@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       bonding-devel@lists.sourceforge.net, Jay Vosburgh <fubar@us.ibm.com>,
       David Miller <davem@davemloft.net>
In-Reply-To: <4BA82186.3010204@redhat.com>
References: <20100322082059.4967.63492.sendpatchset@localhost.localdomain>
	 <20100322082112.4967.5504.sendpatchset@localhost.localdomain>
	 <1269297307.3552.23.camel@calx>  <4BA82186.3010204@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Mar 2010 23:27:50 -0500
Message-ID: <1269318470.3552.54.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 10:03 +0800, Cong Wang wrote:
> Matt Mackall wrote:
> > On Mon, 2010-03-22 at 04:17 -0400, Amerigo Wang wrote:
> >> Based on the previous patch, make bridge support netpoll by:
> >>
> >> 1) implement the 4 methods to support netpoll for bridge;
> >>
> >> 2) modify netpoll during forwarding packets in bridge;
> >>
> >> 3) disable netpoll support of bridge when a netpoll-unabled device
> >>    is added to bridge;
> > 
> > Not sure if this is the right thing to do. Shouldn't we simply enable
> > polling on all devices that support it and warn about the others (aka
> > best effort)?
> > 
> 
> I don't think it's a good idea, because we check if a device
> supports netpoll by checking if it has ndo_poll_controller method.

Uh, what? If we have 5 devices on a bridge and 4 support netpoll, then
shouldn't we just send netconsole messages to those 4 devices? Isn't
this much better than simply refusing to work?

-- 
http://selenic.com : development and support for Mercurial and Linux


