Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab2APJv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 04:51:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57068 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab2APJvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 04:51:54 -0500
Message-ID: <1326707503.2442.219.camel@twins>
Subject: Re: [PATCH] sched: Accelerate "pick_next_entity" under special
 condition
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 16 Jan 2012 10:51:43 +0100
In-Reply-To: <4F13EFBE.1030002@linux.vnet.ibm.com>
References: <4F13EFBE.1030002@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-16 at 17:37 +0800, Michael Wang wrote:
> From: Michael Wang <wangyun@linux.vnet.ibm.com>
> 
> We can avoid some useless operation in some special condition.

This is a pretty empty statement.

> For example:
> If we have "cfs_rq->next" and it can be use, we just return it directly.

What it doesn't state is what it actually does, if it affects the common
case and performance numbers (or a good reason for the lack thereof).

> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> ---
>  kernel/sched/fair.c |   28 +++++++++++++++++-----------
>  1 files changed, 17 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 84adb2d..9fc2c3c 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1295,6 +1295,8 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  static int
>  wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
>  
> +#define ENTITY_PREEMPT_ALLOWED(prev,next)	(wakeup_preempt_entity(prev, next) < 1)

This is just uglification imo, its shouting and it doesn't actually win
you much space.

