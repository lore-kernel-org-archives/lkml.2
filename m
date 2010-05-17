Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab0EQIwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 04:52:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46002 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab0EQIwo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 04:52:44 -0400
Subject: Re: commit e9e9250b: sync wakeup bustage when waker is an RT task
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1274086140.5605.3719.camel@twins>
References: <1273924628.10630.24.camel@marge.simson.net>
	 <1273925052.1674.138.camel@laptop>
	 <1273943222.8752.7.camel@marge.simson.net>
	 <1273994510.7873.10.camel@marge.simson.net>
	 <1274071120.15000.10.camel@marge.simson.net>
	 <1274086140.5605.3719.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 17 May 2010 10:52:25 +0200
Message-ID: <1274086345.5605.3727.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 10:49 +0200, Peter Zijlstra wrote:
> On Mon, 2010-05-17 at 06:38 +0200, Mike Galbraith wrote:
> > What would be the harm/consequence of restoring RT tasks to rq->load so
> > the wake_affine()::sync logic just worked as before without hackery?
> 
> Well, you'd have to constantly adjust the task weight of RT tasks to
> reflect their actual consumption. Not really feasible.
> 
> So the proportional stuff works like:
> 
>  slice_i = w_i / (\Sum_j w_j) * dt
> 
> Giving a RT task a sensible weight we'd have to reverse that:
> 
>  w_i = slice_i/dt * (\Sum_j w_j)

Another point to note is that this requires we track per-RT-task usage
averages, whereas the cpu_power approach simply lumps everything !fair
(one of the things still on the TODO list is account for IRQ overhead)
into a single large bucket and doesn't care.
