Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab0C0FAF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 01:00:05 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:61675 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab0C0FAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 01:00:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cg2ItkxQpf6vDGlZKlKZgQ5G6Uk+GnnUVyUwU8314oTRh8TkCGyTmbAbxQFuJFJXkj
         7YHQhk9oFKOJPtZkdwgd3iGmw9htXrNxYqxMfQptqSbeG+6gKbc+V5qmZnAJMfAWTzrE
         4Ucjoipz6Gyy29EzT7P9QgqWVRrZ6lFamz2rc=
Date: Sat, 27 Mar 2010 06:00:00 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, lizf@cn.fujitsu.com, hpa@zytor.com,
       tglx@linutronix.de, mhiramat@redhat.com, heiko.carstens@de.ibm.com,
       benh@kernel.crashing.org, davem@davemloft.net, lethal@linux-sh.org,
       schwidefsky@de.ibm.com, brueckner@linux.vnet.ibm.com,
       tony.luck@intel.com
Subject: Re: [PATCH 00/14] tracing: add compat syscall support v3
Message-ID: <20100327045958.GQ7166@nowhere>
References: <cover.1268749695.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1268749695.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 01:46:08PM -0400, Jason Baron wrote:
> Hi,
> 
> Re-post to add infrastructure for compat syscall event tracing support. This
> patch series also adds x86_64 arch specific support as an example consumer
> of the new infrastructure.
> 
> Arches can request compat syscall tracing by setting: 
> __HAVE_ARCH_FTRACE_COMPAT_SYSCALLS, if CONFIG_COMPAT and CONFIG_FTRACE_SYSCALLS
> are set. Arches then need to implement the following interfaces:
> 
> 1) int is_compat_task(void);
>   - most arches seem to have this already
> 2) unsigned long arch_compat_syscall_addr(int nr);
>   - returns a pointer to the compat syscall entry corresponding to syscall 'nr'
> 3) int NR_syscalls_compat;
>   - number of entries in the compat syscall table.
> 
> thanks,
> 
> -Jason
> 
> Changes in v3:
> 
>  - create a separate "compat_syscalls" event subsystem
>  - ARCH_COMPAT_SYSCALL_DEFINE#N() tacks "sys32" to start of syscall name
>  - COMPAT_SYSCALL_DEFINE#N() tacks "compat_sys" to start of syscall name
>  - both above macros create perf events as: [enter|exit]_compat_sys_blah
>  - non-compat syscall naming changes to: [enter|exit]_sys_blah
>  - removes any unreferenced compat syscalls from debugfs



Other than the small comments I had, it's a very nice stuff.
Just waiting for your next iteration before applying.

Thanks!

