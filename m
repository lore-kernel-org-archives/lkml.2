Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab1C2Gfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 02:35:34 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:54415 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab1C2Gfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 02:35:32 -0400
X-ASG-Debug-ID: 1301380531-01de284cf8d0610001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D917DB1.9030300@fusionio.com>
Date: Tue, 29 Mar 2011 08:35:29 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Rob Landley <rlandley@parallels.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: Commit 7eaceaccab5f40 causing boot hang.
References: <4D9179EE.9040707@parallels.com>
X-ASG-Orig-Subj: Re: Commit 7eaceaccab5f40 causing boot hang.
In-Reply-To: <4D9179EE.9040707@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301380531
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.50
X-Barracuda-Spam-Status: No, SCORE=0.50 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_RULE7568M
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.59286
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.50 BSF_RULE7568M          Custom Rule 7568M
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-29 08:19, Rob Landley wrote:
> Using the attached config (run through oldconfig and holding down
> enter), 2.6.38 boots but current -git hangs.  I've bisected it to this
> commit:
> 
> 7eaceaccab5f40bbfda044629a6298616aeaed50 is the first bad commit
> commit 7eaceaccab5f40bbfda044629a6298616aeaed50
> Author: Jens Axboe <jaxboe@fusionio.com>
> Date:   Thu Mar 10 08:52:07 2011 +0100
> 
>     block: remove per-queue plugging
> 
>     Code has been converted over to the new explicit on-stack plugging,
>     and delay users have been converted to use the new API for that.
>     So lets kill off the old plugging along with aops->sync_page().
> 
>     Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
> 
> I suspect it broke CONFIG_IDE_GD_ATA.  (The symptoms change a bit in
> later versions, when that was first introduced it hung right after
> discovering hda, now it makes it to freeing kernel memory and then hangs
> trying to launch init.  But "the disk hangs a lot" still seems to
> describe the problem.)

That is the case even with 9ced0b95b3993660e7990cf6bf68c1a80f31544e,
which was otherwise supposed to fix this queue stall?

-- 
Jens Axboe

