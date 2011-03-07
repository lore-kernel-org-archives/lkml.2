Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab1CGNND (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 08:13:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab1CGNM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 08:12:57 -0500
Date: Mon, 7 Mar 2011 14:03:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCHSET] ptrace,signal: group stop / ptrace updates, take#2
Message-ID: <20110307130332.GA10777@redhat.com>
References: <1299321427-15051-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299321427-15051-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05, Tejun Heo wrote:
>
> This patchset contains the following ten patches.
>
>  0001-signal-fix-SIGCONT-notification-code.patch
>  0002-ptrace-remove-the-extra-wake_up_state-from-ptrace_de.patch
>  0003-signal-remove-superflous-try_to_freeze-loop-in-do_si.patch
>  0004-ptrace-kill-tracehook_notify_jctl.patch
>  0005-ptrace-add-why-to-ptrace_stop.patch
>  0006-signal-fix-premature-completion-of-group-stop-when-i.patch
>  0007-signal-use-GROUP_STOP_PENDING-to-stop-once-for-a-sin.patch
>  0008-ptrace-participate-in-group-stop-from-ptrace_stop-if.patch
>  0009-ptrace-make-do_signal_stop-use-ptrace_stop-if-the-ta.patch
>  0010-ptrace-clean-transitions-between-TASK_STOPPED-and-TR.patch
>
> In light of the proposal, this patchset can be separated into two
> parts.  The first part, patches 0001 through 0006, tightens various
> loose ends and prepare for further changes.  Except for 0004, every
> patch is acked by Oleg and/or Roland.  0004 doesn't cause any behavior
> change and removes a tracehook for future changes.
>
> The second part, 0007-0010, fixes group stop participation accounting
> and make tracees always stop in TASK_TRACED instead of TASK_STOPPED.
> IOW, it implements "P1. Always TASK_TRACED while ptraced" of the
> proposal.

Looks like, we already discussed these changes? I mean, at first
glance the only difference (compared to the previous series) is that
10/10 simplifies the usage of task_clear_group_stop_trapping().

In this case please free to add my reviewed-by or acked-by.

> Roland, Oleg, Andrew, if there's no objection, I'd like to set up a
> git tree to route further developments in the area.  We're going to
> see a lot of patches and it's simply much more efficient to have a
> dedicated stable git branch.

Agreed.

> I don't really care who controls the tree and don't intend to commit
> any patch without Oleg's Acked-by so it would make most sense for Oleg
> to control the branch but, if Oleg dosnn't want to, I'd be happy to do
> it.  No matter who does it, let's _PLEASE_ establish a stable tree.
>
> This patchset is available in the following git branch.
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git ptrace-review

Thanks!

As for "who controls" I do not care too. But I think I should help you
as much as I can. I'll contact you in a few days to discuss this, but
let me repeat once again: whatever you prefer is fine for me.

Oleg.

