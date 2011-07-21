Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab1GUPIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 11:08:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39374 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab1GUPIl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 11:08:41 -0400
Subject: Re: sched: fix/optimise some issues
From: Peter Zijlstra <peterz@infradead.org>
To: stephan.baerwolf@tu-ilmenau.de
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        ncrao@google.com
In-Reply-To: <4E26DB41.9070002@tu-ilmenau.de>
References: <4E26DB41.9070002@tu-ilmenau.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 21 Jul 2011 17:08:15 +0200
Message-ID: <1311260895.29152.153.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-20 at 15:42 +0200, Stephan Bärwolf wrote:
> 
> I also implemented an 128bit vruntime support:
> Majorly on systems with many tasks and (for example) deep cgroups
> (or increased NICE0_LOAD/ SCHED_LOAD_SCALE as in commit
> c8b281161dfa4bb5d5be63fb036ce19347b88c63), a weighted timeslice
> (unsigned long) can become very large (on x86_64) and consumes a
> large part of the u64 vruntimes (per tick) when added.
> This might lead to missscheduling because of overflows. 

Right, so I've often wanted a [us]128 type, and gcc has some (broken?)
support for that, but overhead has always kept me from it.

There's also the non-atomicy thing to consider, see min_vruntime_copy
etc.

How horrid is the current vruntime situation?

As to your true-idle, there's a very good reason the current SCHED_IDLE
isnt' a true idle scheduler; it would create horrid priority inversion
problems, imagine the true idle task holding a mutex or is required to
complete something.


