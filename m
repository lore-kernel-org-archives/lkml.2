Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab1GTTL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 15:11:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51346 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab1GTTL5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 15:11:57 -0400
Subject: Re: sched: fix/optimise some issues
From: Peter Zijlstra <peterz@infradead.org>
To: stephan.baerwolf@tu-ilmenau.de
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        ncrao@google.com, Mike Galbraith <efault@gmx.de>
In-Reply-To: <4E26DB41.9070002@tu-ilmenau.de>
References: <4E26DB41.9070002@tu-ilmenau.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Jul 2011 21:11:30 +0200
Message-ID: <1311189090.29152.73.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-20 at 15:42 +0200, Stephan Bärwolf wrote:
> In "check_preempt_tick()" (kernel/sched_fair.c:1093) a ulong
> called "ideal_runtime" stores a timeslice of the current task
> (scheduling entity). This time complies real cpu-time.
> 
> At the end of the same function (nr_running > 1) this (real) time
> is compared with a virtual-runtime-delta. Obviously the timeunits
> (real vs. virtual) didn't fit.
> 
> Using "wakeup_preempt_entity()" instead should fix this in a even
> more general way. 

Hrm,. I'm fairly sure we did that on purpose and the thing that is
missing is a big fat comment. People keep trying to fix that (me
included).

I'll try and dig up the why and such.
