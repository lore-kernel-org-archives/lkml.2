Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab1EQBr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 21:47:59 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43722 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab1EQBr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 21:47:58 -0400
Subject: Re: [PATCH 1/3] comm: Introduce comm_lock seqlock to protect
 task->comm access
From: John Stultz <john.stultz@linaro.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
In-Reply-To: <4DD19EB5.7060900@gmail.com>
References: <1305580757-13175-1-git-send-email-john.stultz@linaro.org>
	 <1305580757-13175-2-git-send-email-john.stultz@linaro.org>
	 <4DD19EB5.7060900@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 18:47:47 -0700
Message-ID: <1305596867.2915.109.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-17 at 00:01 +0200, Jiri Slaby wrote:
> On 05/16/2011 11:19 PM, John Stultz wrote:
> > diff --git a/include/linux/init_task.h b/include/linux/init_task.h
> > index caa151f..b69d94b 100644
> > --- a/include/linux/init_task.h
> > +++ b/include/linux/init_task.h
> > @@ -161,6 +161,7 @@ extern struct cred init_cred;
> >  	.group_leader	= &tsk,						\
> >  	RCU_INIT_POINTER(.real_cred, &init_cred),			\
> >  	RCU_INIT_POINTER(.cred, &init_cred),				\
> > +	.comm_lock	= __SPIN_LOCK_UNLOCKED(tsk.comm_lock),		\
> 
> Hmm, you should also init the spinlock somewhere in copy_process.
> Otherwise when a process is forked in the middle of [gs]et_task_comm
> called on it on another cpu, you have two locked locks and only the
> parent's will be unlocked, right?

Ah, yep. Fixed for the next version.

thanks!
-john

