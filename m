Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507Ab2EASCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 14:02:46 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:43339 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758489Ab2EASCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 14:02:44 -0400
X-ASG-Debug-ID: 1335895362-0421b5401d180a0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4FA0253F.4000302@fusionio.com>
Date: Tue, 1 May 2012 20:02:39 +0200
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
X-Barracuda-Start-Time: 1335895362
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.95708
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
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

CLONE_IO is an exported interface, it can be set from clone(2).
Otherwise Sasha would not have hit this :-)

Thanks, applied.

-- 
Jens Axboe

