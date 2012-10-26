Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184Ab2JZOLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:11:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:43921 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933043Ab2JZOLf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:11:35 -0400
Message-ID: <1351260672.16863.81.camel@twins>
Subject: Re: [PATCH 26/31] sched, numa, mm: Add fault driven placement and
 migration policy
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Fri, 26 Oct 2012 16:11:12 +0200
In-Reply-To: <20121026135024.GA11640@gmail.com>
References: <20121025121617.617683848@chello.nl>
	 <20121025124834.467791319@chello.nl>
	 <CA+55aFwJdn8Kz9UByuRfGNtf9Hkv-=8xB+WRd47uHZU1YMagZw@mail.gmail.com>
	 <20121026071532.GC8141@gmail.com> <20121026135024.GA11640@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 15:50 +0200, Ingo Molnar wrote:
> 
> Oh, just found the reason:
> 
> the ptep_modify_prot_start()/modify()/commit() sequence is 
> SMP-unsafe - it has to be done under the mmap_sem write-locked.
> 
> It is safe against *hardware* updates to the PTE, but not safe 
> against itself. 

Shouldn't the pte_lock serialize all that still? All sites that modify
PTE contents should hold the pte_lock (and do afaict).
