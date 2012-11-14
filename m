Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945957Ab2KNXM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 18:12:57 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47179 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423427Ab2KNXM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 18:12:56 -0500
Date: Wed, 14 Nov 2012 15:12:54 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 05/11] thp: change_huge_pmd(): keep huge zero page
 write-protected
In-Reply-To: <1352300463-12627-6-git-send-email-kirill.shutemov@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1211141512400.22537@chino.kir.corp.google.com>
References: <1352300463-12627-1-git-send-email-kirill.shutemov@linux.intel.com> <1352300463-12627-6-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2012, Kirill A. Shutemov wrote:

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index d767a7c..05490b3 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1259,6 +1259,8 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>  		pmd_t entry;
>  		entry = pmdp_get_and_clear(mm, addr, pmd);
>  		entry = pmd_modify(entry, newprot);
> +		if (is_huge_zero_pmd(entry))
> +			entry = pmd_wrprotect(entry);
>  		set_pmd_at(mm, addr, pmd, entry);
>  		spin_unlock(&vma->vm_mm->page_table_lock);
>  		ret = 1;

Nack, this should be handled in pmd_modify().
