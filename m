Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab1EKBQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 21:16:13 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:39638 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab1EKBQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 21:16:12 -0400
Subject: Re: [PATCH 2/3] printk: Add %ptc to safely print a task's comm
From: john stultz <johnstul@us.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
In-Reply-To: <1305076246.2939.67.camel@work-vm>
References: <1305073386-4810-1-git-send-email-john.stultz@linaro.org>
	 <1305073386-4810-3-git-send-email-john.stultz@linaro.org>
	 <1305075090.19586.189.camel@Joe-Laptop>  <1305076246.2939.67.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 18:16:01 -0700
Message-ID: <1305076561.2939.72.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 18:10 -0700, John Stultz wrote:
> On Tue, 2011-05-10 at 17:51 -0700, Joe Perches wrote:
> > Could misuse of %ptc (not using current) cause system lockup?
> 
> It very well could. Although I don't see other %p options tring to
> handle invalid pointers. Any suggestions on how to best handle this?

And just to clarify on this point, I'm responding to if a invalid
pointer was provided, causing the dereference to go awry.

If a valid non-current task was provided, the locking should be ok as we
disable irqs while the write_seqlock is held in set_task_comm().

The only places this could cause a problem was if you tried to printk
with a %ptc while holding the task->comm_lock. However, the lock is only
shortly held in task_comm_string, and get_task_comm and set_task_comm.
So it is fairly easy to audit for correctness.

If there is some other situation you had in mind, please let me know.

thanks
-john


