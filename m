Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319Ab1CCPyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 10:54:12 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:59438 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758220Ab1CCPyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 10:54:08 -0500
X-ASG-Debug-ID: 1299167647-03d6a50f0b10d2c0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D6FB99C.5050306@fusionio.com>
Date: Thu, 3 Mar 2011 10:54:04 -0500
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Tao Ma <tm@tao.ma>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blktrace: Remove blk_fill_rwbs_rq.
References: <1299137380-4119-1-git-send-email-tm@tao.ma>
X-ASG-Orig-Subj: Re: [PATCH] blktrace: Remove blk_fill_rwbs_rq.
In-Reply-To: <1299137380-4119-1-git-send-email-tm@tao.ma>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299167647
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.56943
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-03 02:29, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> If we enable trace events to trace block actions, We use
> blk_fill_rwbs_rq to analyze the corresponding actions
> in request's cmd_flags, but we only choose the minor 2 bits
> from it, so most of other flags(e.g, REQ_SYNC) are missing.
> For example, with a sync write we get:
> write_test-2409  [001]   160.013869: block_rq_insert: 3,64 W 0 () 258135 + 8 [write_test]
> 
> Since now we have integrated the flags of both bio and request,
> it is safe to pass rq->cmd_flags directly to blk_fill_rwbs and
> blk_fill_rwbs_rq isn't needed any more.
> 
> With this patch, after a sync write we get:
> write_test-2417  [000]   226.603878: block_rq_insert: 3,64 WS 0 () 258135 + 8 [write_test]

Thanks, I applied this to for-linus so we can sneak it into 2.6.38
hopefully.


-- 
Jens Axboe

