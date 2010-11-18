Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818Ab0KRPMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 10:12:22 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50356 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab0KRPMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 10:12:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hsLaYtntW+6l6BTXm+4xpYFzfymPFGRwRda+fVQAf8t7wS9diBW4vYsx+/M1C9DhvB
         EU4Lew48kN9X56F2LQKw9+o0S069j8D6lQ/vFOpYzNG876F+Yzx2v3+a9uUBPYPd+PYT
         zBqkDZkKWXZF9qTwFksS7PNR03lMyGUrrqufA=
Subject: Re: error while building the kernel Mainline
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Justin Mattock <justinmattock@gmail.com>
Cc: linux-net@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTikToBjx-4go9mAFCcnTQ5X4Su+57ODoY9C5y_7f@mail.gmail.com>
References: <AANLkTikToBjx-4go9mAFCcnTQ5X4Su+57ODoY9C5y_7f@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 16:12:15 +0100
Message-ID: <1290093135.2781.167.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 18 novembre 2010 à 06:36 -0800, Justin Mattock a écrit :
> hit this yesterday, and havent had time to look at it, to see if its a
> simple fix
> 
>   MODPOST vmlinux.o
> WARNING: modpost: Found 1 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>   GEN     .version
>   CHK     include/generated/compile.h
>   UPD     include/generated/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> net/built-in.o: In function `handle_response_icmp':
> ip_vs_core.c:(.text+0x2b5c4): undefined reference to `nf_conntrack_untracked'
> net/built-in.o: In function `T.925':
> ip_vs_core.c:(.text+0x2cbbd): undefined reference to `nf_conntrack_untracked'
> net/built-in.o: In function `ip_vs_null_xmit':
> (.text+0x310da): undefined reference to `nf_conntrack_untracked'
> net/built-in.o: In function `ip_vs_tunnel_xmit':
> (.text+0x311e3): undefined reference to `nf_conntrack_untracked'
> net/built-in.o: In function `ip_vs_nat_xmit':
> (.text+0x3176f): undefined reference to `nf_conntrack_untracked'
> net/built-in.o:(.text+0x3199d): more undefined references to
> `nf_conntrack_untracked' follow
> make: *** [.tmp_vmlinux1] Error 1
> 
> has there been anything sent forward for this yet?
> 

Try to find out why net/netfilter/nf_conntrack_core.c is not compiled ?

./net/netfilter/nf_conntrack_core.c:65:DEFINE_PER_CPU(struct nf_conn, nf_conntrack_untracked);
./net/netfilter/nf_conntrack_core.c:66:EXPORT_PER_CPU_SYMBOL(nf_conntrack_untracked);



