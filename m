Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab0CWDtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 23:49:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35559
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754358Ab0CWDtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 23:49:17 -0400
Date: Mon, 22 Mar 2010 20:49:39 -0700 (PDT)
Message-Id: <20100322.204939.146100390.davem@davemloft.net>
To: amwang@redhat.com
Cc: mpm@selenic.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, gospo@redhat.com,
       nhorman@tuxdriver.com, shemminger@linux-foundation.org,
       bonding-devel@lists.sourceforge.net, fubar@us.ibm.com,
       jmoyer@redhat.com
Subject: Re: [RFC Patch 1/3] netpoll: add generic support for bridge and
 bonding devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BA823D7.4010106@redhat.com>
References: <20100322082059.4967.63492.sendpatchset@localhost.localdomain>
	<1269297081.3552.19.camel@calx>
	<4BA823D7.4010106@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <amwang@redhat.com>
Date: Tue, 23 Mar 2010 10:13:43 +0800

> Matt Mackall wrote:
>> Seems like a lot of interface for something to be used by only a
>> couple
>> core drivers. Hopefully Dave has an opinion here.
>> 
> 
> Yeah, I worry about this too, maybe we can group those methods
> for netpoll together into another struct, and just put a pointer
> here?

This looks like it's tackled at the wrong layer, to be honest.

Teaching all of these layers about eachother's states is
going to end up being a nightmare in the end.

All of this "where is the npinfo" business can be handled
generically in net/core/dev.c I think, with none of these
callbacks.

For example, something like "if dev lacks ->npinfo, check
it's master".

Another thing, I wouldn't iterate over all devices, like I
see in the bonding poll controller method.  Just whichever
one supports netpoll you see first, use it and exit
immediately.  Don't send it to every single port, I can't
see how that might be desirable or useful.
