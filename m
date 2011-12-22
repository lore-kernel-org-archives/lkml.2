Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab1LVIFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 03:05:46 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64227 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab1LVIFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 03:05:43 -0500
Message-ID: <1324541138.2621.45.camel@edumazet-laptop>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 ipv6_select_ident
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Chris Boot <bootc@bootc.net>, lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Date: Thu, 22 Dec 2011 09:05:38 +0100
In-Reply-To: <20111222075830.GR6348@secunet.com>
References: <1324488984.2301.45.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1324490401.2301.46.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4EF23BF2.4000601@bootc.net> <1324499332.2621.7.camel@edumazet-laptop>
	 <1324500775.2621.9.camel@edumazet-laptop> <4EF2568C.6040006@bootc.net>
	 <AEC29013-98F3-4A16-A88B-AD31C9E88EB8@bootc.net>
	 <1324528656.2621.19.camel@edumazet-laptop>
	 <20111222063806.GP6348@secunet.com>
	 <1324540277.2621.41.camel@edumazet-laptop>
	 <20111222075830.GR6348@secunet.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 22 décembre 2011 à 08:58 +0100, Steffen Klassert a écrit :
> On Thu, Dec 22, 2011 at 08:51:17AM +0100, Eric Dumazet wrote:
> > 
> > Prior to 618f9bc74a0, we were calling 
> > 
> > static inline u32 dst_mtu(const struct dst_entry *dst)
> >  {
> >        u32 mtu = dst_metric_raw(dst, RTAX_MTU);
> > 
> >        if (!mtu)
> >                mtu = dst->ops->mtu(dst);
> > 
> >        return mtu;
> > }
> > 
> > with dst = fake_rtable
> > 
> > and we did :
> > 
> > dst_init_metrics(&rt->dst, br_dst_default_metrics, true);
> > 
> > so dst_metric_raw(dst, RTAX_MTU) was returning 1500
> > 
> > So bug is new, we dont need to backport this fix.
> > 
> 
> Ok, I see. Thanks for pointing it out!

You're welcome.

By the way we no longer have this 1500 hard coded, not sure it it
matters or not, but it looks better anyway.



