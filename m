Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876Ab1BYT7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 14:59:33 -0500
Received: from smtp-out.google.com ([216.239.44.51]:59091 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932759Ab1BYT7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 14:59:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=TlE9rjGZ5PKfe4SMrbgNihIEqV2CxzF5AKwZftj3NAmf0gqBlxBu/N/H0QYRi3RyDy
         vDe/YFv4R4wPd3ObCmVw==
MIME-Version: 1.0
In-Reply-To: <1298663105.2428.2693.camel@twins>
References: <20110217162327.434629380@chello.nl>
	<20110217163235.106239192@chello.nl>
	<1298565253.2428.288.camel@twins>
	<1298657083.2428.2483.camel@twins>
	<1298663105.2428.2693.camel@twins>
Date: Fri, 25 Feb 2011 11:59:23 -0800
X-Google-Sender-Auth: VhgMgVeTMrqos7L2vtFfgFoS9MA
Message-ID: <AANLkTinLv=oy5_nPdziV6gpG-BLedsrNF0ew4Wz3x690@mail.gmail.com>
Subject: Re: [PATCH 06/17] arm: mmu_gather rework
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Russell King <rmk@arm.linux.org.uk>, "Luck,Tony" <tony.luck@intel.com>,
        PaulMundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 11:45 AM, Peter Zijlstra <peterz@infradead.org> wrote:

> Grmbl.. so doing that would require flush_tlb_range() to take an mm, not
> a vma, but tile and arm both use the vma->flags & VM_EXEC test to avoid
> flushing their i-tlbs.
>
> I'm tempted to make them flush i-tlbs unconditionally as its still
> better than hitting an mm wide tlb flush due to the page table free.
>
> Ideas?

What's wrong with using vma->vm_mm?

Hugh
