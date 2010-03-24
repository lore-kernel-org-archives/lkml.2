Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760Ab0CXSON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 14:14:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932148Ab0CXSOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 14:14:11 -0400
Date: Wed, 24 Mar 2010 19:12:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/1] proc: turn signal_struct->count into "int
	nr_threads"
Message-ID: <20100324181224.GA22456@redhat.com>
References: <20100324174936.GA21534@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100324174936.GA21534@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24, Oleg Nesterov wrote:
>
> No functional changes, just s/atomic_t count/int nr_threads/.

Argh, I forgot to send "[PATCH 0/1]", please see below...


[PATCH -mm 0/1] proc: turn signal_struct->count into "int nr_threads"

Depends on

	[PATCH -mm 1/2] proc_sched_show_task: use get_nr_threads()
	[PATCH -mm 2/2] keyctl_session_to_parent: use thread_group_empty() to check singlethreadness

and on top of the trivial

	[PATCH -mm] signals-clear-signal-tty-when-the-last-thread-exits.fix

I did "make allyesconfig" to test this change, but the compilation
failed because of unrelated bugs, and of course "count" is not really
grepable :/

However,

	$ grep -nr --include=*.[ch] -E 'sig\w*->count' */ | grep -Ev 'sigh(and)?->count'
	kernel/fork.c:827:	atomic_set(&sig->count, 1);

and this "sig" above is in fact sighand.

Fortunately, if I missed some user of signal->count the necessary fix
will be really trivial. And I bet in this case that user should be
wrong anyway.

Oleg.

