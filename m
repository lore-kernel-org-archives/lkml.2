Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab2ALU0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:26:25 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42284 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab2ALUZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:25:58 -0500
Message-ID: <1326399945.2442.212.camel@twins>
Subject: Re: [Question] sched: Should nr_uninterruptible be decremented in
 ttwu_do_activate()?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 12 Jan 2012 21:25:45 +0100
In-Reply-To: <CADZ9YHiGjjGJjxKj4WKWydqAz0zxFwY5=LsYBKhEREuZm=bKpg@mail.gmail.com>
References: <CADZ9YHicin2YjGm_m9B0LMv3NW1Z3cb7HSCaqwycFmVfRpvpWA@mail.gmail.com>
	 <1326302955.2442.174.camel@twins>
	 <CADZ9YHiC8732D=D8KpkT0d+81_BNdAvj0ZJLwL5mhyq9OPLW0Q@mail.gmail.com>
	 <1326353130.2442.177.camel@twins>
	 <CADZ9YHiGjjGJjxKj4WKWydqAz0zxFwY5=LsYBKhEREuZm=bKpg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-12 at 23:08 +0600, Rakib Mullick wrote:

> That might be the case for scheduler_ipi(), but when
> sched_ttwu_pending() gets called when a cpu goes down, all tasks from
> wake_list of that cpu has been moved without TASK_WAKING is set. For a
> particular task it might be possible that when it ran previously it
> had p->sched_contributes_to_load is set. Latter, this task's cpu has
> been put down and calls sched_ttwu_pending(), then for that task
> p->sched_contributes_to_load is set and TASK_WAKING is not set.
> Couldn't be happen?

No, look again, its impossible to be on that list and not be
TASK_WAKING.

The only way onto the list is through ttwu_queue_remote(), the only way
off the list is through sched_ttwu_pending(). 
