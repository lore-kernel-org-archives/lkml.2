Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab1HSU7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 16:59:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53618 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab1HSU7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 16:59:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] freezer: fix various bugs and simplify implementation
Date: Fri, 19 Aug 2011 23:00:55 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: arnd@arndb.de, oleg@redhat.com,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
In-Reply-To: <1313763382-12341-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201108192300.55405.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 19, 2011, Tejun Heo wrote:
> Hello,
> 
> The freezer code has developed a number of convolutions and bugs.
> It's now using five per-task flags - TIF_FREEZE, PF_FREEZING,
> PF_NOFREEZE, PF_FROZEN, PF_FREEZER_SKIP and PF_FREEZER_NOSIG, and at
> the same time has quite a few race conditions.  PF_NOFREEZE
> modifications can race against PM freezer, cgroup_freezer can race
> against PM freezer, and so on.
> 
> This patchset tries to simplify the freezer implementation and fix the
> various bugs.  It makes the synchronization more straight forward and
> replaces TIF_FREEZE with directly checking freeze conditions which are
> in effect, which makes the whole thing much saner.
> 
> This patchset removes TIF_FREEZE and PF_FREEZING.  Also,
> PF_FREEZER_SKIP users are planned to move away from the flag and will
> be removed.  It contains the following 16 patches.
> 
>  0001-freezer-fix-current-state-restoration-race-in-refrig.patch
>  0002-freezer-don-t-unnecessarily-set-PF_NOFREEZE-explicit.patch
>  0003-freezer-unexport-refrigerator-and-update-try_to_free.patch
>  0004-freezer-implement-and-use-kthread_freezable_should_s.patch
>  0005-freezer-rename-thaw_process-to-__thaw_task-and-simpl.patch
>  0006-freezer-make-exiting-tasks-properly-unfreezable.patch
>  0007-freezer-don-t-distinguish-nosig-tasks-on-thaw.patch
>  0008-freezer-use-dedicated-lock-instead-of-task_lock-memo.patch
>  0009-freezer-make-freezing-indicate-freeze-condition-in-e.patch
>  0010-freezer-fix-set_freezable-_with_signal-race.patch
>  0011-freezer-kill-PF_FREEZING.patch
>  0012-freezer-clean-up-freeze_processes-failure-path.patch
>  0013-cgroup_freezer-prepare-for-removal-of-TIF_FREEZE.patch
>  0014-freezer-make-freezing-test-freeze-conditions-in-effe.patch
>  0015-freezer-remove-now-unused-TIF_FREEZE.patch
>  0016-freezer-remove-should_send_signal-and-update-frozen.patch
> 
> This patchset is on top of the current linus#master (01b883358b "Merge
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc") and
> available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git freezer

Good work, thanks for doing this.  I'd like this to go through my
tree if you don't mind, so please let me know when the patchset is
ready for me to pull from your branch.

Also please CC linux-pm on PM-related patches.

Thanks,
Rafael
