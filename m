Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab1LVH6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 02:58:40 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:58113 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab1LVH6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 02:58:39 -0500
Date: Thu, 22 Dec 2011 08:58:30 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Chris Boot <bootc@bootc.net>, lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 ipv6_select_ident
Message-ID: <20111222075830.GR6348@secunet.com>
References: <1324488984.2301.45.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <1324490401.2301.46.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <4EF23BF2.4000601@bootc.net>
 <1324499332.2621.7.camel@edumazet-laptop>
 <1324500775.2621.9.camel@edumazet-laptop>
 <4EF2568C.6040006@bootc.net>
 <AEC29013-98F3-4A16-A88B-AD31C9E88EB8@bootc.net>
 <1324528656.2621.19.camel@edumazet-laptop>
 <20111222063806.GP6348@secunet.com>
 <1324540277.2621.41.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324540277.2621.41.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 22 Dec 2011 07:58:32.0752 (UTC) FILETIME=[7FFC4300:01CCC07F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 08:51:17AM +0100, Eric Dumazet wrote:
> 
> Prior to 618f9bc74a0, we were calling 
> 
> static inline u32 dst_mtu(const struct dst_entry *dst)
>  {
>        u32 mtu = dst_metric_raw(dst, RTAX_MTU);
> 
>        if (!mtu)
>                mtu = dst->ops->mtu(dst);
> 
>        return mtu;
> }
> 
> with dst = fake_rtable
> 
> and we did :
> 
> dst_init_metrics(&rt->dst, br_dst_default_metrics, true);
> 
> so dst_metric_raw(dst, RTAX_MTU) was returning 1500
> 
> So bug is new, we dont need to backport this fix.
> 

Ok, I see. Thanks for pointing it out!
