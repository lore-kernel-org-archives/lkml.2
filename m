Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab2LUTYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 14:24:21 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49334 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab2LUTYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 14:24:18 -0500
Date: Fri, 21 Dec 2012 13:24:14 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 11/11] pidns: Support unsharing the pid namespace.
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <87fw2zmgzc.fsf@xmission.com> (from ebiederm@xmission.com on
	Fri Dec 21 11:51:03 2012)
X-Mailer: Balsa 2.4.11
Message-Id: <1356117854.21178.2@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2012 11:51:03 AM, Eric W. Biederman wrote:
> Oleg Nesterov <oleg@redhat.com> writes:
> 
> > Eric. I understand that it is too late to discuss this. And yes, I  
> simply
> > do not understand the problem space, I never used containers.
> >
> > But, stupid question. Let's ignore the pid_ns-specific oddities.
> >
> > 1. Ignoring setns(), why do we need /proc/pid/ns/ ?
> >
> > 2. Why setns() requires /proc/pid/ns/ ? IOW, why it can't be
> >
> > 	sys_setns(pid_t pid, int clone_flags)
> > 	{
> > 		truct task_struct *tsk = find_task_by_vpid(pid);
> > 		struct nsproxy *target = get_nsproxy(tsk->nsproxy);
> >
> > 		new_nsproxy = create_new_namespaces(...);
> >
> > 		if (clone_flags & CLONE_NEWNS)
> > 			mntns_install(...);
> > 		if (clone_flags & CLONE_NEWIPC)
> > 			ipcns_install(...);
> > 		...
> > 	}
> >
> > I feel I missed something trivial, but what?
> 
> It is a question of naming.
> 
> The problem I set out to solve when all of this was introduced was how
> to name namespaces without introducing yet another namespace.
> 
> The solution to the naming problem that I finally found was to  
> introduce
> something I could mount.

Where might I find documentation on this? I'm aware of  
Documentation/namespaces but it's only got one file in it (about  
conflicts between namespace types). I'm aware of  
http://lxc.sourceforge.net/index.php/about/kernel-namespaces/ and  
http://lxc.sourceforge.net/man/ but that's mixed in with the  
implementation details of a particular userspace tool, and tends to lag  
the kernel significantly. (Those man pages were last updated in 2010,  
which if I recall was the last time I poked them about it.)

Rob