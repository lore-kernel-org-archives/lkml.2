Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab1FDM3x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 08:29:53 -0400
Received: from ccserver2.unican.es ([130.206.5.101]:41947 "EHLO
	ccserver2.unican.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab1FDM3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 08:29:52 -0400
Message-ID: <4DEA255B.2050503@unican.es>
Date: Sat, 4 Jun 2011 14:30:19 +0200
From: Monica Puig-Pey <puigpeym@unican.es>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) 
	Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: <linux-rt-users@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: kernel threads in drivers using the RT patch
References: <4DEA1BA9.7020303@unican.es> <4DEA1F22.6000603@unican.es>
In-Reply-To: <4DEA1F22.6000603@unican.es>
Content-Type: text/plain;
	charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [193.144.198.131]
X-imss-version: 2.054
X-imss-result: Passed
X-imss-scanInfo: M:P L:E SM:0
X-imss-tmaseResult: TT:0 TS:0.0000 TC:00 TRN:0 TV:6.5.1024(18178.007)
X-imss-scores: Clean:21.10485 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:1 C:1 M:2 S:2 R:2 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm studying how to develop drivers in a real time OS and how do they 
work. I'm using  Ubuntu 10.04 with the 2.6.31-11-rt patch installed.
I'm trying to run a kernel thread from my driver (kernel context). I 
create the kthread in the module_init, I change its real time priority 
and then make it run .
Code shown below:

thread_handler=*(struct task_struct *)kthread_create(my_tasklet_handler, 
(void*)&datos,"thread_handler");
   if (IS_ERR(&thread_handler)){
      return PTR_ERR(&thread_handler);
      printk(KERN_WARNING "<pci> (init_module)  Error creating Thread 
handler\n");
   }
params->sched_priority=20;
result = sched_setscheduler(&thread_handler, SCHED_FIFO, params);
result=wake_up_process(&thread_handler);

Params is global struct sched_param * and struct thread_handler  a 
global task_struct.

I stop the Kthread in the module_exit using 
res=kthread_stop(&thread_handler);

The kthread "thread_handler" has a while (1) loop and it is stopped in a 
semaphore, waiting for the interrupt handler. When it wakes up each time 
it calls kthread_should_stop() and depending on that break out of the 
loop or run.

My problem is, when trying to establish the rtprio kthread, the whole 
computer get blocked and I only can restart it. If I delete this part, 
then kthread runs, and works well. With the ps command I can see it has 
a 24 NON real time priority. Then the problem come when uninstalling my 
module with rmmod. In the  kthread_stop function, everything gets blocked.

Could someone tell what am I doing wrong? Or just give me some help 
about kernel threads in the RT Patch?

Thanks a lot

Mónica
