Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab1HEHdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 03:33:10 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:51887 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724Ab1HEHdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 03:33:06 -0400
X-ASG-Debug-ID: 1312529582-01de280c1e1238f0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E3B9CAC.7020802@fusionio.com>
Date: Fri, 5 Aug 2011 09:33:00 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Tao Ma <tm@tao.ma>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Roland Dreier <roland@purestorage.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] block: Make rq_affinity = 1 work as expected.
References: <1312519150-3261-1-git-send-email-tm@tao.ma>
X-ASG-Orig-Subj: Re: [PATCH] block: Make rq_affinity = 1 work as expected.
In-Reply-To: <1312519150-3261-1-git-send-email-tm@tao.ma>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1312529582
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.70956
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-05 06:39, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> Commit 5757a6d76c introduced a new rq_affinity = 2 so as to make
> the request completed in the __make_request cpu. But it makes the
> old rq_affinity = 1 not work any more. The root cause is that
> if the 'cpu' and 'req->cpu' is in the same group and cpu != req->cpu,
> ccpu will be the same as group_cpu, so the completion will be
> excuted in the 'cpu' not 'group_cpu'.
> 
> This patch fix problem by simpling removing group_cpu and the codes
> are more explicit now. If ccpu == cpu, we complete in cpu, otherwise
> we raise_blk_irq to ccpu.

Thanks Tao Ma, much more readable too.

-- 
Jens Axboe

