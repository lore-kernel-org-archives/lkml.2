Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965244Ab1GMKRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 06:17:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36334 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964996Ab1GMKRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 06:17:07 -0400
Date: Wed, 13 Jul 2011 12:17:01 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] has_stopped_jobs: s/task_is_stopped/SIGNAL_STOP_STOPPED/
Message-ID: <20110713101701.GH2872@htj.dyndns.org>
References: <20110707193354.GA27600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110707193354.GA27600@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 09:33:54PM +0200, Oleg Nesterov wrote:
> has_stopped_jobs() naively checks task_is_stopped(group_leader). This
> was always wrong even without ptrace, group_leader can be dead. And
> given that ptrace can change the state to TRACED this is wrong even
> in the single-threaded case.
> 
> Change the code to check SIGNAL_STOP_STOPPED and simplify the code,
> retval + break/continue doesn't make this trivial code more readable.
> 
> We could probably add the usual "|| signal->group_stop_count" check
> but I don't think this makes sense, the task can start the group-stop
> right after the check anyway.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

 Acked-by: Tejun Heo <tj@kernel.org>

As for "|| signal->group_stop_count", it might be better to use the
same wrapper here too for consistency if we add one.

Thank you.

-- 
tejun
