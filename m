Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab1CKTMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 14:12:44 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:55463 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851Ab1CKTMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 14:12:43 -0500
X-ASG-Debug-ID: 1299870762-01de284cf84b2d0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D7A7425.4030400@fusionio.com>
Date: Fri, 11 Mar 2011 20:12:37 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Tao Ma <tm@tao.ma>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blktrace: Use rq->cmd_flags directly in blk_add_trace_rq.
References: <1299219358-17507-1-git-send-email-tm@tao.ma>
X-ASG-Orig-Subj: Re: [PATCH] blktrace: Use rq->cmd_flags directly in blk_add_trace_rq.
In-Reply-To: <1299219358-17507-1-git-send-email-tm@tao.ma>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299870762
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.57661
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-04 07:15, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In blk_add_trace_rq, we only chose the minor 2 bits from
> request's cmd_flags and did some check for discard.
> so most of other flags(e.g, REQ_SYNC) are missing.
> 
> For example, with a sync write after blkparse we get:
>   8,16   1        1     0.001776503  7509  A  WS 1349632 + 1024 <- (8,17) 1347584
>   8,16   1        2     0.001776813  7509  Q  WS 1349632 + 1024 [dd]
>   8,16   1        3     0.001780395  7509  G  WS 1349632 + 1024 [dd]
>   8,16   1        5     0.001783186  7509  I   W 1349632 + 1024 [dd]
>   8,16   1       11     0.001816987  7509  D   W 1349632 + 1024 [dd]
>   8,16   0        2     0.006218192     0  C   W 1349632 + 1024 [0]
> 
> Since now we have integrated the flags of both bio and request,
> it is safe to pass rq->cmd_flags directly to __blk_add_trace.
> 
> With this patch, after a sync write we get:
>   8,16   1        1     0.001776900  5425  A  WS 1189888 + 1024 <- (8,17) 1187840
>   8,16   1        2     0.001777179  5425  Q  WS 1189888 + 1024 [dd]
>   8,16   1        3     0.001780797  5425  G  WS 1189888 + 1024 [dd]
>   8,16   1        5     0.001783402  5425  I  WS 1189888 + 1024 [dd]
>   8,16   1       11     0.001817468  5425  D  WS 1189888 + 1024 [dd]
>   8,16   0        2     0.005640709     0  C  WS 1189888 + 1024 [0]

Thanks, applied!

-- 
Jens Axboe

