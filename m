Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab1CIPQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 10:16:10 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52239 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757097Ab1CIPQI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 10:16:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=P6VWCclgZ4J7iq5qsPa0Jmtj8crrlMvdC5tJdqFolXhIfyrgW8tirqYhQiPtBa+JT+
         yCMcHaOdTX9NaqsVPIpH8Na65iIHFZJI0ZFMtRfS9WB0jnbvupMe98P7zXardL3Lo2US
         XFCo1b87kDJAyW2cZdmF8uY09cxcLHywUe1rE=
MIME-Version: 1.0
In-Reply-To: <20110302180259.109909335@chello.nl>
References: <20110302175928.022902359@chello.nl>
	<20110302180259.109909335@chello.nl>
Date: Wed, 9 Mar 2011 15:16:07 +0000
X-Google-Sender-Auth: GgeUI2PwzGYwD4LyD9PoXMdBDt8
Message-ID: <AANLkTimbRS++SCcKGrUcL5xKsCO+1ygkg+83x7F+2S4i@mail.gmail.com>
Subject: Re: [RFC][PATCH 4/6] arm, mm: Convert arm to generic tlb
From: Catalin Marinas <catalin.marinas@arm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>, Russell King <rmk@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 2 March 2011 17:59, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> --- linux-2.6.orig/arch/arm/include/asm/tlb.h
> +++ linux-2.6/arch/arm/include/asm/tlb.h
[...]
> +__pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte, unsigned long addr)
>  {
>        pgtable_page_dtor(pte);
> -       tlb_add_flush(tlb, addr);
>        tlb_remove_page(tlb, pte);
>  }

I think we still need a tlb_track_range() call here. On the path to
pte_free_tlb() (for example shift_arg_pages ... free_pte_range) there
doesn't seem to be any code setting the tlb->start/end range. Did I
miss anything?

Thanks.

-- 
Catalin
