Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab0CWE7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 00:59:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44085
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753328Ab0CWE7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 00:59:13 -0400
Date: Mon, 22 Mar 2010 21:59:36 -0700 (PDT)
Message-Id: <20100322.215936.113720990.davem@davemloft.net>
To: mpm@selenic.com
Cc: amwang@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, gospo@redhat.com,
       nhorman@tuxdriver.com, shemminger@linux-foundation.org,
       bonding-devel@lists.sourceforge.net, fubar@us.ibm.com
Subject: Re: [RFC Patch 2/3] bridge: make bridge support netpoll
From: David Miller <davem@davemloft.net>
In-Reply-To: <1269319861.3552.87.camel@calx>
References: <1269318470.3552.54.camel@calx>
	<4BA84607.7030304@redhat.com>
	<1269319861.3552.87.camel@calx>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Mackall <mpm@selenic.com>
Date: Mon, 22 Mar 2010 23:51:01 -0500

> On Tue, 2010-03-23 at 12:39 +0800, Cong Wang wrote:
>> Matt Mackall wrote:
>> How could you let the bridge know netpoll is not sent to
>> the one that doesn't support netpoll during setup? This will
>> be complex, I am afraid.
> 
> I thought I saw a simple loop over bridge devices at poll time in your
> patch. So it should be a simple matter of skipping unsupported devices
> in that loop.

It's because of all that "assign ->npinfo to slaves" crap he has to do
the way his patches are currently implemented.

It's basically another sign that the design is wrong.
