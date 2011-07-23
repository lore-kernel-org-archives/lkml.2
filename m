Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab1GWSll (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 14:41:41 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:58879 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265Ab1GWSlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 14:41:36 -0400
X-ASG-Debug-ID: 1311446495-03d6a510a91c8250001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E2B15DB.4090302@fusionio.com>
Date: Sat, 23 Jul 2011 20:41:31 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: Christoph Hellwig <hch@infradead.org>,
        Roland Dreier <roland@purestorage.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] block: strict rq_affinity
References: <20110722205736.17420.41366.stgit@localhost6.localdomain6> <20110722205938.17420.68621.stgit@localhost6.localdomain6>
X-ASG-Orig-Subj: Re: [RFC PATCH 1/2] block: strict rq_affinity
In-Reply-To: <20110722205938.17420.68621.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1311446495
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.69772
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-22 22:59, Dan Williams wrote:
> Some storage controllers benefit from completions always being steered
> to the strict requester cpu rather than the looser "per-socket" steering
> that blk_cpu_to_group() attempts by default.
> 
> echo 2 > /sys/block/<bdev>/queue/rq_affinity

I have applied this one, with a modified patch description.

I like the adaptive solution, but it should be rewritten to not declare
and expose softirq internals. Essentially have an API from
kernel/softirq.c that can return whether a given (or perhaps just local)
softirq handler is busy or not.


-- 
Jens Axboe

