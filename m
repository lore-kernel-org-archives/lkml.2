Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab0LHVsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 16:48:19 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:65462 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab0LHVsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 16:48:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vCKLvieCIEIV1BE9rpqjW8JBRRS7Ity3UNqKZQAq8tU/27oHiVNZNu2YZEUHW+junp
         pGXoEsrVxfkLrZMrzU8R9cobx9qAFxCRCV7bvPe7mQF4wYnFRbs+cLU8szYF2rBxiw8i
         RcypAbQHyIMEF/qEvAzdROnmlrFYOGepeTs3M=
Date: Wed, 8 Dec 2010 22:48:13 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: buggy perf callgraph output
Message-ID: <20101208214809.GG1709@nowhere>
References: <20101208164015.GA5444@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101208164015.GA5444@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 03:40:15AM +1100, Nick Piggin wrote:
> Hi,
> 
> I get strange looking perf output with the callchain hits not sorted
> properly for graph and fractal:
> 
>      7.34%          open  [kernel.kallsyms]     [k] kmem_cache_alloc
>                     |
>                     --- kmem_cache_alloc
>                        |          
>                        |---0.05%-- get_empty_filp
>                        |          do_filp_open
>                        |          do_sys_open
>                        |          sys_open
>                        |          system_call
>                        |          __open_nocancel
>                        |          
>                         ---0.16%-- getname
>                                   do_sys_open
>                                   sys_open
>                                   system_call
>                                   __open_nocancel
> 
>      6.17%          open  [kernel.kallsyms]     [k] _raw_spin_lock
>                     |
>                     --- _raw_spin_lock
>                        |          
>                        |---0.01%-- add_partial
>                        |          __slab_free
>                        |          kmem_cache_free
>                        |          file_free_rcu
>                        |          __rcu_process_callbacks
>                        |          rcu_process_callbacks
>                        |          __do_softirq
>                        |          call_softirq
>                        |          do_softirq
>                        |          irq_exit
>                        |          smp_apic_timer_interrupt
>                        |          apic_timer_interrupt
>                        |          
>                        |---0.16%-- dput
>                        |          |          
>                        |           --0.57%-- fput
>                        |                     filp_close
>                        |                     sys_close
>                        |                     system_call
>                        |                     __libc_close
>                        |          
>                        |--0.60%-- link_path_walk
>                        |          do_path_lookup
>                        |          do_filp_open
>                        |          do_sys_open
>                        |          sys_open
>                        |          system_call
>                        |          __open_nocancel
>                        |          
>                        |--0.57%-- __slab_free
>                        |          kmem_cache_free
>                        |          file_free_rcu
>                        |          __rcu_process_callbacks
>                        |          rcu_process_callbacks
>                        |          __do_softirq
> 
> 
> With flat it looks a bit better:
>      7.34%          open  [kernel.kallsyms]     [k] kmem_cache_alloc
>              6.09%
>                 kmem_cache_alloc
>                 get_empty_filp
>                 do_filp_open
>                 do_sys_open
>                 sys_open
>                 system_call
>                 __open_nocancel
> 
>              1.07%
>                 kmem_cache_alloc
>                 getname
>                 do_sys_open
>                 sys_open
>                 system_call
>                 __open_nocancel
> 
>      6.17%          open  [kernel.kallsyms]     [k] _raw_spin_lock
>              0.60%
>                 _raw_spin_lock
>                 link_path_walk
>                 do_path_lookup
>                 do_filp_open
>                 do_sys_open
>                 sys_open
>                 system_call
>                 __open_nocancel
> 
>              0.57%
>                 _raw_spin_lock
>                 fd_install
>                 do_sys_open
>                 sys_open
>                 system_call
>                 __open_nocancel
> 
>              0.57%
>                 _raw_spin_lock
>                 dput
>                 fput
>                 filp_close
>                 sys_close
>                 system_call
>                 __libc_close


I can not reproduce it. Could you please try to reproduce,
run perf archive and send me your perf.data.tar.bz2 ?

Thanks.
