Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab1EWHFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 03:05:36 -0400
Received: from home.kolivas.org ([59.167.196.135]:58059 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab1EWHFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 03:05:35 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: question about blk_schedule_flush_plug
Date: Mon, 23 May 2011 17:05:19 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.39-ck1; KDE/4.6.2; x86_64; ; )
Cc: axboe@kernel.dk, mingo@elte.hu, peterz@infradead.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105231705.20168.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was looking at the scheduler changes going into 2.6.39 again and wondered 
about the use of blk_schedule_flush_plug smack in the middle of schedule()

It looks like this:
			if (blk_needs_flush_plug(prev)) {
				raw_spin_unlock(&rq->lock);
				blk_schedule_flush_plug(prev);
				raw_spin_lock(&rq->lock);
			}

Now call me suspicious but to my eyes it looks really dubious unlocking the 
runqueue like that right in the heart of schedule().

Comments?

Thanks,
Con
-- 
-ck
