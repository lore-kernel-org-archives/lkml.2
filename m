Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab2KTBFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 20:05:16 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59831 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab2KTBFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 20:05:14 -0500
Date: Mon, 19 Nov 2012 17:05:12 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mgorman@suse.de>
cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 00/27] Latest numa/core release, v16
In-Reply-To: <alpine.DEB.2.00.1211191644340.24618@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1211191703270.24618@chino.kir.corp.google.com>
References: <1353291284-2998-1-git-send-email-mingo@kernel.org> <20121119162909.GL8218@suse.de> <alpine.DEB.2.00.1211191644340.24618@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2012, David Rientjes wrote:

> I confirm that SPECjbb2005 1.07 -Xmx4g regresses in terms of throughput on 
> my 16-way, 4 node system with 32GB of memory using 16 warehouses and 240 
> measurement seconds.  I averaged the throughput for five runs on each 
> kernel.
> 
> Java(TM) SE Runtime Environment (build 1.6.0_06-b02)
> Java HotSpot(TM) 64-Bit Server VM (build 10.0-b22, mixed mode)
> 
> Both kernels have
> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
> CONFIG_TRANSPARENT_HUGEPAGE=y
> CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
> 
> numa/core at 01aa90068b12 ("sched: Use the best-buddy 'ideal cpu' in 
> balancing decisions") with
> 
> CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
> CONFIG_ARCH_WANTS_NUMA_GENERIC_PGPROT=y
> CONFIG_NUMA_BALANCING=y
> CONFIG_NUMA_BALANCING_HUGEPAGE=y
> CONFIG_ARCH_USES_NUMA_GENERIC_PGPROT=y
> CONFIG_ARCH_USES_NUMA_GENERIC_PGPROT_HUGEPAGE=y
> 
> had a throughput of 128315.19 SPECjbb2005 bops.
> 
> numa/core at ec05a2311c35 ("Merge branch 'sched/urgent' into sched/core") 
> had an average throughput of 136918.34 SPECjbb2005 bops, which is a 6.3% 
> regression.
> 

perftop during the run on numa/core at 01aa90068b12 ("sched: Use the 
best-buddy 'ideal cpu' in balancing decisions"):

    15.99%  [kernel]  [k] page_fault                         
     4.05%  [kernel]  [k] getnstimeofday                     
     3.96%  [kernel]  [k] _raw_spin_lock                     
     3.20%  [kernel]  [k] rcu_check_callbacks                
     2.93%  [kernel]  [k] generic_smp_call_function_interrupt
     2.90%  [kernel]  [k] __do_page_fault                    
     2.82%  [kernel]  [k] ktime_get                          
     2.62%  [kernel]  [k] read_tsc                           
     2.41%  [kernel]  [k] handle_mm_fault                    
     2.01%  [kernel]  [k] flush_tlb_func                     
     1.99%  [kernel]  [k] retint_swapgs                      
     1.83%  [kernel]  [k] emulate_vsyscall                   
     1.71%  [kernel]  [k] handle_pte_fault                   
     1.63%  [kernel]  [k] task_tick_fair                     
     1.57%  [kernel]  [k] clear_page_c                       
     1.55%  [kernel]  [k] down_read_trylock                  
     1.54%  [kernel]  [k] copy_user_generic_string           
     1.48%  [kernel]  [k] ktime_get_update_offsets           
     1.37%  [kernel]  [k] find_vma                           
     1.23%  [kernel]  [k] mpol_misplaced                     
     1.14%  [kernel]  [k] task_numa_fault                    
     1.10%  [kernel]  [k] run_timer_softirq                  
     1.06%  [kernel]  [k] up_read                            
     0.87%  [kernel]  [k] __bad_area_nosemaphore             
     0.82%  [kernel]  [k] write_ok_or_segv                   
     0.77%  [kernel]  [k] update_cfs_shares                  
     0.76%  [kernel]  [k] update_curr                        
     0.75%  [kernel]  [k] error_sti                          
     0.75%  [kernel]  [k] get_vma_policy                     
     0.73%  [kernel]  [k] smp_call_function_many             
     0.66%  [kernel]  [k] do_wp_page                         
     0.60%  [kernel]  [k] error_entry                        
     0.60%  [kernel]  [k] call_function_interrupt            
     0.59%  [kernel]  [k] error_exit                         
     0.58%  [kernel]  [k] _raw_spin_lock_irqsave             
     0.58%  [kernel]  [k] tick_sched_timer                   
     0.57%  [kernel]  [k] __do_softirq                       
     0.57%  [kernel]  [k] mem_cgroup_count_vm_event          
     0.56%  [kernel]  [k] account_user_time                  
     0.56%  [kernel]  [k] spurious_fault                     
     0.54%  [kernel]  [k] acct_update_integrals              
     0.54%  [kernel]  [k] bad_area_nosemaphore

 [ Both kernels for this test were booted with cgroup_disable=memory on 
   the command line, why mem_cgroup_count_vm_event shows up at all here is 
   strange... ]
