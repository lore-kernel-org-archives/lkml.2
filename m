Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab0DAQNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:13:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879Ab0DAQNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:13:43 -0400
Date: Thu, 1 Apr 2010 18:12:43 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in
 mmu_take_all_locks()
Message-ID: <20100401161243.GW5825@random.random>
References: <1270117906.1653.139.camel@laptop>
 <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain>
 <4BB47FC3.1020606@redhat.com>
 <1270120592.1653.192.camel@laptop>
 <20100401153645.GP5825@random.random>
 <4BB4BE44.5070507@redhat.com>
 <20100401155456.GR5825@random.random>
 <4BB4C3AB.1060100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB4C3AB.1060100@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 07:02:51PM +0300, Avi Kivity wrote:
> Not these locks, but if we go all the way and make mmu notifiers 
> sleepable, we can convert mmu_lock to a mutex.

Ah yes, sure! I didn't get the objective was to convert the kvm
mmu_lock to mutex too, I thought you were talking about the linux VM
locks, and of course with rmap walks you meant the kvm rmaps, not the
linux rmaps. It's all clear now sorry.

I guess I was biased because I see mmu_lock like the page_table_lock
and in linux we never had mutex protecting pagetable access, because
pagetable mangling is so quick and never blocks. But there are the
rmap walks too protected by the same mmu_lock in kvm (not the case for
the page_table_lock that only protects pagetable access), so I agree
it may be worth converting it to mutex, agreed.
