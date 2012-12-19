Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab2LSSOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 13:14:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab2LSSN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 13:13:58 -0500
Date: Wed, 19 Dec 2012 19:14:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Serge Hallyn <serge@hallyn.com>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 11/11] pidns: Support unsharing the pid namespace.
Message-ID: <20121219181400.GA22991@redhat.com>
References: <8739097bkk.fsf@xmission.com> <1353083750-3621-1-git-send-email-ebiederm@xmission.com> <1353083750-3621-11-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353083750-3621-11-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

oleg@tv-sign.ru no longer works, so I just noticed these emails.

On 11/16, Eric W. Biederman wrote:
>
> Unsharing of the pid namespace unlike unsharing of other namespaces
> does not take affect immediately.  Instead it affects the children
> created with fork and clone.

I'll try to read this series later, but I am not sure I will ever
understand the code with these patches ;)

So alloc_pid() becomes the only user nsproxy->pid_ns and it is not
necessarily equal to task_active_pid_ns(). It seems to me that this
adds a lot of new corner cases.

Unless I missed something, at least we should not allow CLONE_THREAD
if active_pid_ns != nsproxy->pid_ns. If nothing else, copy_process()
initializes ->child_reaper only if thread_group_leader(child). And
->child_reaper == NULL can obviously lead to crash.

Oleg.

