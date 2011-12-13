Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab1LMTKC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 14:10:02 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:40646 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755104Ab1LMTJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 14:09:59 -0500
Subject: Re: kernel 3.1.1 message:  <IRQ> warn_alloc_failed
From: Ben Hutchings <bhutchings@solarflare.com>
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Rajesh Borundia <rajesh.borundia@qlogic.com>,
        "starlight@binnacle.cx" <starlight@binnacle.cx>,
        Sony Chacko <sony.chacko@qlogic.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <20111213104152.14c01911@nehalam.linuxnetplumber.net>
References: <6.2.5.6.2.20111208210303.03a06228@flumedata.com>
	 <20111209095014.14a647cd@nehalam.linuxnetplumber.net>
	 <6.2.5.6.2.20111209130007.039b3078@binnacle.cx>
	 <13A253B3F9BEFE43B93C09CF75F63CAA8162593365@MNEXMB1.qlogic.org>
	 <20111213104152.14c01911@nehalam.linuxnetplumber.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Tue, 13 Dec 2011 19:09:54 +0000
Message-ID: <1323803394.2790.5.camel@bwh-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18578.005
X-TM-AS-Result: No--31.442000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-13 at 10:41 -0800, Stephen Hemminger wrote:
> On Tue, 13 Dec 2011 11:42:13 -0600
> Rajesh Borundia <rajesh.borundia@qlogic.com> wrote:
> 
> > Hi All,
> > 
> > Sorry for late reply.
> > 
> > Stephan,
> > Thanks for analyzing.
> > 
> > Yes, the netxen adapter does not support fragmented page memory.
> > They are not harmful messages. At that instant of time it may fail allocating
> > memory for some buffers in the ring but after enough memory is available
> > it will try to allocate memory for unallocated buffers in ring.
> > 
> > Or the other option could be to turn LRO off.
[...]
> The driver should be changed to call allocation with __GFP_NOWARN.
> Change dev_alloc_skb(size) to
>   __dev_alloc_skb(size, GFP_ATOMIC|__GFP_NOWARN)
> 
> Or better yet, switch to using netdev_alloc variant like
>   __netdev_alloc_skb_ip_align(dev, length, GFP_ATOMIC|__GFP_NOWARN)

Why should this be done only in specific drivers?

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

