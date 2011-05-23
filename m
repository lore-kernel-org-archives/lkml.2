Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab1EWHhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 03:37:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51783 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1EWHhh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 03:37:37 -0400
Subject: Re: question about blk_schedule_flush_plug
From: Peter Zijlstra <peterz@infradead.org>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, mingo@elte.hu
In-Reply-To: <201105231705.20168.kernel@kolivas.org>
References: <201105231705.20168.kernel@kolivas.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 23 May 2011 09:36:56 +0200
Message-ID: <1306136216.18455.3.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 17:05 +1000, Con Kolivas wrote:
> I was looking at the scheduler changes going into 2.6.39 again and wondered 
> about the use of blk_schedule_flush_plug smack in the middle of schedule()
> 
> It looks like this:
> 			if (blk_needs_flush_plug(prev)) {
> 				raw_spin_unlock(&rq->lock);
> 				blk_schedule_flush_plug(prev);
> 				raw_spin_lock(&rq->lock);
> 			}
> 
> Now call me suspicious but to my eyes it looks really dubious unlocking the 
> runqueue like that right in the heart of schedule().
> 
> Comments?

Yeah, that's quite all-right, both pre_schedule() and idle_balance()
already did that too.

We can safely release the runqueue lock after deactivate_task() and
before put_prev_task().
