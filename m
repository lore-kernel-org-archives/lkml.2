Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab1KBXYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 19:24:10 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:29776 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab1KBXYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 19:24:07 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+71M7xt8KikdguR5qM/keh
Date: Wed, 2 Nov 2011 16:24:03 -0700
From: Tony Lindgren <tony@atomide.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] net: Add back alignment for size for __alloc_skb
Message-ID: <20111102232403.GO31337@atomide.com>
References: <4EB1CA4F.3090403@gmail.com>
 <20111102.190955.1902322759075682192.davem@davemloft.net>
 <4EB1CEC4.3090909@gmail.com>
 <20111102.191716.1682282796914825621.davem@davemloft.net>
 <20111102231917.GN31337@atomide.com>
 <4EB1D05B.6020605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB1D05B.6020605@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Dumazet <eric.dumazet@gmail.com> [111102 15:46]:
> On 03/11/2011 00:19, Tony Lindgren wrote:
> 
> > * David Miller <davem@davemloft.net> [111102 15:42]:
> >> c> 
> >>> The issue is calculation of skb->end, which is based upon calculated
> >>> 'size' variable.
> >>>
> >>> skb->end determines alignment of skb_shared_info, which is where the
> >>> alignment problem is occuring for Tony.
> >>
> >> Right, and SMP_CACHE_BYTES setting should save us in any case.
> >>
> >> For ARM, SMP_CACHE_BYTES seems to be set to L1_CACHE_BYTES which in
> >> turn is set via ARM_L1_CACHE_SHIFT which can be set seemingly to any
> >> value but the defaults are 5 and 6 which should be OK.
> >>
> >> So unless Tony is using a non-standard setting of ARM_L1_CACHE_SHIFT,
> >> this report is a bit mysterious.
> > 
> > This is happening at least with omap1_defconfig. In that case we have
> > ARM_L1_CACHE_SHIFT=5.
> > 
> > Regards,
> > 
> > Tony
> 
> 
> Do you use SLOB, SLUB or SLAB ?

Seems to be SLOB for omap1_defconfig.

Tony
