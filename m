Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab2BHTVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 14:21:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828Ab2BHTVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 14:21:34 -0500
Date: Wed, 8 Feb 2012 20:21:26 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Pedro Alves <palves@redhat.com>, Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ptrace: add ability to get clear_tid_address
Message-ID: <20120208192126.GA15599@host2.jankratochvil.net>
References: <4F2C0F13.70709@parallels.com>
 <20120203165132.GA5636@redhat.com>
 <4F31848A.9070406@redhat.com>
 <20120207205639.GJ27437@moon>
 <4F31945B.5000304@redhat.com>
 <20120207215121.GB29773@moon>
 <4F326AF7.3060203@redhat.com>
 <20120208173103.GA20853@redhat.com>
 <4F32B924.8080407@redhat.com>
 <20120208190250.GA23163@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120208190250.GA23163@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Feb 2012 20:02:50 +0100, Oleg Nesterov wrote:
> If only I understood why do we need CLONE_CHILD_SETTID... at least
> I certainly do not understand why glibc translates fork() into
> clone(CLONE_CHILD_SETTID) on my system. The child write into its
> memory, the parent can't see this change. IIRC, initially
> CLONE_CHILD_SETTID wrote child->pid into the parent's memory, and
> even before the child was actually created.

IIUC your question correctly it is because if you PTRACE_SYSCALL SYS_fork
(therefore you PTRACE_SYSCALL SYS_clone) twice (therefore you stop on the
fork/clone syscall exit) you should have struct pthread contents valid for
iterating and examinating the thread structures via libthread_db.

This cannot be achieved by any userland code.


Regards,
Jan
