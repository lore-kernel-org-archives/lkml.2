Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab1GZF0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 01:26:20 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:37986 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab1GZF0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 01:26:14 -0400
X-ASG-Debug-ID: 1311657973-03d6a510a81d55a0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E2E4FF1.1010103@fusionio.com>
Date: Tue, 26 Jul 2011 07:26:09 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: block: BUG: using smp_processor_id() in preemptible [00000000]
 code
References: <CACVXFVOYYZt-XfbPx_dEOm9qOAuGqmviH4TdXxg6xTrrB8PaMQ@mail.gmail.com>
X-ASG-Orig-Subj: Re: block: BUG: using smp_processor_id() in preemptible [00000000]
 code
In-Reply-To: <CACVXFVOYYZt-XfbPx_dEOm9qOAuGqmviH4TdXxg6xTrrB8PaMQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1311657973
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.69990
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-26 06:49, Ming Lei wrote:
> Hi,
> 
> The bug is observed in -next-20110725, follows the stack trace[1], and
> seems the attachment patch can fix the bug.

Does this work, too? We don't necessarily need the CPU stable, but
spewing debug output isn't very nice.

diff --git a/block/blk-core.c b/block/blk-core.c
index f8cb099..f925581 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1283,7 +1283,7 @@ get_rq:
 
 	if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) ||
 	    bio_flagged(bio, BIO_CPU_AFFINE))
-		req->cpu = smp_processor_id();
+		req->cpu = raw_smp_processor_id();
 
 	plug = current->plug;
 	if (plug) {

-- 
Jens Axboe

