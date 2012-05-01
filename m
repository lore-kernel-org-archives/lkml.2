Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533Ab2EASFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 14:05:04 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:54126 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758469Ab2EASFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 14:05:02 -0400
X-ASG-Debug-ID: 1335895501-03d6a52572ca670001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4FA025CA.9060506@fusionio.com>
Date: Tue, 1 May 2012 20:04:58 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH v3.4-rc5] block: iocontext->nr_tasks should be initialized
 to one
References: <1335873936.16988.148.camel@lappy> <20120501161729.GV26595@google.com>
X-ASG-Orig-Subj: Re: [PATCH v3.4-rc5] block: iocontext->nr_tasks should be initialized
 to one
In-Reply-To: <20120501161729.GV26595@google.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1335895501
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -1.52
X-Barracuda-Spam-Status: No, SCORE=-1.52 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_SA620b, MAILTO_TO_SPAM_ADDR
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.95708
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 MAILTO_TO_SPAM_ADDR    URI: Includes a link to a likely spammer email
	0.50 BSF_SC0_SA620b         Custom Rule SA620b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-01 18:17, Tejun Heo wrote:
> create_task_io_context() left ioc->nr_tasks at zero; however, a newly
> created ioc should have its nr_tasks initialized to one as it begins
> attached to the task creating it.
> 
> This affects only CLONE_IO which currently doesn't seem to have any
> actual user.  Sasha triggered WARN_ON_ONCE() in ioc_task_link() using
> syscall fuzzer.  Even when it happens, the failure mode isn't critical
> (blk-cgroup may allow attaching a CLONE_IO'd task to a cgroup when it
> shouldn't and blkcg limits may behave weirdly).
> 
> Fix it by initializing it to one in create_task_io_context().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Sasha Levin <levinsasha928@gmail.com>
> LKML-Reference: <1335873936.16988.148.camel@lappy>
> Cc: stable@vger.kernel.org

BTW, this only affects for-3.5/core, it's not a mainline bug. So I've
dropped the stable CC.

-- 
Jens Axboe

