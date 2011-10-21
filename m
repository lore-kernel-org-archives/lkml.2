Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab1JUBq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 21:46:59 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64999 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab1JUBq6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 21:46:58 -0400
MIME-Version: 1.0
In-Reply-To: <1319135973.1020.9.camel@mop>
References: <1319135973.1020.9.camel@mop>
Date: Fri, 21 Oct 2011 09:46:57 +0800
Message-ID: <CAE8kqZLqf6SaVwdEbxESdcF00nBV0ymuQpC6rmvbtAxDKZKBOw@mail.gmail.com>
Subject: =?windows-1252?Q?Re=3A_A_Plumber=92s_Wish_List_for_Linux=2C_updated_versi?=
	=?windows-1252?Q?on_2?=
From: boyd yang <boyd.yang@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, lennart@poettering.net, harald@redhat.com,
        david@fubar.dk, greg@kroah.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have prepared a patch for fanotify.
It differantiates events from different thread and avoid merging them.

On Fri, Oct 21, 2011 at 2:39 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> Update: this is the second version, it incorporates the original list,
> adds a couple of new items, and includes references to some useful
> feedback and patches that have already been prepared.
>
> We’d like to share our current wish list of plumbing layer features we
> are hoping to see implemented in the near future in the Linux kernel and
> associated tools. Some items we can implement on our own, others are not
> our area of expertise, and we will need help getting them implemented.
>
> Acknowledging that this wish list of ours only gets longer and not
> shorter, even though we have implemented a number of other features on
> our own in the previous years, we are posting this list here, in the
> hope to find some help.
>
> If you happen to be interested in working on something from this list or
> able to help out, we’d be delighted. Please ping us in case you need
> clarifications or more information on specific items.
>
>
> Thanks,
> Kay, Lennart, Harald, David in the name of all the other plumbers
>
>
> And here is the wish list, in no particular order:
>
> tmpfs:
> ======
> * support user quota on tmpfs to prevent DoS vulnerabilities
> on /tmp, /dev/shm, /run/user/$USER. This is kinda important. Idea:
> global RLIMIT_TMPFS_QUOTA over all mounted tmpfs file systems. NEW!
>
> * support fallocate() properly: NEW!
>   fallocate(5, 0, 0, 7663616) = -1 EOPNOTSUPP
>
>
> fanotify:
> =========
> * events for renames NEW!
>
> * allow safe unprivileged access NEW!
>
> * pass information about the open flags to the file system monitors, in
> order to allow clients to figure out whether other applications opened
> files for writing or just read-only. NEW!
>
> * allow to find out if a file actually was written to, when closed after
> opening it read-write NEW!
>
>
> filesystems:
> ============
> * (ioctl based?) interface to query and modify the label of a mounted
> FAT volume: A FAT label is implemented as a hidden directory entry in
> the file system, which need to be renamed when changing the file system
> label. This is impossible to do from userspace without remounting. Hence
> we’d like to see a kernel interface that is available on the mounted
> file system mount point itself. Of course, bonus points, if this new
> interface can be implemented for other file systems as well.
>
> * faster xattrs on ext2/3/4 (i.e. allow userspace to make use of xattr
> without paying the performance penalty for the seeks. Alex Larsson will
> provide you with the measurement data how xattr checking is magnitudes
> slower when trying to implement a simple file list). Suggestion: provide
> a simple flag in struct stat to inform userspace whether it is worth
> looking for xattrs (i.e. think STAT_XATTRS_FOUND or STAT_XATTRS_MAYBE)
> NEW!
>
>
> mounting:
> =========
> * allow creation of read-only bind mounts in a single mount() call,
> instead of two NEW!
>
> * Similar, allow configuration of namespace propagation settings for
> mount points in the initial mount() syscall, instead of always requiring
> two (which is racy, and ugly, and stuff). NEW!
>
>
> memory management:
> ==================
> * swappiness control as madvise() for individual memory pages NEW!
>
>
> core kernel:
> ============
> [PATCH] * hostname change notification:
> http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=70b932563a9514b248cc71a29bd0907bf95b4a5e NEW!
>
> [PATCH] * PR_SET_CHILD_SUBREAPER
> Reviewed and probably ready-to-merge patch:
>  http://permalink.gmane.org/gmane.linux.man/2071 NEW!
>
> * allow 64 bit PIDs / use 32 bit pids by default, in order to fix PID
> recycle vulnerabilities NEW!
>
> * allow changing argv[] of a process without mucking with environ[]:
> Something like setproctitle() or a prctl() would be ideal. Of course it
> is questionable if services like sendmail make use of this, but otoh for
> services which fork but do not immediately exec() another binary being
> able to rename this child processes in ps is of importance.
>
>
> driver model:
> =============
> * CPU modaliases in /sys/devices/system/cpu/cpuX/modalias:
> useful to allow module auto-loading of e.g. cpufreq drivers and KVM
> modules. Andy Kleen has a patch to create the alias file itself. CPU
> ‘struct sysdev’ needs to be converted to ‘struct device’ and a ‘struct
> bus_type cpu’ needs to be introduced to allow proper CPU coldplug event
> replay at bootup. This is one of the last remaining places where
> automatic hardware-triggered module auto-loading is not available. And
> we’d like to see that fix to make numerous ugly userspace work-arounds
> to achieve the same go away.
>
> * export ‘struct device_type fb/fbcon’ of ‘struct class graphics’
> Userspace wants to easily distinguish ‘fb’ and ‘fbcon’ from each other
> without the need to match on the device name.
>
>
> security:
> =========
> [PATCH] * expose CAP_LAST_CAP somehow in the running kernel at runtime:
> Userspace needs to know the highest valid capability of the running
> kernel, which right now cannot reliably be retrieved from header files
> only. The fact that this value cannot be detected properly right now
> creates various problems for libraries compiled on newer header files
> which are run on older kernels. They assume capabilities are available
> which actually aren’t. Specifically, libcap-ng claims that all running
> processes retain the higher capabilities in this case due to the
> “inverted” semantics of CapBnd in /proc/$PID/status.
> Dan Ballard
> https://lkml.org/lkml/2011/10/12/452
>
>
> userspace:
> ==========
> * module-init-tools: provide a proper libmodprobe.so from
> module-init-tools:
> Early boot tools, installers, driver install disks want to access
> information about available modules, and match devices to available
> modules to hook up driver overwrites, driver update disks, installer
> tweaks, and to optimize bootup module handling.
>
>
> cgroups:
> ========
> * fork throttling mechanism as basic cgroup functionality that is
> available in all hierarchies independent of the controllers used:
> This is important to implement race-free killing of all members of a
> cgroup, so that cgroup member processes cannot fork faster then a cgroup
> supervisor process could kill them. This needs to be recursive, so that
> not only a cgroup but all its subgroups are covered as well.
> Patches for task_conter from Frederic Weisbecker
> http://article.gmane.org/gmane.linux.kernel/1198795
> Possibly use the freezer Tejun is looking into.
>
> * proper cgroup-is-empty notification interface:
> The current call_usermodehelper() interface is an unefficient and an
> ugly hack. Tools would prefer anything more lightweight like a netlink,
> poll() or fanotify interface.
>
> * allow user xattrs to be set on files in the cgroupfs (and maybe
> procfs?)
>
> * allow making use of the “cpu” cgroup controller by default without
> breaking RT. Right now creating a cgroup in the “cpu” hierarchy that
> shall be able to take advantage of RT is impossible for the generic case
> since it needs an RT budget configured which is from a limited resource
> pool. What we want is the ability to create cgroups in “cpu” whose
> processes get an non-RT weight applied, but for RT take advantage of the
> parent’s RT budget. We want the separation of RT and non-RT budget
> assignment in the “cpu” hierarchy, because right now, you lose RT
> functionality in it unless you assign an RT budget. This issue severely
> limits the usefulness of “cpu” hierarchy on general purpose systems
> right now.
>
> * Add a timerslack cgroup controller, to allow increasing the timer
> slack of user session cgroups when the machine is idle.
>  Patch from: Kirill A. Shutemov
>  http://article.gmane.org/gmane.linux.kernel/1201782
>  http://lwn.net/Articles/463357/
>
>
> namespaces:
> ===========
> * simple, reliable and future-proof way to detect whether a specific pid
> is running in a CLONE_NEWUTS/CLONE_NEWPID container, i.e. not in the
> root PID namespace/UTS namespace. Currently, there are available a few
> ugly hacks to detect this (for example a process wanting to know whether
> it is running in a PID namespace could just look for a PID 2 being
> around and named kthreadd which is a kernel thread only visible in the
> root namespace), however all these solutions encode information and
> expectations that better shouldn’t be encoded in a namespace test like
> this. This functionality is needed in particular since the removal of
> the the ns cgroup controller which provided the namespace membership
> information to user code.
>
>
> AF_UNIX:
> ========
> * An auxiliary meta data message for AF_UNIX called SCM_CGROUPS (or
> something like that), i.e. a way to attach sender cgroup membership to
> messages sent via AF_UNIX. This is useful in case services such as
> syslog shall be shared among various containers (or service cgroups),
> and the syslog implementation needs to be able to distinguish the
> sending cgroup in order to separate the logs on disk. Of course stm
> SCM_CREDENTIALS can be used to look up the PID of the sender followed by
> a check in /proc/$PID/cgroup, but that is necessarily racy, and actually
> a very real race in real life.
>
> * SCM_PROCSTATUS for retrieving sender process information supplying at
> least: comm, exec, cmdline, audit session, audit loginuid.
>
>
> All time favourites:
> ====================
> These items have been requested many times already, and we want to make
> sure they aren’t forgotten. We know they are hard to implement, and we
> don’t know how to get there, but nonetheless, here they are:
>
> * Oldie But Goldie: some kind of unionfs or union mount. A minimal
> version that supports only read-only filesystems would already be a big
> step forward. NEW!
>
> * revoke() NEW!
>
> * Notifications when non-child processes die, in an efficient way
> focussing on explicit PIDs (i.e. not taskstats) in some form (idea:
> poll() for POLLERR on /proc/$PID) NEW!
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
