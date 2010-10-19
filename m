Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983Ab0JSA5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 20:57:45 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:47948 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933673Ab0JSA5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 20:57:44 -0400
Date: Tue, 19 Oct 2010 01:57:43 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Kevin Cernekee <cernekee@gmail.com>
cc: Shinya Kuribayashi <skuribay@pobox.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend 5/9] MIPS: sync after cacheflush
In-Reply-To: <AANLkTinpry=XG-ZDgXJK-VB6QkBL2TO4-vrsV5Tc1eEs@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1010190146360.15889@eddie.linux-mips.org>
References: <17ebecce124618ddf83ec6fe8e526f93@localhost>        <17d8d27a2356640a4359f1a7dcbb3b42@localhost>        <4CBC4F4E.5010305@pobox.com> <AANLkTinpry=XG-ZDgXJK-VB6QkBL2TO4-vrsV5Tc1eEs@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010, Kevin Cernekee wrote:

> Some systems do require additional steps along those lines, e.g.
> 
> # ifdef CONFIG_SGI_IP28
> #  define fast_iob()				\
> 	__asm__ __volatile__(			\
> 		".set	push\n\t"		\
> 		".set	noreorder\n\t"		\
> 		"lw	$0,%0\n\t"		\
> 		"sync\n\t"			\
> 		"lw	$0,%0\n\t"		\
> 		".set	pop"			\
> 		: /* no output */		\
> 		: "m" (*(int *)CKSEG1ADDR(0x1fa00004)) \
> 		: "memory")
> 
> Maybe it would be better to use iob() instead of __sync() directly, so
> that it is easy to add extra steps for the CPUs that need them.  DEC
> and Loongson have custom __wbflush() implementations, and something
> similar could be added for your processor to implement the uncached
> dummy load.

 Ah, the old issue of the write-back barrier.  I can't comment on 
Loongson, but for DEC IIRC the write-back buffer only needs to be taken 
care of for uncached writes and they take a path separate to cached 
writes.  I'd have to dig out the details to be sure.  IIRC the most 
pathological case was the R2020 WB chip, but that was only used on systems 
that didn't do DMA (namely DECstatation 3100 and 2100 boxes).

  Maciej
