Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab1EROlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 10:41:12 -0400
Received: from smtpbg55.qq.com ([64.71.138.44]:35670 "HELO smtpbg55.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757302Ab1EROlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 10:41:10 -0400
X-QQ-mid: esmtp2t1305729517t047t13844
X-QQ-SSF: 00000000000000F0FG5005000000000
Date: Wed, 18 May 2011 22:38:39 +0800
From: "Lina Lu" <lulina_nuaa@foxmail.com>
To: "dhowells" <dhowells@redhat.com>
Cc: "linux kernel mailing list" <linux-kernel@vger.kernel.org>
Subject: Re: CRED: Fix get_task_cred() and task_state() to not resurrect dead credentials
Message-ID: <201105182238380008479@foxmail.com>
X-mailer: Foxmail 6, 15, 201, 23 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

I found your get_cred patch on the community website and put the patch in my linux 
system to avoid cred problems. But the system got two abnormal situations.

One is that the kernel got a bug at line 168 in kernel/cred.c after running about seven
days. 

The other is kernel panic with the following backtrace.
CRED: put_cred_rcu() sees ffff88008626e800 with usage -3. 
I got confused, how the usage -3 was generated. 

The kernel trace information is as follows: 

kernel_trace
       <ffffffff803794d7>{notifier_call_chain+0x37} 
       <ffffffff80372d32>{panic+0xa2} 
       <ffffffff8005ae56>{put_cred_rcu+0xa6} 
       <ffffffff8008da55>{__rcu_process_callbacks+0x145} 
       <ffffffff8008dd66>{rcu_process_callbacks+0x26} 
       <ffffffff8004389e>{__do_softirq+0xde} 
       <ffffffff80007f3c>{call_softirq+0x1c} 
       <ffffffff80009535>{do_softirq+0xa5} 
       <ffffffff80279e82>{evtchn_do_upcall+0x212} 
       <ffffffff8000799e>{do_hypervisor_callback+0x1e} 
       [<ffffffff800033aa>] 
       <ffffffff8000a826>{xen_safe_halt+0xb6} 
       <ffffffff8000de1d>{xen_idle+0x5d} 
       <ffffffff800065cf>{cpu_idle+0x5f} 

Task tree: 
process:swapper (pid:0, tgid:0) 

I am looking forward to your reply. Any reply is appreciated. 

Thank you very much! 
f
