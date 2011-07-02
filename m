Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab1GBPfn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 11:35:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:32855 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab1GBPfl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 11:35:41 -0400
Subject: Re: [PATCH] sched: Check nr_running before calling pick_next_task
 in schedule().
From: Peter Zijlstra <peterz@infradead.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
In-Reply-To: <CADZ9YHhmctoO+AZfjDYNHXJ6VO3VSDPHgYOhdoW9oROFrBgBnQ@mail.gmail.com>
References: <1309545711.4303.2.camel@localhost.localdomain>
	 <1309600260.10073.3.camel@twins>
	 <CADZ9YHhmctoO+AZfjDYNHXJ6VO3VSDPHgYOhdoW9oROFrBgBnQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 02 Jul 2011 17:35:31 +0200
Message-ID: <1309620931.3282.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-07-02 at 20:26 +0600, Rakib Mullick wrote:
> Well, yes - branching seems definitely have some side effects.

It adds the cost of the test as well as a possible branch mis-predict.

> Thinking from UP's perspective, it will only hit slow path -- going
> into idle.

Uhm, no, every time the machine is busy and does a schedule between
tasks you still get to do that extra nr_running test and branch.

>  In that case, that likely branch will just fail. And on an
> UP system that slow path -- going into idle -- is the only way, taking
> the fast path (trying picking a task) isn't the right thing, isn't
> it? 

I'm not at all sure I even understand what you're trying to say. I
really don't understand what's the problem with going the long way with
picking the idle task, the machine is idle, it doesn't have anything
useful to do, who cares.
