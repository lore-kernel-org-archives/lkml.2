Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab1AZT34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 14:29:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40845 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab1AZT3y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 14:29:54 -0500
Subject: Re: [RFC][PATCH 26/25] mm, arch: Convert ia64, arm, sh to generic
 tlb
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <20110126191901.GA3434@merkur.ravnborg.org>
References: <20110125173111.720927511@chello.nl>
	 <1296047601.28776.1162.camel@laptop>
	 <20110126191901.GA3434@merkur.ravnborg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 Jan 2011 20:30:18 +0100
Message-ID: <1296070218.15234.9.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 20:19 +0100, Sam Ravnborg wrote:
> 
> /* Users of the generic TLB shootdown code must declare this storage space. */
> DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
> 
> If I understand this correct then this should read:
> 
> /*
>  * Users of the generic TLB shootdown
>  * must define mmu_gathers like this:
>  * DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
>  */
> 
> The main difference is "declare" => "define".
> 
> If you already updated this in you serie then please ignore this mail. 

This series rewrites mmu_gather to remove this per-cpu data :-), see
patch #10 which removes the DEFINE_PER_CPU()s after all users are dead.

