Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1KQSkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 13:40:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384Ab1KQSku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 13:40:50 -0500
Date: Thu, 17 Nov 2011 19:36:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Roland McGrath <roland@hack.frob.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 3/3] pids: Make it possible to clone tasks with given
	pids
Message-ID: <20111117183605.GA20552@redhat.com>
References: <4EC4F2FB.408@parallels.com> <4EC4F348.6020101@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC4F348.6020101@parallels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My previous objection was wrong, I should try to find something else ;)

On 11/17, Pavel Emelyanov wrote:
>
> +static int set_pidmap(struct pid_namespace *pid_ns, int pid)
> +{
> +	int offset;
> +	struct pidmap *map;
> +
> +	/*
> +	 * When creating a new pid namespace we must make its init
> +	 * have pid == 1 in it.
> +	 */
> +	if (pid_ns->child_reaper == NULL)
> +		return 0;
> +
> +	/*
> +	 * Don't allow to create a task with a pid which has recently
> +	 * belonged to some other (dead already) task. Only init (of
> +	 * a freshly created namespace) and his clones can do this.
> +	 */
> +	if (pid_ns->last_pid != 1)
> +		return -EPERM;
> +
> +	map = &pid_ns->pidmap[pid/BITS_PER_PAGE];

probably we should check that map < PIDMAP_ENTRIES ?

Oleg.

