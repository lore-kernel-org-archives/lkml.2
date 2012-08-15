Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab2HONrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:47:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50447 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578Ab2HONrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:47:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 06/31] arm64: MMU fault handling and page table management
Date: Wed, 15 Aug 2012 13:47:00 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-7-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-7-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201208151347.01169.arnd@arndb.de>
X-Provags-ID: V02:K0:AwnCC1Bz4vavNEu9JtMqOw+pVYQ+CXbbF7GP4OewogA
 ce7cAizPNU6Zulikq4ymTFG7dFfaGF/FQdKB+Nvsd48bXqQGee
 j1duR3KiuhCd9UYtsdhASyRJGxZDQxMj1xZuIZMxQHygh9E914
 +Y07dj/1uQNOkOgil6ybe3B329K4/fEsmL3Idrhkex/jsHx/1H
 aCJ+QgaVBwb3eupHE+XZAMHyc5uAGJ5t6K6b7gDeN2WfedMqgI
 Tpl+fISfXYKoyVMu1iXzfhO+Cm4H8rrD0FfLBOo9yCLCvwVQ0P
 8uQ4lE7W/I0yL/60n/bkZabzCQDgPZdvX4S3IlUjkkonMN5i6z
 Eh2K7KX7U96wIiWZgW2Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012, Catalin Marinas wrote:
> +
> +pgd_t *pgd_alloc(struct mm_struct *mm)
> +{
> +	pgd_t *new_pgd;
> +
> +	new_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL, PGD_ORDER);
> +	if (!new_pgd)
> +		return NULL;
> +
> +	memset(new_pgd, 0, PAGE_SIZE << PGD_ORDER);
> +
> +	return new_pgd;
> +}
> +
> +void pgd_free(struct mm_struct *mm, pgd_t *pgd)
> +{
> +	free_pages((unsigned long)pgd, PGD_ORDER);
> +}
 
According to the documentation, you should only need 8kb for the pgd on
a 64kb page system. Is it required that you use up a full page here?

	Arnd
