Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab1CAUwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 15:52:37 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:35150 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757432Ab1CAUwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 15:52:36 -0500
Date: Tue, 1 Mar 2011 21:52:34 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/tile: catch up with section naming convention in
	2.6.35
Message-ID: <20110301205234.GA5605@merkur.ravnborg.org>
References: <201103011931.p21JVtqp010237@farm-0010.internal.tilera.com> <201103011934.p21JYbHc010296@farm-0010.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103011934.p21JYbHc010296@farm-0010.internal.tilera.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris.

A few improvement proposals.

	Sam

> index 90e7c44..fc49b62 100644
> --- a/arch/tile/kernel/head_32.S
> +++ b/arch/tile/kernel/head_32.S
> @@ -133,7 +133,7 @@ ENTRY(_start)
>  	}
>  	ENDPROC(_start)
>  
> -.section ".bss.page_aligned","w"
> +.section ".bss..page_aligned","w"

Here you could use

    __PAGE_ALIGNED_BSS


>  	.align PAGE_SIZE
>  ENTRY(empty_zero_page)
>  	.fill PAGE_SIZE,1,0
> @@ -148,7 +148,7 @@ ENTRY(empty_zero_page)
>  	.word (\bits1) | (HV_CPA_TO_PFN(\cpa) << HV_PTE_INDEX_PFN)
>  	.endm
>  
> -.section ".data.page_aligned","wa"
> +.section ".data..page_aligned","wa"

and here you could use

    __PAGE_ALIGNED_DATA


>  /* This page is remapped on startup to be hash-for-home. */
>  int atomic_locks[PAGE_SIZE / sizeof(int) /* Only ATOMIC_HASH_SIZE is used */]
> -  __attribute__((aligned(PAGE_SIZE), section(".bss.page_aligned")));
> +  __attribute__((aligned(PAGE_SIZE), section(".bss..page_aligned")));

    __page_aligned_bss


	Sam
