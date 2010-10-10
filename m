Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab0JJQqu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 12:46:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47346 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757528Ab0JJQqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 12:46:48 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>, linux-mm@kvack.org
Subject: Re: [PATCH 14(16] pramfs: memory protection
References: <4CB1EBA2.8090409@gmail.com>
Date: Sun, 10 Oct 2010 18:46:46 +0200
In-Reply-To: <4CB1EBA2.8090409@gmail.com> (Marco Stornelli's message of "Sun,
	10 Oct 2010 18:36:50 +0200")
Message-ID: <87aamm3si1.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marco Stornelli <marco.stornelli@gmail.com> writes:
> +
> +	do {
> +		pgd = pgd_offset(&init_mm, address);
> +		if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
> +			goto out;
> +
> +		pud = pud_offset(pgd, address);
> +		if (pud_none(*pud) || unlikely(pud_bad(*pud)))
> +			goto out;
> +
> +		pmd = pmd_offset(pud, address);
> +		if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
> +			goto out;
> +
> +		ptep = pte_offset_kernel(pmd, addr);
> +		pte = *ptep;
> +		if (pte_present(pte)) {

This won't work at all on x86 because you don't handle large 
pages.

And it doesn't work on x86-64 because the first 2GB are double
mapped (direct and kernel text mapping)

Thirdly I expect it won't either on architectures that map
the direct mapping with special registers (like IA64 or MIPS)

I'm not sure this is very useful anyways. It doesn't protect
against stray DMA and it doesn't protect against writes through
broken user PTEs.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
