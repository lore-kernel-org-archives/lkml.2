Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406Ab1IOL2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 07:28:37 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:45564 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933271Ab1IOL2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 07:28:36 -0400
X-ASG-Debug-ID: 1316086114-03d6a5396910d570001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E71E15F.1050507@fusionio.com>
Date: Thu, 15 Sep 2011 13:28:31 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Tao Ma <tm@tao.ma>, Shaohua Li <shli@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] block: Don't check QUEUE_FLAG_SAME_COMP in __blk_complete_request.
References: <1315984992-5158-1-git-send-email-tm@tao.ma> <1315984992-5158-2-git-send-email-tm@tao.ma> <CANejiEWa5um5LtRkL3NcbNgBnUCG1Ud8qw-hfXW3X3GPfHv4iQ@mail.gmail.com> <4E715FE2.7040004@tao.ma> <20110915111728.GA6275@infradead.org>
X-ASG-Orig-Subj: Re: [PATCH RESEND] block: Don't check QUEUE_FLAG_SAME_COMP in __blk_complete_request.
In-Reply-To: <20110915111728.GA6275@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.101.1.21]
X-Barracuda-Start-Time: 1316086114
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.74588
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-15 13:17, Christoph Hellwig wrote:
> On Thu, Sep 15, 2011 at 10:16:02AM +0800, Tao Ma wrote:
>>> why not delete bio_set_completion_cpu()?
>> Not sure. It is added in commit c7c22e4d from the very beginning, and in
>> the commit log Jens described it as:
>> A bio helper (bio_set_completion_cpu()) is also added, so that queuers
>> can ask for completion on that specific CPU. Maybe it is obsolete.
>> Anyway, I am fine to generate a patch to remove it if you prefer.
>>> 1. nobody uses it in my search
>> yes, but it may be designed for someone to use it. The same goes with
>> BIO_CPU_AFFINE.
> 
> This code is unused, and from the all the discussions lately pretty
> obviously broken.  The only thing keeping it serves is creating more
> confusion and possibly more bugs.

We can kill bio_set_completion_cpu(). I'm fine with leaving cpu control
to the request based drivers, they are the only ones that can toggle the
setting anyway.

-- 
Jens Axboe

