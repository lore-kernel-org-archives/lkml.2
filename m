Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab1ITPIC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:08:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:60861 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab1ITPIB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:08:01 -0400
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <htejun@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 20 Sep 2011 17:07:32 +0200
In-Reply-To: <alpine.DEB.2.00.1109201000120.8056@router.home>
References: <20110919212040.745370781@goodmis.org>
	  <m2ehzcdkf2.fsf@firstfloor.org>
	 <1316488378.29966.35.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.02.1109200933310.2723@ionos>
	 <alpine.DEB.2.00.1109201000120.8056@router.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316531252.13664.39.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 10:03 -0500, Christoph Lameter wrote:
> 
> Well yes the misunderstanding of per cpu operations was one reason why I
> proposed the discussion on the subject of esoteric kernel synchronization.
> I do not think that it was accepted.

I don't think anybody here misunderstands it, we're just all very angry
that its causing so much problems.

__this_cpu doesn't have preempt debug checks, and there's a lot of
this_cpu usage that really should have been __this_cpu.

The very fact that a quick scan still reveals actual bugs should be a
warning sign that this crap doesn't have enough sanity checks.


