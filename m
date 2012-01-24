Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab2AXVRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 16:17:41 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:60495 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab2AXVRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 16:17:40 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [patch 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v4
References: <20120124064719.GA29735@moon> <4F1E57F3.6020607@zytor.com>
	<20120124071716.GC29735@moon>
	<20120124162031.a3956058.kamezawa.hiroyu@jp.fujitsu.com>
	<20120124073842.GE29735@moon>
	<20120124164008.aa1714bd.kamezawa.hiroyu@jp.fujitsu.com>
	<20120124084823.GF29735@moon>
	<CAHGf_=r=zwj4=yjCekYZVRsTwjohJ8F8cP4rnZx6UL9kKNTc+g@mail.gmail.com>
	<20120124202606.GC2546@moon> <m18vkwj0dw.fsf@fess.ebiederm.org>
	<20120124205039.GB2278@moon>
Date: Tue, 24 Jan 2012 13:20:12 -0800
In-Reply-To: <20120124205039.GB2278@moon> (Cyrill Gorcunov's message of "Wed,
	25 Jan 2012 00:50:39 +0400")
Message-ID: <m1ty3khk6r.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18hthGITLUNM4hp5BFxybgZrlcFtTGHpBo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov <gorcunov@gmail.com> writes:

> On Tue, Jan 24, 2012 at 12:44:59PM -0800, Eric W. Biederman wrote:
>> Cyrill Gorcunov <gorcunov@gmail.com> writes:
>> 
>> > On Tue, Jan 24, 2012 at 03:20:26PM -0500, KOSAKI Motohiro wrote:
>> >> >> please do as you like.
>> >> >
>> >> > So it should be something like below I think...
>> >> 
>> >> Looks ok this version to me. So, if you fix other developers pointed
>> >> issue, I'll ack this.
>> >> 
>> >
>> > Thanks!
>> >
>> > Eric, so mm/ would be fine or I still should move it to kernel/
>> > instead? I've addressed other issues I hope.
>> 
>> The world won't fall apart if the code lands in mm.  I have a strong
>> preference for kernel/.  I just don't see anything at all memory
>> management like about that code.  Even the fact that you are
>> comparing pointers is an implementation detail.
>
> This one should fit all requirements I guess.

Bahahaha!

Looking I see one  more nit.

You need an entry in include/linux/syscalls.h

Eric

> ---
> From: Cyrill Gorcunov <gorcunov@openvz.org>
> Subject: [RFC] syscalls, x86: Add __NR_kcmp syscall v6
>
> While doing the checkpoint-restore in the userspace one need to determine
> whether various kernel objects (like mm_struct-s of file_struct-s) are shared
> between tasks and restore this state.
>
> The 2nd step can be solved by using appropriate CLONE_ flags and the unshare
> syscall, while there's currently no ways for solving the 1st one.
>
> One of the ways for checking whether two tasks share e.g. mm_struct is to
> provide some mm_struct ID of a task to its proc file, but showing such
> info considered to be not that good for security reasons.
>
> Thus after some debates we end up in conclusion that using that named
> 'comparision' syscall might be the best candidate. So here is it --
> __NR_kcmp.
>
> It takes up to 5 agruments - the pids of the two tasks (which
> characteristics should be compared), the comparision type and
> (in case of comparision of files) two file descriptors.
>
> At moment only x86 is supported.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: "Eric W. Biederman" <ebiederm@xmission.com>
> CC: Pavel Emelyanov <xemul@parallels.com>
> CC: Andrey Vagin <avagin@openvz.org>
> CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: H. Peter Anvin <hpa@zytor.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Glauber Costa <glommer@parallels.com>
> CC: Andi Kleen <andi@firstfloor.org>
> CC: Tejun Heo <tj@kernel.org>
> CC: Matt Helsley <matthltc@us.ibm.com>
> CC: Pekka Enberg <penberg@kernel.org>
> CC: Eric Dumazet <eric.dumazet@gmail.com>
> CC: Vasiliy Kulikov <segoon@openwall.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Alexey Dobriyan <adobriyan@gmail.com>
> CC: Valdis.Kletnieks@vt.edu
> ---
>  arch/x86/include/asm/syscalls.h  |    4 
>  arch/x86/syscalls/syscall_32.tbl |    1 
>  arch/x86/syscalls/syscall_64.tbl |    1 
>  include/linux/kcmp.h             |   17 ++++
>  kernel/Makefile                  |    1 
>  kernel/kcmp.c                    |  163 +++++++++++++++++++++++++++++++++++++++
>  6 files changed, 187 insertions(+)
>
> Index: linux-2.6.git/arch/x86/include/asm/syscalls.h
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/include/asm/syscalls.h
> +++ linux-2.6.git/arch/x86/include/asm/syscalls.h
> @@ -42,6 +42,10 @@ long sys_sigaltstack(const stack_t __use
>  asmlinkage int sys_set_thread_area(struct user_desc __user *);
>  asmlinkage int sys_get_thread_area(struct user_desc __user *);
>  
> +/* kernel/kcmp.c */
> +asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
> +			 unsigned long idx1, unsigned long idx2);
> +
>  /* X86_32 only */
>  #ifdef CONFIG_X86_32
>  
> Index: linux-2.6.git/arch/x86/syscalls/syscall_32.tbl
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/syscalls/syscall_32.tbl
> +++ linux-2.6.git/arch/x86/syscalls/syscall_32.tbl
> @@ -355,3 +355,4 @@
>  346	i386	setns			sys_setns
>  347	i386	process_vm_readv	sys_process_vm_readv		compat_sys_process_vm_readv
>  348	i386	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_writev
> +349	i386	kcmp			sys_kcmp
> Index: linux-2.6.git/arch/x86/syscalls/syscall_64.tbl
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/syscalls/syscall_64.tbl
> +++ linux-2.6.git/arch/x86/syscalls/syscall_64.tbl
> @@ -318,3 +318,4 @@
>  309	64	getcpu			sys_getcpu
>  310	64	process_vm_readv	sys_process_vm_readv
>  311	64	process_vm_writev	sys_process_vm_writev
> +312	64	kcmp			sys_kcmp
> Index: linux-2.6.git/include/linux/kcmp.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6.git/include/linux/kcmp.h
> @@ -0,0 +1,17 @@
> +#ifndef _LINUX_KCMP_H
> +#define _LINUX_KCMP_H
> +
> +/* Comparision type */
> +enum {
> +	KCMP_FILE,
> +	KCMP_VM,
> +	KCMP_FILES,
> +	KCMP_FS,
> +	KCMP_SIGHAND,
> +	KCMP_IO,
> +	KCMP_SYSVSEM,
> +
> +	KCMP_TYPES,
> +};
> +
> +#endif /* _LINUX_KCMP_H */
> Index: linux-2.6.git/kernel/Makefile
> ===================================================================
> --- linux-2.6.git.orig/kernel/Makefile
> +++ linux-2.6.git/kernel/Makefile
> @@ -25,6 +25,7 @@ endif
>  obj-y += sched/
>  obj-y += power/
>  
> +obj-$(CONFIG_X86) += kcmp.o
>  obj-$(CONFIG_FREEZER) += freezer.o
>  obj-$(CONFIG_PROFILING) += profile.o
>  obj-$(CONFIG_SYSCTL_SYSCALL_CHECK) += sysctl_check.o
> Index: linux-2.6.git/kernel/kcmp.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6.git/kernel/kcmp.c
> @@ -0,0 +1,163 @@
> +#include <linux/kernel.h>
> +#include <linux/syscalls.h>
> +#include <linux/fdtable.h>
> +#include <linux/string.h>
> +#include <linux/random.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/cache.h>
> +#include <linux/bug.h>
> +#include <linux/err.h>
> +#include <linux/kcmp.h>
> +
> +#include <asm/unistd.h>
> +
> +static unsigned long cookies[KCMP_TYPES][2] __read_mostly;
> +
> +static long kptr_obfuscate(long v, int type)
> +{
> +	return (v ^ cookies[type][0]) * cookies[type][1];
> +}
> +
> +/*
> + * 0 - equal
> + * 1 - less than
> + * 2 - greater than
> + * 3 - not equal but ordering unavailable
> + */
> +static int kcmp_ptr(long v1, long v2, int type)
> +{
> +	long ret;
> +
> +	ret = kptr_obfuscate(v1, type) - kptr_obfuscate(v2, type);
> +
> +	return (ret < 0) | ((ret > 0) << 1);
> +}
> +
> +#define KCMP_TASK_PTR(task1, task2, member, type)	\
> +	kcmp_ptr((long)(task1)->member,			\
> +		 (long)(task2)->member,			\
> +		 type)
> +
> +#define KCMP_PTR(ptr1, ptr2, type)			\
> +	kcmp_ptr((long)ptr1, (long)ptr2, type)
> +
> +/* A caller must be sure the task is presented in memory */
> +static struct file *
> +get_file_raw_ptr(struct task_struct *task, unsigned int idx)
> +{
> +	struct fdtable *fdt;
> +	struct file *file;
> +
> +	spin_lock(&task->files->file_lock);
> +	fdt = files_fdtable(task->files);
> +	if (idx < fdt->max_fds)
> +		file = fdt->fd[idx];
> +	else
> +		file = NULL;
> +	spin_unlock(&task->files->file_lock);
> +
> +	return file;
> +}
> +
> +SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t, pid2, int, type,
> +		unsigned long, idx1, unsigned long, idx2)
> +{
> +	struct task_struct *task1;
> +	struct task_struct *task2;
> +	int ret = 0;
> +
> +	rcu_read_lock();
> +
> +	task1 = find_task_by_vpid(pid1);
> +	if (!task1) {
> +		rcu_read_unlock();
> +		return -ESRCH;
> +	}
> +
> +	task2 = find_task_by_vpid(pid2);
> +	if (!task2) {
> +		put_task_struct(task1);
> +		rcu_read_unlock();
> +		return -ESRCH;
> +	}
> +
> +	get_task_struct(task1);
> +	get_task_struct(task2);
> +
> +	rcu_read_unlock();
> +
> +	if (!ptrace_may_access(task1, PTRACE_MODE_READ) ||
> +	    !ptrace_may_access(task2, PTRACE_MODE_READ)) {
> +		ret = -EACCES;
> +		goto err;
> +	}
> +
> +	/*
> +	 * Note for all cases but the KCMP_FILE we
> +	 * don't take any locks in a sake of speed.
> +	 */
> +
> +	switch (type) {
> +	case KCMP_FILE: {
> +		struct file *filp1, *filp2;
> +
> +		filp1 = get_file_raw_ptr(task1, idx1);
> +		filp2 = get_file_raw_ptr(task2, idx2);
> +
> +		if (filp1 && filp2)
> +			ret = KCMP_PTR(filp1, filp2, KCMP_FILE);
> +		else
> +			ret = -ENOENT;
> +		break;
> +	}
> +	case KCMP_VM:
> +		ret = KCMP_TASK_PTR(task1, task2, mm, KCMP_VM);
> +		break;
> +	case KCMP_FILES:
> +		ret = KCMP_TASK_PTR(task1, task2, files, KCMP_FILES);
> +		break;
> +	case KCMP_FS:
> +		ret = KCMP_TASK_PTR(task1, task2, fs, KCMP_FS);
> +		break;
> +	case KCMP_SIGHAND:
> +		ret = KCMP_TASK_PTR(task1, task2, sighand, KCMP_SIGHAND);
> +		break;
> +	case KCMP_IO:
> +		ret = KCMP_TASK_PTR(task1, task2, io_context, KCMP_IO);
> +		break;
> +	case KCMP_SYSVSEM:
> +#ifdef CONFIG_SYSVIPC
> +		ret = KCMP_TASK_PTR(task1, task2, sysvsem.undo_list, KCMP_SYSVSEM);
> +#else
> +		ret = -ENOENT;
> +		goto err;
> +#endif
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
> +err:
> +	put_task_struct(task1);
> +	put_task_struct(task2);
> +
> +	return ret;
> +}
> +
> +static __init int kcmp_cookie_init(void)
> +{
> +	int i, j;
> +
> +	for (i = 0; i < KCMP_TYPES; i++) {
> +		for (j = 0; j < 2; j++) {
> +			get_random_bytes(&cookies[i][j],
> +					 sizeof(cookies[i][j]));
> +		}
> +		cookies[i][1] |= (~(~0UL >>  1) | 1);
> +	}
> +
> +	return 0;
> +}
> +late_initcall(kcmp_cookie_init);
