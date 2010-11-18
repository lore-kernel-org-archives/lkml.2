Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab0KRRsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 12:48:25 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59665 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759867Ab0KRRsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 12:48:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ozeo5zqVOj1WJdJsjpsGPwiF5gI+6EDqsf1lF0qaYGzyjnC5i0a0IFZUi5RS01GNQh
         DyJXjwKZ1b1KcMTpyV6KIKO5SUavNdowRybX7lflKF/OpgWNl6tfBY2TAahm5fXVv/X+
         QGjRaMnyLMFawqvHm1DaZn3FDMROpUO+8aI1g=
Subject: Re: error while building the kernel Mainline
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-net@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Simon Horman <horms@verge.net.au>,
        Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>,
        Patrick McHardy <kaber@trash.net>
In-Reply-To: <4CE561A2.2020600@gmail.com>
References: <AANLkTikToBjx-4go9mAFCcnTQ5X4Su+57ODoY9C5y_7f@mail.gmail.com>
	 <1290093135.2781.167.camel@edumazet-laptop>  <4CE561A2.2020600@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 18:48:17 +0100
Message-ID: <1290102497.2781.242.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 18 novembre 2010 à 09:25 -0800, Justin P. Mattock a écrit :
> On 11/18/2010 07:12 AM, Eric Dumazet wrote:
> > Le jeudi 18 novembre 2010 à 06:36 -0800, Justin Mattock a écrit :
> >> hit this yesterday, and havent had time to look at it, to see if its a
> >> simple fix
> >>
> >>    MODPOST vmlinux.o
> >> WARNING: modpost: Found 1 section mismatch(es).
> >> To see full details build your kernel with:
> >> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> >>    GEN     .version
> >>    CHK     include/generated/compile.h
> >>    UPD     include/generated/compile.h
> >>    CC      init/version.o
> >>    LD      init/built-in.o
> >>    LD      .tmp_vmlinux1
> >> net/built-in.o: In function `handle_response_icmp':
> >> ip_vs_core.c:(.text+0x2b5c4): undefined reference to `nf_conntrack_untracked'
> >> net/built-in.o: In function `T.925':
> >> ip_vs_core.c:(.text+0x2cbbd): undefined reference to `nf_conntrack_untracked'
> >> net/built-in.o: In function `ip_vs_null_xmit':
> >> (.text+0x310da): undefined reference to `nf_conntrack_untracked'
> >> net/built-in.o: In function `ip_vs_tunnel_xmit':
> >> (.text+0x311e3): undefined reference to `nf_conntrack_untracked'
> >> net/built-in.o: In function `ip_vs_nat_xmit':
> >> (.text+0x3176f): undefined reference to `nf_conntrack_untracked'
> >> net/built-in.o:(.text+0x3199d): more undefined references to
> >> `nf_conntrack_untracked' follow
> >> make: *** [.tmp_vmlinux1] Error 1
> >>
> >> has there been anything sent forward for this yet?
> >>
> >
> > Try to find out why net/netfilter/nf_conntrack_core.c is not compiled ?
> 
> seems it is compiling, it's after the compiling when this breaks
> 
> >
> > ./net/netfilter/nf_conntrack_core.c:65:DEFINE_PER_CPU(struct nf_conn, nf_conntrack_untracked);
> > ./net/netfilter/nf_conntrack_core.c:66:EXPORT_PER_CPU_SYMBOL(nf_conntrack_untracked);
> >
> >
> >
> >
> 
> Justin P. Mattock


Let me guess...

net/netfilter/nf_conntrack_core is compiled as a module, and ip_vs
statically (in vmlinux) ?

CONFIG_NF_CONNTRACK=m
CONFIG_IP_VS=y

We probably need some Kconfig magic ;)



