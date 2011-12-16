Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab1LPKr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 05:47:27 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:11675 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758751Ab1LPKrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 05:47:14 -0500
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 0/2] ptrace: add ability to attach a file descriptor to another process
Date: Fri, 16 Dec 2011 13:46:21 +0300
Message-Id: <1324032383-791758-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need this functionality for checkpointing processes.  Now some parts
are dumped with help PTRACE_SEIZE.  Parasite code is injected to process
and it collects information.  This code should save data to somewhere.
I want to suggest a scheme, when a dumper creates file descriptor and
attaches it to a target process, then execute parasite code, which closes
this descriptor at the end.

We can't create unix sockets or open files, because a process may
be in another namespaces.

Signed-off-by: Andrew Vagin <avagin@openvz.org>

Andrew Vagin (2):
  fs: add ability attaching and allocating fd for non current tasks
  ptrace: add ability to attach a file descriptor to another process

 fs/file.c              |    9 +++++++--
 fs/open.c              |    9 +++++++--
 include/linux/file.h   |    4 ++++
 include/linux/ptrace.h |    1 +
 kernel/ptrace.c        |   27 +++++++++++++++++++++++++++
 5 files changed, 46 insertions(+), 4 deletions(-)

