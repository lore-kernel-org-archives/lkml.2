Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359Ab1GYIVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 04:21:45 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:33428 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab1GYIVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 04:21:38 -0400
X-ASG-Debug-ID: 1311582088-01de280c1eec9b0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E2D2784.3060701@fusionio.com>
Date: Mon, 25 Jul 2011 10:21:24 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>
CC: Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Roland Dreier <roland@purestorage.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] block: strict rq_affinity
References: <20110722205736.17420.41366.stgit@localhost6.localdomain6> <20110722205938.17420.68621.stgit@localhost6.localdomain6> <4E2B15DB.4090302@fusionio.com> <CANejiEVMHhOW0N4Wn9LG0NAXMX3uOz5QzcRXZV4Ow4RTsMvN5Q@mail.gmail.com>
X-ASG-Orig-Subj: Re: [RFC PATCH 1/2] block: strict rq_affinity
In-Reply-To: <CANejiEVMHhOW0N4Wn9LG0NAXMX3uOz5QzcRXZV4Ow4RTsMvN5Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1311582088
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=INFO_TLD
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.69905
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 INFO_TLD               URI: Contains an URL in the INFO top-level domain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-25 03:14, Shaohua Li wrote:
> 2011/7/24 Jens Axboe <jaxboe@fusionio.com>:
>> On 2011-07-22 22:59, Dan Williams wrote:
>>> Some storage controllers benefit from completions always being steered
>>> to the strict requester cpu rather than the looser "per-socket" steering
>>> that blk_cpu_to_group() attempts by default.
>>>
>>> echo 2 > /sys/block/<bdev>/queue/rq_affinity
>>
>> I have applied this one, with a modified patch description.
>>
>> I like the adaptive solution, but it should be rewritten to not declare
>> and expose softirq internals. Essentially have an API from
>> kernel/softirq.c that can return whether a given (or perhaps just local)
>> softirq handler is busy or not.
> Jens,
> I posted a similar patch about two years ago(
> http://marc.info/?l=linux-kernel&m=126136252929329&w=2).
> At that time, you actually did a lot of tests and said the same cpu
> approach will cause huge lock contention and bounce. Is that get fixed?

Yep, it's not ideal. But if we are running out of steam on a single
processor, there's really not much of an option currently.

-- 
Jens Axboe

