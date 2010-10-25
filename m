Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab0JYLaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 07:30:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51609 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab0JYLaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 07:30:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC PATCH 06/18] ARM: LPAE: Introduce the 3-level page table format definitions
Date: Mon, 25 Oct 2010 13:15:53 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20101025085812.25275.55757.stgit@e102109-lin.cambridge.arm.com> <20101025090007.25275.99918.stgit@e102109-lin.cambridge.arm.com>
In-Reply-To: <20101025090007.25275.99918.stgit@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010251315.53304.arnd@arndb.de>
X-Provags-ID: V02:K0:uZsGZsNMqCjlRIAeqBIsDWJuQ0Vtvon7aluJhJ3Svwb
 qWwUWZdCZLMjA2F2F3G0xohYokpbOUtsu3W31V5v2UM3i3M2Xc
 sZa8bmTtdHmI/tnd/NmGE5b/dfS/H5dZYjTBmdD0r/e6cXyAr4
 0gUOcZ93Db2rp/a5+plgq05TVjiKwlHy0B1+Gd1/e07ezPEu0c
 bDvdz80l5ShRceiH/SAkw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 October 2010, Catalin Marinas wrote:
> +/*
> + * With LPAE, there are 3 levels of page tables. Each level has 512 entries of
> + * 8 bytes each, occupying a 4K page. The first level table covers a range of
> + * 512GB, each entry representing 1GB. Since we are limited to 4GB input
> + * address range, only 4 entries in the PGD are used.
> + *
> + * There are enough spare bits in a page table entry for the kernel specific
> + * state.
> + */
> +#define PTRS_PER_PTE           512
> +#define PTRS_PER_PMD           512
> +#define PTRS_PER_PGD           4

Since the PGD is so extremely small, would it be possible to fold it
into the mm_context_t in order to save an allocation?
Or does the PGD still require page alignment?

Do you also have patches to allow 40-bit virtual space? I suppose we
will need that for KVM support in the future.

	Arnd

