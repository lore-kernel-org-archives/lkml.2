Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab1CaD4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 23:56:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab1CaD4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 23:56:14 -0400
Date: Wed, 30 Mar 2011 23:55:12 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: excessive kworker activity when idle. (was Re: vma corruption in
 today's -git)
Message-ID: <20110331035511.GA1255@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Tejun Heo <tj@kernel.org>
References: <20110329040939.GA32764@redhat.com>
 <AANLkTi=PHtUpb5oJ8_r1K1dvaUunhxv1MS3LLPM8V4Ci@mail.gmail.com>
 <20110331030917.GB26057@redhat.com>
 <AANLkTikYAAYcYxTdKAxQjDxVQ7qrZGEfXg+gpfwcj1=-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikYAAYcYxTdKAxQjDxVQ7qrZGEfXg+gpfwcj1=-@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 08:37:21PM -0700, Linus Torvalds wrote:
 > You don't see some nice thread description
 > in 'top' any more (like you used to when everybody created their own
 > threads and didn't do the common worker thread thing), and the best
 > approach literally seems to be something like
 > 
 >    perf record -ag sleep 10
 >    perf report
 > 
 > which does tend to show what's going on, but it's still a ridiculous
 > way to this.

I tried that, and wasn't particularly enlightened.

+      6.53%  kworker/1:2  [kernel.kallsyms]  [k] read_hpet            
+      4.83%  kworker/0:0  [kernel.kallsyms]  [k] read_hpet           
+      4.28%  kworker/0:0  [kernel.kallsyms]  [k] arch_local_irq_restore 
+      4.03%  kworker/1:2  [kernel.kallsyms]  [k] arch_local_irq_restore  
+      3.10%  kworker/0:0  [kernel.kallsyms]  [k] do_raw_spin_trylock      
+      2.88%  kworker/1:2  [kernel.kallsyms]  [k] do_raw_spin_trylock       
+      2.85%  kworker/1:2  [kernel.kallsyms]  [k] debug_locks_off  
+      2.69%  kworker/0:0  [kernel.kallsyms]  [k] debug_locks_off   
+      2.48%  kworker/0:0  [kernel.kallsyms]  [k] lock_release       
+      2.26%  kworker/1:2  [kernel.kallsyms]  [k] lock_release        
+      2.03%  kworker/0:0  [kernel.kallsyms]  [k] lock_acquire         
+      1.88%  kworker/0:0  [kernel.kallsyms]  [k] arch_local_save_flags 
+      1.87%  kworker/1:2  [kernel.kallsyms]  [k] lock_acquire           
+      1.82%  kworker/1:2  [kernel.kallsyms]  [k] arch_local_save_flags 
+      1.81%  kworker/1:2  [kernel.kallsyms]  [k] arch_local_irq_save    
+      1.78%  kworker/0:0  [kernel.kallsyms]  [k] arch_local_irq_save     
+      1.56%  kworker/0:0  [kernel.kallsyms]  [k] lock_acquired            
+      1.53%  kworker/1:2  [kernel.kallsyms]  [k] __lock_acquire            
+      1.51%  kworker/0:0  [kernel.kallsyms]  [k] __lock_acquire             
+      1.29%  kworker/0:0  [kernel.kallsyms]  [k] native_write_msr_safe       
+      1.23%  kworker/1:2  [kernel.kallsyms]  [k] cpu_relax                    
+      1.17%  kworker/1:2  [kernel.kallsyms]  [k] lock_acquired                 
+      1.17%  kworker/0:0  [kernel.kallsyms]  [k] trace_hardirqs_off_caller      
+      1.11%  kworker/1:2  [kernel.kallsyms]  [k] trace_hardirqs_off_caller       
+      1.08%  kworker/1:2  [kernel.kallsyms]  [k] native_write_msr_safe   
+      1.02%  kworker/0:0  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave   
+      0.92%  kworker/0:0  [kernel.kallsyms]  [k] process_one_work          
+      0.87%  kworker/1:2  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave     
+      0.80%  kworker/0:0  [kernel.kallsyms]  [k] flush_to_ldisc       
+      0.76%  kworker/1:2  [kernel.kallsyms]  [k] process_one_work      
+      0.76%  kworker/1:2  [kernel.kallsyms]  [k] flush_to_ldisc         
+      0.72%  kworker/0:0  [kernel.kallsyms]  [k] arch_local_irq_restore  
+      0.71%  kworker/1:2  [kernel.kallsyms]  [k] arch_local_irq_restore   
+      0.64%  kworker/1:2  [kernel.kallsyms]  [k] do_raw_spin_unlock        
+      0.63%  kworker/0:0  [kernel.kallsyms]  [k] perf_event_task_tick       
+      0.61%  kworker/1:2  [kernel.kallsyms]  [k] ktime_get                   
+      0.59%  kworker/0:0  [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore  

this is what led me to try the other perf methods. the kmem traces were
the only things that really jumped out.

 > (Powertop can also do it, and is probably a better thing to use, I'm
 > just used to "perf record" for other reasons, so..)

Tried that too, here's what it said..

Summary: 0.0 wakeups/second,  0.0 GPU ops/second and 0.0 VFS ops/sec

                Usage       Events/s    Category       Description
            -2147483648 ms/s   0.0        Timer
            -2147483648 ms/s   0.0        kWork
            35151589 ms/s    0.0        Timer
            35151588 ms/s    0.0        Timer
            35151587 ms/s    0.0        Timer
            35151586 ms/s    0.0        Timer
            35151585 ms/s    0.0        Timer
            35151585 ms/s    0.0        Timer
            35151584 ms/s    0.0        Timer
            35151583 ms/s    0.0        Timer
            35151582 ms/s    0.0        Timer
            35151581 ms/s    0.0        Timer
            35151581 ms/s    0.0        Timer
            35151580 ms/s    0.0        Timer

Not exactly helpful.

	Dave

