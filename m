Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab1GWSia (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 14:38:30 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:54963 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab1GWSi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 14:38:27 -0400
X-ASG-Debug-ID: 1311446304-01de280c1eeac60001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E2B151C.6080900@fusionio.com>
Date: Sat, 23 Jul 2011 20:38:20 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Dan Williams <dan.j.williams@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] block: strict rq_affinity
References: <20110722205736.17420.41366.stgit@localhost6.localdomain6> <20110722205938.17420.68621.stgit@localhost6.localdomain6> <20110723014633.GA32507@infradead.org>
X-ASG-Orig-Subj: Re: [RFC PATCH 1/2] block: strict rq_affinity
In-Reply-To: <20110723014633.GA32507@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1311446304
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.69773
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-23 03:46, Christoph Hellwig wrote:
> On Fri, Jul 22, 2011 at 01:59:39PM -0700, Dan Williams wrote:
>> Some storage controllers benefit from completions always being steered
>> to the strict requester cpu rather than the looser "per-socket" steering
>> that blk_cpu_to_group() attempts by default.
> 
> Isn't this actually dependent on the cpu, and not the storage
> controller?

It is, it's completely indendent of the controller used. Perhaps some
drivers could have a very heavy end io completion handling causing the
problem to become larger, but in general it's an artifact of the CPU and
not the controller.

-- 
Jens Axboe

