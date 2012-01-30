Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab2A3OS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 09:18:59 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56525 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab2A3OS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 09:18:57 -0500
Message-Id: <20120130140905.441199885@openvz.org>
User-Agent: quilt/0.48-1
Date: Mon, 30 Jan 2012 18:09:05 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [patch cr 0/4] [patch cr 0/@total@]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is a series where I tried to resolve all concerns and nits
I've got from previous attempt:

 - fs, proc: Introduce /proc/<pid>/task/<tid>/children entry v9
	Now everything is under CONFIG_CHECKPOINT_RESTORE

 - syscalls, x86: Add __NR_kcmp syscall v7
	* EBADF returned if there is no file
	* EOPNOTSUP returned if there is no sysv support compiled in
	* test uses syscall() from libc instead of own syscall implementation
	* man page for this syscall is under progress still

 - c/r: procfs: add arg_start/end, env_start/end and exit_code members to /proc/$pid/stat
	task->exit_code is shown IIF a caller has enough permissions

 - c/r: prctl: Extend PR_SET_MM to set up more mm_struct entries
	when restoring mm->saved_auxv the task_lock is used to serialize access

Please review, if there is something I'm still missing, ping me back.

Thanks,
	Cyrill
