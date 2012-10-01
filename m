Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab2JAOCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 10:02:36 -0400
Received: from shutemov.name ([176.9.204.213]:59613 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab2JAOCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 10:02:34 -0400
Date: Mon, 1 Oct 2012 17:03:05 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.cz,
        Steve Capper <steve.capper@arm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] mm: thp: Set the accessed flag for old pages on access
 fault.
Message-ID: <20121001140305.GA20173@shutemov.name>
References: <1349099505-5581-1-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349099505-5581-1-git-send-email-will.deacon@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 02:51:45PM +0100, Will Deacon wrote:
> diff --git a/mm/memory.c b/mm/memory.c
> index 5736170..d5c007d 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3537,7 +3537,11 @@ retry:
>  				if (unlikely(ret & VM_FAULT_OOM))
>  					goto retry;
>  				return ret;
> +			} else {
> +				huge_pmd_set_accessed(mm, vma, address, pmd,
> +						      orig_pmd);

I think putting it to 'else' is wrong. You should not touch pmd, if it's
under splitting.

>  			}
> +
>  			return 0;
>  		}
>  	}

-- 
 Kirill A. Shutemov
