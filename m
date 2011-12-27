Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab1L0SLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 13:11:10 -0500
Received: from mx2.fusionio.com ([66.114.96.31]:38177 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662Ab1L0SLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 13:11:08 -0500
X-Greylist: delayed 1076 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Dec 2011 13:11:08 EST
X-ASG-Debug-ID: 1325008391-01de2831c3363a0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4EFA0604.1030607@fusionio.com>
Date: Tue, 27 Dec 2011 18:53:08 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH block/for-3.3/core] block: remove WARN_ON_ONCE() in exit_io_context()
References: <1324892810.31721.0.camel@lappy> <20111227173559.GD17712@google.com>
X-ASG-Orig-Subj: Re: [PATCH block/for-3.3/core] block: remove WARN_ON_ONCE() in exit_io_context()
In-Reply-To: <20111227173559.GD17712@google.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1325008391
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.50
X-Barracuda-Spam-Status: No, SCORE=0.50 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_SA620b, MAILTO_TO_SPAM_ADDR
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.84290
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 MAILTO_TO_SPAM_ADDR    URI: Includes a link to a likely spammer email
	0.50 BSF_SC0_SA620b         Custom Rule SA620b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-27 18:35, Tejun Heo wrote:
> 6e736be7 "block: make ioc get/put interface more conventional and fix
> race on alloction" added WARN_ON_ONCE() in exit_io_context() which
> triggers if !PF_EXITING.  All tasks hitting exit_io_context() from
> task exit should have PF_EXITING set but task struct tearing down
> after fork failure calls into the function without PF_EXITING,
> triggering the condition.
> 
>   WARNING: at block/blk-ioc.c:234 exit_io_context+0x40/0x92()
>   Pid: 17090, comm: trinity Not tainted 3.2.0-rc6-next-20111222-sasha-dirty #77
>   Call Trace:
>    [<ffffffff810b69a3>] warn_slowpath_common+0x8f/0xb2
>    [<ffffffff810b6a77>] warn_slowpath_null+0x18/0x1a
>    [<ffffffff8181a7a2>] exit_io_context+0x40/0x92
>    [<ffffffff810b58c9>] copy_process+0x126f/0x1453
>    [<ffffffff810b5c1b>] do_fork+0x120/0x3e9
>    [<ffffffff8106242f>] sys_clone+0x26/0x28
>    [<ffffffff82425803>] stub_clone+0x13/0x20
>   ---[ end trace a2e4eb670b375238 ]---
> 
> Reported-by: Sasha Levin <levinsasha928@gmail.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
> Heh, sorry about that.  Forgot about fork failure path.  Just removing
> the WARN_ON_ONCE() should be enough.  Thanks for reporting the problem.

Thanks, applied.

-- 
Jens Axboe

