Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab1FGInt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 04:43:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:39258 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1FGInr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 04:43:47 -0400
Date: Tue, 7 Jun 2011 10:43:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Monica Puig-Pey <puigpeym@unican.es>
cc: hannes_bauer@aon.at, Peter Zijlstra <peterz@infradead.org>,
        Rolando Martins <rolando.martins@gmail.com>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Changing Kernel thread priorities
In-Reply-To: <4DEDE232.4090007@unican.es>
Message-ID: <alpine.LFD.2.02.1106071041550.11814@ionos>
References: <17185480.5304.1307435255996.JavaMail.root@WARSBL214.highway.tel ekom.at> <4DEDE232.4090007@unican.es>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1939963718-1307436224=:11814"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1939963718-1307436224=:11814
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 7 Jun 2011, Monica Puig-Pey wrote:
> El 07/06/11 10:27, Johannes Bauer escribió:
> > There's a reason all RT irq threads are started at 50, its plain
> > impossible to do better.
> > 
> 
> That's it!
> If I work with embedded system where I know all my tasks running and there is
> not a user how could I do it?

init scripts run from user space and you can adjust the priority there.
 
> What I tried is create the kernel thread in my init_module using:
> 
> 	#include <linux/kthread.h>
> 
> 	struct task_struct *kthread_create(int (*threadfn)(void *data),
> 				   void *data,
> 				   const char namefmt[], ...)
> and then running it with:
> 
> 	#include <linux/sched.h>
> 	
> 	extern int wake_up_process(struct task_struct *tsk);
> 
> These functions stars a Kthread which has a NON RT priority. I can see this
> using the ps command from user space.
> Because it's not a real time thread is why I want, better need, to change its
> priority, to have only real time threads running in my driver. I want to use
> the Kthread as a bottom half for the interrupts.

Use threaded interrupt handlers. That's what they are made for.

Thanks,

	tglx
--8323328-1939963718-1307436224=:11814--
