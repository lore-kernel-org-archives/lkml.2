Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab1HQNJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 09:09:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908Ab1HQNJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 09:09:03 -0400
Date: Wed, 17 Aug 2011 15:05:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lennart@poettering.net, kay.sievers@vrfy.org,
        linux-man@vger.kernel.org, roland@hack.frob.com,
        torvalds@linux-foundation.org
Subject: Re: +
	prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision
	.patch added to -mm tree
Message-ID: <20110817130531.GA12204@redhat.com>
References: <201108162011.p7GKBcY0023134@imap1.linux-foundation.org> <20110817115543.GA8745@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110817115543.GA8745@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17, Oleg Nesterov wrote:
>
> On 08/16, Andrew Morton wrote:
> >
> > From: Lennart Poettering <lennart@poettering.net>
> >
> > Userspace service managers/supervisors need to track their started
> > services.  Many services daemonize by double-forking and get implicitely
> > re-parented to PID 1.  The process manager will no longer be able to
> > receive the SIGCHLD signals for them.
> >
> > With this prctl, a service manager can mark itself as a sort of 'sub-init'
> > process, able to stay as the parent process for all processes created by
> > the started services.  All SIGCHLD signals will be delivered to the
> > service manager.
>
> I try to never argue with the new features. But to be honest, this
> doesn't look very good to me.
>
> OK, a service manager M does prctl(PR_SET_CHILD_REAPER), then it forks
> a service X which forks another child C and exits. Then C exits and
> notifies M.
>
> But. How can M know that the service X should be restarted? It only
> knows the pid. What if wait(WEXITED) succeeds because C in turn does
> fork + exit? What M has 2 or more services?

Also. I am almost sure I have already reviewed a very similar patch
a long ago. Ungortunately, I can't find the previous discussion, and
I can't recall why that patch was not accepted.

But, I seem to remember, that patch cleared ->child_reaper on exec,
I think this makes sense.

And I am not sure about security. No, I do not see any problems, just
I don't know. Say, should we check the creds during reparenting? I
dunno.

Oleg.

