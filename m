Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab2D3XFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 19:05:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51598 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283Ab2D3XFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 19:05:22 -0400
Date: Mon, 30 Apr 2012 16:05:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Shi <alex.shi@intel.com>
Cc: aarcange@redhat.com, riel@redhat.com, mgorman@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] THP: need is_vma_temporary_stack() when reference
 transparent_hugepage_enabled
Message-Id: <20120430160520.4c1cc05c.akpm@linux-foundation.org>
In-Reply-To: <1335594795-30876-1-git-send-email-alex.shi@intel.com>
References: <1335594795-30876-1-git-send-email-alex.shi@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2012 14:33:15 +0800
Alex Shi <alex.shi@intel.com> wrote:

> When the transparent_hugepage_enabled() used out of mm/,
> is_vma_temporary_stack() need be referenced. Otherwise, it has compile
> error.

This is a poor changelog - it doesn't tell us how this compilation
error comes about.  Is there some known build error in the mainline
kernel, or did you discover this when altering the kernel, or what?

One of the several reasons for this information is to permit others to
work out which kernel version(s) should be fixed.


> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index c8af7a2..10254ac 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -59,6 +59,7 @@ extern pmd_t *page_check_address_pmd(struct page *page,
>  #define HPAGE_PMD_MASK HPAGE_MASK
>  #define HPAGE_PMD_SIZE HPAGE_SIZE
>  
> +extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
>  #define transparent_hugepage_enabled(__vma)				\
>  	((transparent_hugepage_flags &					\
>  	  (1<<TRANSPARENT_HUGEPAGE_FLAG) ||				\

is_vma_temporary_stack() is already declared in rmap.h.  We should not
declare it in two places.

include/linux/huge_mm.h doesn't include any headers at all.  It
is one of those files which require its user to set up the
preconditions.

So, lacking any additional infomation I'd say that your mystery build
breakage was caused by a failure to include rmap.h.
