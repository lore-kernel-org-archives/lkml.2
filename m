Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab1GTTL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 15:11:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:33398 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab1GTTLz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 15:11:55 -0400
Subject: Re: sched: fix/optimise some issues
From: Peter Zijlstra <peterz@infradead.org>
To: stephan.baerwolf@tu-ilmenau.de
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        ncrao@google.com
In-Reply-To: <4E26DB41.9070002@tu-ilmenau.de>
References: <4E26DB41.9070002@tu-ilmenau.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Jul 2011 21:11:33 +0200
Message-ID: <1311189093.29152.74.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-20 at 15:42 +0200, Stephan Bärwolf wrote:
> "entity_key()" is only used in "__enqueue_entity()" and
> its only function is to subtract a tasks vruntime by
> its groups minvruntime.
> Before this patch a rbtree enqueue-decision is done by
> comparing two tasks in the style:
> 
>         "if (entity_key(cfs_rq, se) < entity_key(cfs_rq, entry))"
> 
> which would be
> 
>         "if (se->vruntime-cfs_rq->min_vruntime < entry->vruntime-cfs_rq->min_vruntime)"
> 
> or (if reducing cfs_rq->min_vruntime out)
> 
>         "if (se->vruntime < entry->vruntime)"
> 
> which is
> 
>         "if (entity_before(se, entry))"
> 
> So we do not need "entity_key()".
> If "entity_before()" is inline we will also save one subtraction (only one,
> because "entity_key(cfs_rq, se)"  was cached in "key") 

Indeed, thanks!
