Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab1BOTYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 14:24:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab1BOTYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 14:24:33 -0500
Date: Tue, 15 Feb 2011 20:15:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Lezcano <daniel.lezcano@free.fr>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        xemul@openvz.org, sukadev@us.ibm.com, ebiederm@xmission.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 0/1] Was: pidns: Support unsharing the pid namespace.
Message-ID: <20110215191521.GB16707@redhat.com>
References: <1297788824-20534-1-git-send-email-daniel.lezcano@free.fr> <1297788824-20534-2-git-send-email-daniel.lezcano@free.fr> <20110215190118.GA16707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110215190118.GA16707@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15, Oleg Nesterov wrote:
>
> On 02/15, Daniel Lezcano wrote:
> >
> > - Pass both nsproxy->pid_ns and task_active_pid_ns to copy_pid_ns
> >   As they can now be different.
>
> But since they can be different we have to convert some users of
> current->nsproxy first? But that patch was dropped.
>
> > Unsharing of the pid namespace unlike unsharing of other namespaces
> > does not take effect immediately.  Instead it affects the children
> > created with fork and clone.
>
> IOW, unshare(CLONE_NEWPID) implicitly affects the subsequent fork(),
> using the very subtle way.
>
> I have to admit, I can't say I like this very much. OK, if we need
> this, can't we just put something into, say, signal->flags so that
> copy_process can check and create the new namespace.
>
> Also. I remember, I already saw something like this and google found
> my questions. I didn't actually read the new version, perhaps my
> concerns were already answered...
>
> 	But what if the task T does unshare(CLONE_NEWPID) and then, say,
> 	pthread_create() ? Unless I missed something, the new thread won't
> 	be able to see T ?
>
> 	and, in this case the exiting sub-namespace init also kills its
> 	parent?
>
> 	OK, suppose it does fork() after unshare(), then another fork().
> 	In this case the second child lives in the same namespace with
> 	init created by the 1st fork, but it is not descendant ? This means
> 	in particular that if the new init exits, zap_pid_ns_processes()->
> 	do_wait() can't work.
>
> Or not?

And, can't resist. If we are going to change sys_unshare(), I'd like
very much to cleanup it first.

Dear all! I promise, I will resend this patch forever until somebody
explains me why it is constantly ignored ;)

Oleg.

