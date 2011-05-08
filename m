Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab1EHPl5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 11:41:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790Ab1EHPly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 11:41:54 -0400
Date: Sun, 8 May 2011 17:40:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH ptrace] ptrace: fix signal->wait_chldexit usage in
	task_clear_group_stop_trapping()
Message-ID: <20110508154051.GA11251@redhat.com>
References: <20110506095222.GB8824@htj.dyndns.org> <20110508133543.GA4820@redhat.com> <20110508140221.GA29783@htj.dyndns.org> <20110508153435.GA11046@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110508153435.GA11046@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08, Oleg Nesterov wrote:
>
> Of course, we should take siglock. I meant, we could probably make
>
> 	static void ptrace_s_stopped_traced(struct task_struct *task)
> 	{
> 		bool wait_trap = false;
>
> 		spin_lock(&task->sighand->siglock);

this needs lock_task_sighand() of course.

And in any case this is minor.

Oleg.

