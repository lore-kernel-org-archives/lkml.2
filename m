Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab0FVVIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 17:08:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752199Ab0FVVIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 17:08:37 -0400
Date: Tue, 22 Jun 2010 14:08:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aarcange@redhat.com, linux-mm@kvack.org
Subject: Re: [PATCH -mm 2/6] rmap: always add new vmas at the end
Message-Id: <20100622140822.3d290151.akpm@linux-foundation.org>
In-Reply-To: <20100621163349.7dbd1ef6@annuminas.surriel.com>
References: <20100621163146.4e4e30cb@annuminas.surriel.com>
	<20100621163349.7dbd1ef6@annuminas.surriel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010 16:33:49 -0400
Rik van Riel <riel@redhat.com> wrote:

> From: Andrea Arcangeli <aarcange@redhat.com>
> Subject: always add new vmas at the end
> 
> Make sure to always add new VMAs at the end of the list.  This
> is important so rmap_walk does not miss a VMA that was created
> during the rmap_walk.
> 
> The old code got this right most of the time due to luck, but
> was buggy when anon_vma_prepare reused a mergeable anon_vma.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -149,7 +149,7 @@ int anon_vma_prepare(struct vm_area_stru
>  			avc->anon_vma = anon_vma;
>  			avc->vma = vma;
>  			list_add(&avc->same_vma, &vma->anon_vma_chain);
> -			list_add(&avc->same_anon_vma, &anon_vma->head);
> +			list_add_tail(&avc->same_anon_vma, &anon_vma->head);
>  			allocated = NULL;
>  			avc = NULL;
>  		}

Should this go into 2.6.35?
