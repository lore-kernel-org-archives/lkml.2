Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311Ab1CYHsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 03:48:12 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:48476 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932788Ab1CYHsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 03:48:10 -0400
X-ASG-Debug-ID: 1301039289-03d6a543e200840001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D8C48B6.6050300@fusionio.com>
Date: Fri, 25 Mar 2011 08:48:06 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Justin TerAvest <teravest@google.com>
CC: Vivek Goyal <vgoyal@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>
Subject: Re: Why do we use cpu nice priority for ioprio?
References: <BANLkTimiL5VZki4oUaw5hQYgB=E2jYwKrw@mail.gmail.com>
X-ASG-Orig-Subj: Re: Why do we use cpu nice priority for ioprio?
In-Reply-To: <BANLkTimiL5VZki4oUaw5hQYgB=E2jYwKrw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301039289
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.58905
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-25 03:38, Justin TerAvest wrote:
> It's not clear why the cpu nice value should be mapped to the ioprio
> for a task when none is picked.
> 
> Internally, at cfq_init_prio_data(), we just set:
> 		ioprio = IOPRIO_NORM;
> 		ioprio_class = IOPRIO_CLASS_BE;
> if ioprio_class is IOPRIO_CLASS_NONE.
> 
> 
> The problem is that  today, SCHED_RR and SCHED_FIFO threads
> automatically get bumped up to RT class. This all happens behind the
> curtains and the io_class of the thread is still shown as NONE with
> sys_ioprio_get(). What's the motivation behind this promotion of
> ioprio class?

It was decided back in the day when io priorities were introduced. I
still think it's a good idea. You could argue that auto-bumping up to
IOPRIO_CLASS_RT is a bit heavy handed. But is it really that different
from the CPU scheduling?

So, from memory, the difference between RR and FIFO on the CPU
scheduling side is that one of them will relingiush the CPU for a brief
period once in a while. Correct? That does not happen for
IOPRIO_CLASS_RT. So at least from that perspective, it's not a complete
match and might be a cause for concern.

-- 
Jens Axboe

