Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab1FGIc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 04:32:27 -0400
Received: from ccserver1.unican.es ([130.206.5.100]:52466 "EHLO
	ccserver1.unican.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab1FGIcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 04:32:24 -0400
Message-ID: <4DEDE232.4090007@unican.es>
Date: Tue, 7 Jun 2011 10:32:50 +0200
From: Monica Puig-Pey <puigpeym@unican.es>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) 
	Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: <hannes_bauer@aon.at>
CC: Peter Zijlstra <peterz@infradead.org>,
        Rolando Martins <rolando.martins@gmail.com>,
        <linux-rt-users@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>
Subject: Re: Changing Kernel thread priorities
References: <17185480.5304.1307435255996.JavaMail.root@WARSBL214.highway.tel
	ekom.at>
In-Reply-To: <17185480.5304.1307435255996.JavaMail.root@WARSBL214.highway.te
	lekom.at>
Content-Type: text/plain;
	charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [193.144.198.131]
X-imss-version: 2.054
X-imss-result: Passed
X-imss-scanInfo: M:P L:N SM:0
X-imss-tmaseResult: TT:0 TS:0.0000 TC:00 TRN:0 TV:6.5.1024(18184.005)
X-imss-scores: Clean:99.90000 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:1 C:1 M:2 S:2 R:2 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 07/06/11 10:27, Johannes Bauer escribió:
> Absolutly correct!
>
> However, if you are running the system on an embedded platform, where the _WHOLE_ system (including priorities) is preconfigured and never touched, starting a irq thread with the right prio from start is a more straightforward method than having to invoke a script that changes it using userspace chrt tool.
>
> Regards JB
> ----- Ursprüngliche Nachricht -----
> Von: "Peter Zijlstra"<peterz@infradead.org>
> Erhalten: 07.06.2011 00:36
> An: hannes_bauer@aon.at
>
> "Monica Puig-Pey" wrote:
>>
>> I need to change the priority from inside the driver, when creating the
>> kernel thread.
>
> No you don't. How does you driver know about what priority is correct
> wrt all the other running RT tasks on the system?
>
> Determining the right priority in a fixed priority scheduling system is
> a system wide problem, nobody but the administrator can possibly even
> begin to solve it.
>
> There's a reason all RT irq threads are started at 50, its plain
> impossible to do better.
>

That's it!
If I work with embedded system where I know all my tasks running and 
there is not a user how could I do it?

What I tried is create the kernel thread in my init_module using:

	#include <linux/kthread.h>

	struct task_struct *kthread_create(int (*threadfn)(void *data),
				   void *data,
				   const char namefmt[], ...)
and then running it with:

	#include <linux/sched.h>
	
	extern int wake_up_process(struct task_struct *tsk);

These functions stars a Kthread which has a NON RT priority. I can see 
this using the ps command from user space.
Because it's not a real time thread is why I want, better need, to 
change its priority, to have only real time threads running in my 
driver. I want to use the Kthread as a bottom half for the interrupts.

How could I create real time kernel threads then? is kthread_create 
wrong for real time enviroment?


-- 
__________________________________________________________________________________

Mónica Puig-Pey González       E-mail: puigpeym@unican.es

Grupo de Computadores y Tiempo Real, Departamento de Electrónica y 
Computadores.
Facultad de Ciencias - Universidad de Cantabria
Av. de los Castros s/n. 39005 - Santander, España
__________________________________________________________________________________
