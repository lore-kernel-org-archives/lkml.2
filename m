Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295Ab0G3Laq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 07:30:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527Ab0G3Lap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 07:30:45 -0400
Date: Fri, 30 Jul 2010 13:30:31 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Tomasz Buchert <tomasz.buchert@inria.fr>
Cc: linux-kernel@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/4] posix-cpu-timers: Introduction of wall clocks
Message-ID: <20100730133031.76b8f99f@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <1280483867-6387-3-git-send-email-tomasz.buchert@inria.fr>
References: <1280483867-6387-1-git-send-email-tomasz.buchert@inria.fr>
	<1280483867-6387-2-git-send-email-tomasz.buchert@inria.fr>
	<1280483867-6387-3-git-send-email-tomasz.buchert@inria.fr>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jul 2010 11:57:45 +0200
Tomasz Buchert <tomasz.buchert@inria.fr> wrote:
  
> -	read_lock(&tasklist_lock);
> +	rcu_read_lock();
>  	p = find_task_by_vpid(pid);
>  	if (!p || !(POSIX_CLOCK_PERTHREAD(which_clock) ?
>  		   same_thread_group(p, current) : thread_group_leader(p))) {
>  		error = -EINVAL;
>  	}
> -	read_unlock(&tasklist_lock);
> +	rcu_read_unlock();

IIRC thread_group_leader(p) is wrong here, has_group_leader_pid(p)
should be used. Beside this change alone should be a separate patch,
not part of a "new feature" patch.

Stanislaw
