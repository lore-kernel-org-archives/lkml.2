Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935926Ab2JYQik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:38:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933072Ab2JYQih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:38:37 -0400
Date: Thu, 25 Oct 2012 18:39:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 0/1] (Was: freezer: add missing mb's to freezer_count() and
	freezer_should_skip())
Message-ID: <20121025163941.GA3801@redhat.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org> <1350426526-14254-3-git-send-email-tj@kernel.org> <20121022174404.GA21553@redhat.com> <20121022211317.GD5951@atj.dyndns.org> <20121023153919.GA16201@redhat.com> <20121024185710.GA12182@atj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024185710.GA12182@atj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 10/24, Tejun Heo wrote:
> Hello, Oleg.
>
> On Tue, Oct 23, 2012 at 05:39:19PM +0200, Oleg Nesterov wrote:
> > > Hmm....  Guess we should drop __ from set_current_state.
> >
> > Yes.
> >
> > Or we can change ptrace_stop() and do_signal_stop() to use freezer_do_not_count/
> > freezer_count and remove task_is_stopped_or_traced() from update_if_frozen()
> > and try_to_freeze_tasks(). But this means that do_signal_stop() will call
> > try_to_freeze() twice, unless we add __freezer_count() which only clears
> > PF_FREEZER_SKIP.
>
> Ooh, I like this idea.  If we have a mechanism to mark a task "frozen
> enough", it makes sense to use it universally.

Yes, I agree.

Fortunately we already have freezable_schedule() so this patch is
really simple.

On top of this series.

Oleg.

