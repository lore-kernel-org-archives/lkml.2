Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab1AYUM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 15:12:59 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58880 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab1AYUM5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 15:12:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=B2J6pBGAJchm1Ob8kS1+RACRiEY3HK0aqJePZoYGo3E544tkixEq2gF+13MCrU9VyW
         UPlm7jvB2FpaBmy/y1ohQvzk8kl1EZmiO+fVA1jYM07vlE6l8m3DnGddumD0q9nHZhW4
         X5mFFezdYIjHdYzz8+b464ZKUcNRwY4u/l+No=
MIME-Version: 1.0
In-Reply-To: <20110125174907.664402563@chello.nl>
References: <20110125173111.720927511@chello.nl>
	<20110125174907.664402563@chello.nl>
Date: Tue, 25 Jan 2011 12:12:56 -0800
X-Google-Sender-Auth: DI5oovGZnb4DdE54V2gMdABjcZE
Message-ID: <AANLkTikgpX16=ouGCpKqDtr7w-AUWLQNU7cFi4vKWbt+@mail.gmail.com>
Subject: Re: [PATCH 09/25] ia64: Preemptible mmu_gather
From: Tony Luck <tony.luck@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 9:31 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>  struct mmu_gather {
>        struct mm_struct        *mm;
>        unsigned int            nr;             /* == ~0U => fast mode */
> +       unsigned int            max;
>        unsigned char           fullmm;         /* non-zero means full mm flush */
>        unsigned char           need_flush;     /* really unmapped some PTEs? */
>        unsigned long           start_addr;
>        unsigned long           end_addr;
> -       struct page             *pages[FREE_PTE_NR];
> +       struct page             **pages;
> +       struct page             *local[8];
>  };

Overall it looks OK - builds, boots & runs too. One question about
the above bit ... why "8" elements in the local[] array?  This ought to be
a #define, maybe with a comment explaining the significance. It doesn't
seem to fill out struct mmu_gather to some "nice" size.  I can't think
of why batching 8 at a time (in the fallback cannot allocate **pages case)
is a good number. So is there some science to the choice, or did you
pluck 8 out of the air?

Thanks

-Tony
