Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab0HDK4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 06:56:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49494 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab0HDK4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 06:56:12 -0400
Message-ID: <4C594740.1090608@vlnb.net>
Date: Wed, 04 Aug 2010 14:56:00 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.35: suspicious rcu_dereference_check() usage
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:LnO7PupMlFIUc7gel5kYr+QrDky++vK6P3PnAzwhZ3x
 OcA15uqa6CMiNgGHEtNcrep7flj4wyXGZu2mYFyCczpJuqptwn
 P4yGuiMr6yv5sH/XkQgiOmzE/pqiYuUeNThq+hJp3921uFQbVp
 kTCAbuJyMBunOcrA0j4uh9R+0W10qjMMhXTkOltXPLn7PT9ekf
 UP5uREPBwSjp0AWYxa8RQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Today I gave a first try to 2.6.35 and it immediately produced:

Aug  4 15:12:09 tgt kernel: [  183.799040] ===================================================                                              
Aug  4 15:12:09 tgt kernel: [  183.799158] [ INFO: suspicious rcu_dereference_check() usage. ]                                              
Aug  4 15:12:09 tgt kernel: [  183.799158] ---------------------------------------------------                                              
Aug  4 15:12:09 tgt kernel: [  183.799158] kernel/exit.c:1387 invoked rcu_dereference_check() without protection!                           
Aug  4 15:12:09 tgt kernel: [  183.799158]                                                                                                  
Aug  4 15:12:09 tgt kernel: [  183.799158] other info that might help us debug this:                                                        
Aug  4 15:12:09 tgt kernel: [  183.799158]                                                                                                  
Aug  4 15:12:09 tgt kernel: [  183.799158]                                                                                                  
Aug  4 15:12:09 tgt kernel: [  183.799158] rcu_scheduler_active = 1, debug_locks = 1                                                        
Aug  4 15:12:09 tgt kernel: [  183.799158] 2 locks held by mc/3751:                                                                         
Aug  4 15:12:09 tgt kernel: [  183.799158]  #0:  (tasklist_lock){.+.+..}, at: [<7813d277>] do_wait+0xa1/0x24f                               
Aug  4 15:12:09 tgt kernel: [  183.799158]  #1:  (&(&sighand->siglock)->rlock){-.....}, at: [<7813c6eb>] wait_consider_task+0xdd/0xbc8      
Aug  4 15:12:09 tgt kernel: [  183.799158]                                                                                                  
Aug  4 15:12:09 tgt kernel: [  183.799158] stack backtrace:                                                                                 
Aug  4 15:12:09 tgt kernel: [  183.799158] Pid: 3751, comm: mc Not tainted 2.6.35-scst-dbg #3                                               
Aug  4 15:12:09 tgt kernel: [  183.799158] Call Trace:                                                                                      
Aug  4 15:12:09 tgt kernel: [  183.799158]  [<784660a3>] ? printk+0x2d/0x32                                                                 
Aug  4 15:12:09 tgt kernel: [  183.799158]  [<78165d6e>] lockdep_rcu_dereference+0x8e/0x96                                                  
Aug  4 15:12:09 tgt kernel: [  183.799158]  [<7813caa3>] wait_consider_task+0x495/0xbc8                                                     
Aug  4 15:12:09 tgt kernel: [  183.799158]  [<7846c809>] ? sub_preempt_count+0x9/0xad                                                       
Aug  4 15:12:09 tgt kernel: [  183.799158]  [<78164056>] ? put_lock_stats+0xd/0x28                                                          
Aug  4 15:12:09 tgt kernel: [  183.799158]  [<7813d277>] ? do_wait+0xa1/0x24f                                                               
Aug  4 15:12:09 tgt kernel: [  183.799158]  [<78469218>] ? _raw_read_lock+0x6b/0x72                                                         
Aug  4 15:12:09 tgt kernel: [  183.799158]  [<7813d2ca>] do_wait+0xf4/0x24f                                                                 
Aug  4 15:12:09 tgt kernel: [  183.799158]  [<7813d48d>] sys_wait4+0x68/0xb2                                                                
Aug  4 15:12:09 tgt kernel: [  183.799158]  [<7813afbd>] ? child_wait_callback+0x0/0x73                                                     
Aug  4 15:12:09 tgt kernel: [  183.799158]  [<7813d503>] sys_waitpid+0x2c/0x2e                                                              
Aug  4 15:12:09 tgt kernel: [  183.799158]  [<78102d13>] sysenter_do_call+0x12/0x32                                                         

I guess, it was just after I started mc.

Vlad
