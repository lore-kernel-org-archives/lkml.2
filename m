Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab0E1PPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 11:15:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53702 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758434Ab0E1PPH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 11:15:07 -0400
Subject: Re: [PATCH] tracing: Add task activate/deactivate tracepoints
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1275056762-13130-1-git-send-regression-fweisbec@gmail.com>
References: <1275056762-13130-1-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 28 May 2010 17:15:10 +0200
Message-ID: <1275059710.27810.9624.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-28 at 16:26 +0200, Frederic Weisbecker wrote:
> We have various tracepoints that tell us when a task is going to
> be enqueued in a runqueue: fork, wakeup, migrate.
> 
> But they don't always provide us the level of information necessary
> to know what is actually in which runqueue, precisely because the
> migrate event is only fired if the task is queued on another
> cpu than its previous one. So we don't always know where a waking up
> task goes.
> 
> And moreover we don't have events that tells a task goes to sleep,
> and even that wouldn't cover every cases when a task is dequeued.
> 
> So bring these two new tracepoints to get informations about the
> load of each runqueues.

NAK, aside from a few corner cases wakeup and sleep are the important
points.

The activate and deactivate functions are implementation details.
