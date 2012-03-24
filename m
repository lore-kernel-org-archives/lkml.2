Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab2CXGRL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 02:17:11 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35909 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab2CXGRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 02:17:09 -0400
Date: Sat, 24 Mar 2012 10:17:04 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: akpm@linux-foundation.org, xemul@parallels.com, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] prctl.2: Add PR_SET_MM option description
Message-ID: <20120324061704.GA4324@moon>
References: <1331326042-32558-1-git-send-email-gorcunov@openvz.org>
 <1331326042-32558-2-git-send-email-gorcunov@openvz.org>
 <CAKgNAkgJm01K9+GhnouxUwOUW3gk+YiuHLfofrs7adWzEqqO8Q@mail.gmail.com>
 <20120320222424.GL14269@moon>
 <CAKgNAkghWdju=o1prxw8dXEVjf95a+jLpe+3oKeHRWN1UK_cKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgNAkghWdju=o1prxw8dXEVjf95a+jLpe+3oKeHRWN1UK_cKg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 24, 2012 at 03:59:49PM +1300, Michael Kerrisk (man-pages) wrote:
> 
> Hi Cyrill,
> 
> I only just had a chance to look at this now and realize that this is
> a patch on a patch. Could you just send me a complete  patch with all
> the changes?
> 

Sure, here is it

	Cyrill
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Date: Sat, 24 Mar 2012 10:15:28 +0400
Subject: [PATCH 2/2] prctl.2: Add PR_SET_MM option description

CC: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 man2/prctl.2 |  174 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 173 insertions(+), 1 deletions(-)

diff --git a/man2/prctl.2 b/man2/prctl.2
index effad2a..de15426 100644
--- a/man2/prctl.2
+++ b/man2/prctl.2
@@ -378,6 +378,134 @@ Return the current per-process machine check kill policy.
 All unused
 .BR prctl ()
 arguments must be zero.
+.TP
+.BR PR_SET_MM " (since Linux 3.3)"
+Allows a user to modify certain kernel memory map descriptor fields
+of the calling process.
+Usually these fields are set by the kernel and dynamic loader (see
+.BR ld.so (8)
+for more information) and a regular application should not use this feature.
+Still there are cases such as self-modifying programs, where a program might
+find it useful to change its own memory map.
+The kernel must be built with
+.BR CONFIG_CHECKPOINT_RESTORE
+option turned on, otherwise this feature will not be accessible
+from a user space level.
+The calling process must have
+.BR CAP_SYS_RESOURCE
+(see
+.BR capabilities (7)
+for details) capability granted.
+The value in
+.I arg2
+is one of the options below, while
+.I arg3
+provides a new value for this option.
+
+.BR PR_SET_MM_START_CODE
+to set the address above which program text can run.
+The corresponding memory area must be readable and executable,
+but not writable or shareable (see
+.BR mprotect (2)
+and
+.BR mmap (2)
+for more information).
+
+.BR PR_SET_MM_END_CODE
+to set the address below which program text can run.
+The corresponding memory area must be readable and executable,
+but not writable or shareable.
+
+.BR PR_SET_MM_START_DATA
+to set the address above which program data+bss is placed.
+The corresponding memory area must be readable and writable,
+but not executable or shareable.
+
+.B PR_SET_MM_END_DATA
+to set the address below which program data+bss is placed.
+The corresponding memory area must be readable and writable,
+but not executable or shareable.
+
+.BR PR_SET_MM_START_STACK
+to set the start address of the stack.
+The corresponding memory area must be readable and writable.
+
+.BR PR_SET_MM_START_BRK
+to set the address above which program heap can be expanded with
+.BR brk (2)
+call.
+The address must not be greater than ending address of
+the current program data segment, neither it may exceed
+resource limit for data (see
+.BR setrlimit (2)
+for more information).
+
+.BR PR_SET_MM_BRK
+to set the current
+.BR brk (2)
+value.
+The requirements for address are the same as for
+.BR PR_SET_MM_START_BRK
+option.
+
+.BR PR_SET_MM_ARG_START
+to set the address above which program command line is placed.
+
+.BR PR_SET_MM_ARG_END
+to set the address below which program command line is placed.
+
+.BR PR_SET_MM_ENV_START
+to set the address above which program environment is placed.
+
+.BR PR_SET_MM_ENV_END
+to set the address below which program environment is placed.
+
+The address passed with
+.BR PR_SET_MM_ARG_START ,
+.BR PR_SET_MM_ARG_END ,
+.BR PR_SET_MM_ENV_START ,
+.BR PR_SET_MM_ENV_END ,
+should belong to a process stack area, thus corresponding memory area
+must be readable, writable and (depending on the kernel
+configuration) has
+.BR MAP_GROWSDOWN
+attribute set (see
+.BR mmap (2)
+for details).
+
+.BR PR_SET_MM_AUXV
+to set a new auxiliary vector.
+The
+.I arg3
+argument should provide the address of the vector.
+The
+.I arg4
+is the size of the vector.
+
+.BR PR_SET_MM_EXE_FILE
+to supersede
+.IR /proc/pid/exe
+symbolic link with a new one pointing to a new executable file
+which descriptor is provided provided in the
+.I arg3
+argument.
+The file descriptor should be obtaned with a regular
+.BR open (2)
+call.
+
+To change the symlink, one needs to unmap all existing
+executable memory areas being created by the kernel itself
+(for example the kernel usually creates at least one executable
+memory area for Elf file
+.IR \.text
+section).
+
+The second limitation is that such transition can be done once
+in a process life time.
+Any furter attempts will be rejected.
+This should help system administrators to monitor the unusual
+symlinks transitions over all process running in a system.
+.\"
 .SH "RETURN VALUE"
 On success,
 .BR PR_GET_DUMPABLE ,
@@ -411,7 +539,9 @@ is not recognized.
 is
 .BR PR_MCE_KILL
 or
-.BR PR_MCE_KILL_GET ,
+.BR PR_MCE_KILL_GET
+or
+.BR PR_SET_MM ,
 and unused
 .BR prctl ()
 arguments were not specified as zero.
@@ -459,6 +589,48 @@ is
 and the caller does not have the
 .B CAP_SETPCAP
 capability.
+.TP
+.B EPERM
+.I option
+is
+.BR PR_SET_MM ,
+and the caller does not have the
+.B CAP_SYS_RESOURCE
+capability.
+.TP
+.B EACCES
+.I option
+is
+.BR PR_SET_MM ,
+and the
+.I arg3
+is
+.BR PR_SET_MM_EXE_FILE ,
+the file is not executable one.
+.TP
+.B EBUSY
+.I option
+is
+.BR PR_SET_MM ,
+and the
+.I arg3
+is
+.BR PR_SET_MM_EXE_FILE ,
+the second attempt to change
+.I /proc/pid/exe
+symlink is prohibited.
+.TP
+.B EBADF
+.I option
+is
+.BR PR_SET_MM ,
+and the
+.I arg3
+is
+.BR PR_SET_MM_EXE_FILE ,
+the file descriptor passed in
+.I arg4
+is not found.
 .\" The following can't actually happen, because prctl() in
 .\" seccomp mode will cause SIGKILL.
 .\" .TP
-- 
1.7.7.6

