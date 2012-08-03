Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab2HCLZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 07:25:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62549 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab2HCLZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 07:25:04 -0400
MIME-Version: 1.0
In-Reply-To: <1343991184-3619-1-git-send-email-berrange@redhat.com>
References: <1343991184-3619-1-git-send-email-berrange@redhat.com>
Date: Fri, 3 Aug 2012 13:25:02 +0200
Message-ID: <CAFLxGvxTAchQuSfNy=aWQqfw3QwSr=JwUG=F3gj+HOuEbp64SQ@mail.gmail.com>
Subject: Re: [PATCH] Forbid invocation of kexec_load() outside initial PID namespace
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: "Daniel P. Berrange" <berrange@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 3, 2012 at 12:53 PM, Daniel P. Berrange <berrange@redhat.com> wrote:
> From: "Daniel P. Berrange" <berrange@redhat.com>
>
> The following commit
>
>     commit cf3f89214ef6a33fad60856bc5ffd7bb2fc4709b
>     Author: Daniel Lezcano <daniel.lezcano@free.fr>
>     Date:   Wed Mar 28 14:42:51 2012 -0700
>
>     pidns: add reboot_pid_ns() to handle the reboot syscall
>
> introduced custom handling of the reboot() syscall when invoked
> from a non-initial PID namespace. The intent was that a process
> in a container can be allowed to keep CAP_SYS_BOOT and execute
> reboot() to shutdown/reboot just their private container, rather
> than the host.
>
> Unfortunately the kexec_load() syscall also relies on the
> CAP_SYS_BOOT capability. So by allowing a container to keep
> this capability to safely invoke reboot(), they mistakenly
> also gain the ability to use kexec_load(). The solution is
> to make kexec_load() return -EPERM if invoked from a PID
> namespace that is not the initial namespace
>
> Signed-off-by: Daniel P. Berrange <berrange@redhat.com>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Cc: Daniel Lezcano <daniel.lezcano@free.fr>
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Oleg Nesterov <oleg@redhat.com>

Why is this commit not marked for -stable?

-- 
Thanks,
//richard
