Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab1HKIjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 04:39:55 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:34961 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab1HKIjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 04:39:52 -0400
X-ASG-Debug-ID: 1313051991-03d6a510aa298220001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E439554.2070508@fusionio.com>
Date: Thu, 11 Aug 2011 10:39:48 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: "boyu.mt@taobao.com" <boyu.mt@taobao.com>,
        Christoph Hellwig <hch@infradead.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch]block: revert a patch
References: <1313046710.27321.7.camel@sli10-conroe>
X-ASG-Orig-Subj: Re: [patch]block: revert a patch
In-Reply-To: <1313046710.27321.7.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1313051991
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.71438
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-11 09:11, Shaohua Li wrote:
> This patch reverts commit 35ae66e0a09ab70ed(block: Make rq_affinity = 1
> work as expected). The purpose is to avoid an unnecessary IPI.
> Let's take an example. My test box has cpu 0-7, one socket. Say request is
> added from CPU 1, blk_complete_request() occurs at CPU 7. Without the reverted
> patch, softirq will be done at CPU 7. With it, an IPI will be directed to CPU
> 0, and softirq will be done at CPU 0. In this case, doing softirq at CPU 0 and
> CPU 7 have no difference from cache sharing point view and we can avoid an
> ipi if doing it in CPU 7.
> An immediate concern is this is just like QUEUE_FLAG_SAME_FORCE, but actually
> not. blk_complete_request() is running in interrupt handler, and currently
> I/O controller doesn't support multiple interrupts (I checked several LSI
> cards and AHCI), so only one CPU can run blk_complete_request(). This is
> still quite different as QUEUE_FLAG_SAME_FORCE.
> Since only one CPU runs softirq, the only difference with below patch is
> softirq not always runs at the first CPU of a group.

Thanks, I applied this but fixed up your subject line. You can't just
call it 'revert a patch', does not carry a lot of meaning!

-- 
Jens Axboe

