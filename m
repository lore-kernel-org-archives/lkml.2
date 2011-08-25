Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab1HYVwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 17:52:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50276 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab1HYVwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 17:52:07 -0400
Date: Thu, 25 Aug 2011 23:52:03 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 06/16] freezer: make exiting tasks properly unfreezable
Message-ID: <20110825215203.GS2803@mtj.dyndns.org>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
 <1313763382-12341-7-git-send-email-tj@kernel.org>
 <20110823155221.GB25808@redhat.com>
 <20110823194451.GH2803@mtj.dyndns.org>
 <20110824141431.GA8562@redhat.com>
 <20110825155957.GJ2803@mtj.dyndns.org>
 <20110825165650.GA8006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825165650.GA8006@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Thu, Aug 25, 2011 at 06:56:50PM +0200, Oleg Nesterov wrote:
> But still I can't understand why it is better to consider the exiting
> task as "frozen" from the very beginning, right after PTRACE_EVENT_EXIT.
> do_exit() does a lot of misc things, and this patch simply makes it
> "invisible" to the freezer. This looks "unsafe" even if this is fine
> for suspend/etc.
> 
> To me, try_to_freeze_tasks() should succed when all threads either
> sleep in refrigerator(), or ->state = TASK_DEAD (the final schedule()
> was called). Until then try_to_freeze_tasks() should retry.

Hmmm... yeah, maybe moving it right after setting ->state would be
safer.  Care to send a patch?

> But since we can't see the threads after exit_notify (in general),
> the current ->exit_state check looks reasonable.

I prefer setting NOFREEZE after point of no return from exit path.
The intention is clearer that way, I think.

> > Another freezer user is the cgroup,
> 
> Yes. And I don't understand this case too. I mean, the fact we ignore
> the exiting tasks.

Because it's basically a mass (or meta) job control mechanism and it's
nicer to be able to kill processes after freezing berserk cgroups.

Thanks.

-- 
tejun
