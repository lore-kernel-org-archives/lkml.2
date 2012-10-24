Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161099Ab2JXS5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 14:57:20 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57357 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934943Ab2JXS5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 14:57:17 -0400
Date: Wed, 24 Oct 2012 14:57:10 -0400
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/7] freezer: add missing mb's to freezer_count() and
 freezer_should_skip()
Message-ID: <20121024185710.GA12182@atj.dyndns.org>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <1350426526-14254-3-git-send-email-tj@kernel.org>
 <20121022174404.GA21553@redhat.com>
 <20121022211317.GD5951@atj.dyndns.org>
 <20121023153919.GA16201@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023153919.GA16201@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Tue, Oct 23, 2012 at 05:39:19PM +0200, Oleg Nesterov wrote:
> > Hmm....  Guess we should drop __ from set_current_state.
> 
> Yes.
> 
> Or we can change ptrace_stop() and do_signal_stop() to use freezer_do_not_count/
> freezer_count and remove task_is_stopped_or_traced() from update_if_frozen()
> and try_to_freeze_tasks(). But this means that do_signal_stop() will call
> try_to_freeze() twice, unless we add __freezer_count() which only clears
> PF_FREEZER_SKIP.

Ooh, I like this idea.  If we have a mechanism to mark a task "frozen
enough", it makes sense to use it universally.  As long as
try_to_freeze() invocation stays outside fast path, I don't think
invoking it twice really matters.  Can you please cook up a patch for
it?

Thanks.

--
tejun
