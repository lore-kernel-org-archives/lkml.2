Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab0DALQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 07:16:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:48331 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122Ab0DALQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 07:16:36 -0400
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in
 mmu_take_all_locks()
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, aarcange@redhat.com,
       akpm@linux-foundation.org, Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4BB47FC3.1020606@redhat.com>
References: <1270117906.1653.139.camel@laptop>
	 <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain>
	 <4BB47FC3.1020606@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Apr 2010 13:16:32 +0200
Message-ID: <1270120592.1653.192.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-01 at 14:13 +0300, Avi Kivity wrote:

> If someone is willing to audit all code paths to make sure these locks 
> are always taken in schedulable context I agree that's a better fix.

They had better be, they're not irq-safe. Also that's what lockdep is
for.


