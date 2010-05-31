Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab0EaIBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 04:01:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52349 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316Ab0EaIBA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 04:01:00 -0400
Subject: Re: [PATCH 4/4] sched: add hooks for workqueue
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <1273747705-7829-5-git-send-email-tj@kernel.org>
References: <1273747705-7829-1-git-send-email-tj@kernel.org>
	 <1273747705-7829-5-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 31 May 2010 10:01:07 +0200
Message-ID: <1275292867.27810.21442.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 12:48 +0200, Tejun Heo wrote:
> Concurrency managed workqueue needs to know when workers are going to
> sleep and waking up, and, when a worker goes to sleep, be able to wake
> up another worker to maintain adequate concurrency.  This patch
> introduces PF_WQ_WORKER to identify workqueue workers and adds the
> following two hooks.
> 
> * wq_worker_waking_up(): called when a worker is woken up.
> 
> * wq_worker_sleeping(): called when a worker is going to sleep and may
>   return a pointer to a local task which should be woken up.  The
>   returned task is woken up using try_to_wake_up_local() which is
>   simplified ttwu which is called under rq lock and can only wake up
>   local tasks.

This changelog seems to lack explanation for why you need the wakeup
callback.
