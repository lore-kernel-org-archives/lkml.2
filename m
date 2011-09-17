Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab1IQGIJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 02:08:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48747 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab1IQGIH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 02:08:07 -0400
MIME-Version: 1.0
In-Reply-To: <1301602523-9906-1-git-send-email-omar.ramirez@ti.com>
References: <1301602523-9906-1-git-send-email-omar.ramirez@ti.com>
From: Rabin Vincent <rabin@rab.in>
Date: Sat, 17 Sep 2011 11:37:26 +0530
X-Google-Sender-Auth: bLlJw2-jdEp4eLgFzQlVJ4YJS4U
Message-ID: <CAH+eYFBSiL44CMOpgED+TAOTUH_dQMaKKu=hC3ynG0Y2nQ8ekw@mail.gmail.com>
Subject: Re: [PATCH] ARM: BUG() dies silently
To: Omar Ramirez Luna <omar.ramirez@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        lak <linux-arm-kernel@lists.infradead.org>,
        lk <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 1, 2011 at 01:45, Omar Ramirez Luna <omar.ramirez@ti.com> wrote:
> There are some cases where the code generated for BUG() results
> into an infinite while loop without causing a null dereference,
> this ends on a kernel being stuck on a loop and the user without
> a clue of what happened.
>
> E.g.: lib/scatterlist.c : __sg_alloc_table
>
>        BUG_ON(nents > max_ents);
>  438:   9a000000        bls     440 <__sg_alloc_table+0x20>
>  43c:   eafffffe        b       43c <__sg_alloc_table+0x1c>
>
> Adding volatile makes the compiler to avoid optimizations on this
> code, which makes the panic to occur:
>
>        BUG_ON(nents > max_ents);
>  438:   9a000002        bls     448 <__sg_alloc_table+0x28>
>  43c:   e3a03000        mov     r3, #0
>  440:   e5833000        str     r3, [r3]
>  444:   eafffffc        b       43c <__sg_alloc_table+0x1c>
>
> Seen with gnu/linux cs arm-2010q1-202 and arm2010.09-50.
>
> Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>

If the "Use generic BUG() handler" patch is only scheduled for the next
merge window and not for 3.1, can this patch be merged instead for 3.1
and -stable?  This problem is easily seen with GCC 4.6.
