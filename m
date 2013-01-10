Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab3AJQ5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 11:57:51 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:38371 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab3AJQ5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:57:49 -0500
Message-ID: <50EEF2E9.2080302@linux.vnet.ibm.com>
Date: Thu, 10 Jan 2013 08:57:13 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v3 15/44] metag: Huge TLB
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com> <1357831872-29451-16-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1357831872-29451-16-git-send-email-james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011016-3620-0000-0000-000000DCBC2F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 07:30 AM, James Hogan wrote:
> +pte_t *huge_pte_alloc(struct mm_struct *mm,
> +			unsigned long addr, unsigned long sz)
> +{
> +	pgd_t *pgd;
> +	pud_t *pud;
> +	pmd_t *pmd;
> +	pte_t *pte;
> +
> +	pgd = pgd_offset(mm, addr);
> +	pud = pud_offset(pgd, addr);
> +	pmd = pmd_offset(pud, addr);
> +	pte = pte_alloc_map(mm, NULL, pmd, addr);
> +	pgd->pgd &= ~_PAGE_SZ_MASK;
> +	pgd->pgd |= _PAGE_SZHUGE;
> +
> +	return pte;
> +}

I'd be a bit surprised if you don't have to check for NULL during the
walk down the page tables.  Is there a special reason on your
architecture that this is unnecessary?

(There are several of these, not just this one).

