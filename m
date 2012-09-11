Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874Ab2IKLUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:20:41 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43761 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757783Ab2IKLUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:20:39 -0400
Message-ID: <504F1E74.10709@gmail.com>
Date: Tue, 11 Sep 2012 13:20:20 +0200
From: Michael Kerrisk <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Tejun Heo <tj@kernel.org>
CC: Michael Kerrisk <mtk.manpages@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Rob Landley <rob@landley.net>
Subject: [patch] cgroups: trivial fixes for Documentation/cgroups/cgroups.txt
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While reading through Documentation/cgroups/cgroups.txt, I found a
number of minor wordos and typos. The patch below is a conservative
handling of some of these: it provides just a number of "obviously
correct" fixes to the English that improve the readability
of the document somewhat. Obviously some more significant
fixes could be made to the document, but some of those 
may not be in the "obviously correct" category.

Please apply.

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>


diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index 4a0b64c..798cf21 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -62,9 +62,9 @@ an instance of the cgroup virtual filesystem associated with it.
 At any one time there may be multiple active hierarchies of task
 cgroups. Each hierarchy is a partition of all tasks in the system.
 
-User level code may create and destroy cgroups by name in an
+User-level code may create and destroy cgroups by name in an
 instance of the cgroup virtual file system, specify and query to
-which cgroup a task is assigned, and list the task pids assigned to
+which cgroup a task is assigned, and list the task PIDs assigned to
 a cgroup. Those creations and assignments only affect the hierarchy
 associated with that instance of the cgroup file system.
 
@@ -72,7 +72,7 @@ On their own, the only use for cgroups is for simple job
 tracking. The intention is that other subsystems hook into the generic
 cgroup support to provide new attributes for cgroups, such as
 accounting/limiting the resources which processes in a cgroup can
-access. For example, cpusets (see Documentation/cgroups/cpusets.txt) allows
+access. For example, cpusets (see Documentation/cgroups/cpusets.txt) allow
 you to associate a set of CPUs and a set of memory nodes with the
 tasks in each cgroup.
 
@@ -80,11 +80,11 @@ tasks in each cgroup.
 ----------------------------
 
 There are multiple efforts to provide process aggregations in the
-Linux kernel, mainly for resource tracking purposes. Such efforts
+Linux kernel, mainly for resource-tracking purposes. Such efforts
 include cpusets, CKRM/ResGroups, UserBeanCounters, and virtual server
 namespaces. These all require the basic notion of a
 grouping/partitioning of processes, with newly forked processes ending
-in the same group (cgroup) as their parent process.
+up in the same group (cgroup) as their parent process.
 
 The kernel cgroup patch provides the minimum essential kernel
 mechanisms required to efficiently implement such groups. It has
@@ -127,14 +127,14 @@ following lines:
                                / \
                Professors (15%)  students (5%)
 
-Browsers like Firefox/Lynx go into the WWW network class, while (k)nfsd go
-into NFS network class.
+Browsers like Firefox/Lynx go into the WWW network class, while (k)nfsd goes
+into the NFS network class.
 
 At the same time Firefox/Lynx will share an appropriate CPU/Memory class
 depending on who launched it (prof/student).
 
 With the ability to classify tasks differently for different resources
-(by putting those resource subsystems in different hierarchies) then
+(by putting those resource subsystems in different hierarchies),
 the admin can easily set up a script which receives exec notifications
 and depending on who is launching the browser he can
 
@@ -145,19 +145,19 @@ a separate cgroup for every browser launched and associate it with
 appropriate network and other resource class.  This may lead to
 proliferation of such cgroups.
 
-Also lets say that the administrator would like to give enhanced network
+Also let's say that the administrator would like to give enhanced network
 access temporarily to a student's browser (since it is night and the user
-wants to do online gaming :))  OR give one of the students simulation
-apps enhanced CPU power,
+wants to do online gaming :))  OR give one of the student's simulation
+apps enhanced CPU power.
 
-With ability to write pids directly to resource classes, it's just a
-matter of :
+With ability to write PIDs directly to resource classes, it's just a
+matter of:
 
        # echo pid > /sys/fs/cgroup/network/<new_class>/tasks
        (after some time)
        # echo pid > /sys/fs/cgroup/network/<orig_class>/tasks
 
-Without this ability, he would have to split the cgroup into
+Without this ability, the administrator would have to split the cgroup into
 multiple separate ones and then associate the new cgroups with the
 new resource classes.
 
@@ -184,20 +184,20 @@ Control Groups extends the kernel as follows:
    field of each task_struct using the css_set, anchored at
    css_set->tasks.
 
- - A cgroup hierarchy filesystem can be mounted  for browsing and
+ - A cgroup hierarchy filesystem can be mounted for browsing and
    manipulation from user space.
 
- - You can list all the tasks (by pid) attached to any cgroup.
+ - You can list all the tasks (by PID) attached to any cgroup.
 
 The implementation of cgroups requires a few, simple hooks
-into the rest of the kernel, none in performance critical paths:
+into the rest of the kernel, none in performance-critical paths:
 
  - in init/main.c, to initialize the root cgroups and initial
    css_set at system boot.
 
  - in fork and exit, to attach and detach a task from its css_set.
 
-In addition a new file system, of type "cgroup" may be mounted, to
+In addition, a new file system of type "cgroup" may be mounted, to
 enable browsing and modifying the cgroups presently known to the
 kernel.  When mounting a cgroup hierarchy, you may specify a
 comma-separated list of subsystems to mount as the filesystem mount
@@ -230,13 +230,13 @@ as the path relative to the root of the cgroup file system.
 Each cgroup is represented by a directory in the cgroup file system
 containing the following files describing that cgroup:
 
- - tasks: list of tasks (by pid) attached to that cgroup.  This list
-   is not guaranteed to be sorted.  Writing a thread id into this file
+ - tasks: list of tasks (by PID) attached to that cgroup.  This list
+   is not guaranteed to be sorted.  Writing a thread ID into this file
    moves the thread into this cgroup.
- - cgroup.procs: list of tgids in the cgroup.  This list is not
-   guaranteed to be sorted or free of duplicate tgids, and userspace
+ - cgroup.procs: list of thread group IDs in the cgroup.  This list is
+   not guaranteed to be sorted or free of duplicate TGIDs, and userspace
    should sort/uniquify the list if this property is required.
-   Writing a thread group id into this file moves all threads in that
+   Writing a thread group ID into this file moves all threads in that
    group into this cgroup.
  - notify_on_release flag: run the release agent on exit?
  - release_agent: the path to use for release notifications (this file
@@ -261,7 +261,7 @@ cgroup file system directories.
 
 When a task is moved from one cgroup to another, it gets a new
 css_set pointer - if there's an already existing css_set with the
-desired collection of cgroups then that group is reused, else a new
+desired collection of cgroups then that group is reused, otherwise a new
 css_set is allocated. The appropriate existing css_set is located by
 looking into a hash table.
 
@@ -292,7 +292,7 @@ file system) of the abandoned cgroup.  This enables automatic
 removal of abandoned cgroups.  The default value of
 notify_on_release in the root cgroup at system boot is disabled
 (0).  The default value of other cgroups at creation is the current
-value of their parents notify_on_release setting. The default value of
+value of their parents' notify_on_release settings. The default value of
 a cgroup hierarchy's release_agent path is empty.
 
 1.5 What does clone_children do ?
@@ -316,7 +316,7 @@ the "cpuset" cgroup subsystem, the steps are something like:
  4) Create the new cgroup by doing mkdir's and write's (or echo's) in
     the /sys/fs/cgroup virtual file system.
  5) Start a task that will be the "founding father" of the new job.
- 6) Attach that task to the new cgroup by writing its pid to the
+ 6) Attach that task to the new cgroup by writing its PID to the
     /sys/fs/cgroup/cpuset/tasks file for that cgroup.
  7) fork, exec or clone the job tasks from this founding father task.
 
@@ -344,7 +344,7 @@ and then start a subshell 'sh' in that cgroup:
 2.1 Basic Usage
 ---------------
 
-Creating, modifying, using the cgroups can be done through the cgroup
+Creating, modifying, using cgroups can be done through the cgroup
 virtual filesystem.
 
 To mount a cgroup hierarchy with all available subsystems, type:
@@ -441,7 +441,7 @@ You can attach the current shell task by echoing 0:
 # echo 0 > tasks
 
 You can use the cgroup.procs file instead of the tasks file to move all
-threads in a threadgroup at once. Echoing the pid of any task in a
+threads in a threadgroup at once. Echoing the PID of any task in a
 threadgroup to cgroup.procs causes all tasks in that threadgroup to be
 be attached to the cgroup. Writing 0 to cgroup.procs moves all tasks
 in the writing task's threadgroup.
@@ -479,7 +479,7 @@ in /proc/mounts and /proc/<pid>/cgroups.
 There is mechanism which allows to get notifications about changing
 status of a cgroup.
 
-To register new notification handler you need:
+To register a new notification handler you need to:
  - create a file descriptor for event notification using eventfd(2);
  - open a control file to be monitored (e.g. memory.usage_in_bytes);
  - write "<event_fd> <control_fd> <args>" to cgroup.event_control.
@@ -488,7 +488,7 @@ To register new notification handler you need:
 eventfd will be woken up by control file implementation or when the
 cgroup is removed.
 
-To unregister notification handler just close eventfd.
+To unregister a notification handler just close eventfd.
 
 NOTE: Support of notifications should be implemented for the control
 file. See documentation for the subsystem.
@@ -502,7 +502,7 @@ file. See documentation for the subsystem.
 Each kernel subsystem that wants to hook into the generic cgroup
 system needs to create a cgroup_subsys object. This contains
 various methods, which are callbacks from the cgroup system, along
-with a subsystem id which will be assigned by the cgroup system.
+with a subsystem ID which will be assigned by the cgroup system.
 
 Other fields in the cgroup_subsys object include:
 
@@ -516,7 +516,7 @@ Other fields in the cgroup_subsys object include:
   at system boot.
 
 Each cgroup object created by the system has an array of pointers,
-indexed by subsystem id; this pointer is entirely managed by the
+indexed by subsystem ID; this pointer is entirely managed by the
 subsystem; the generic cgroup code will never touch this pointer.
 
 3.2 Synchronization
@@ -639,7 +639,7 @@ void post_clone(struct cgroup *cgrp)
 
 Called during cgroup_create() to do any parameter
 initialization which might be required before a task could attach.  For
-example in cpusets, no task may attach before 'cpus' and 'mems' are set
+example, in cpusets, no task may attach before 'cpus' and 'mems' are set
 up.
 
 void bind(struct cgroup *root)
@@ -660,5 +660,5 @@ A: bash's builtin 'echo' command does not check calls to write() against
 
 Q: When I attach processes, only the first of the line gets really attached !
 A: We can only return one error code per call to write(). So you should also
-   put only ONE pid.
+   put only ONE PID.
 
