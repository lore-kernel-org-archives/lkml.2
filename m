Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462Ab0G3LYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 07:24:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756305Ab0G3LYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 07:24:14 -0400
Date: Fri, 30 Jul 2010 13:23:43 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Tomasz Buchert <tomasz.buchert@inria.fr>
Cc: linux-kernel@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/4] Wall time clocks + change in access rules
Message-ID: <20100730132343.4c15bfdc@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <1280483867-6387-1-git-send-email-tomasz.buchert@inria.fr>
References: <1280483867-6387-1-git-send-email-tomasz.buchert@inria.fr>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz

On Fri, 30 Jul 2010 11:57:43 +0200
Tomasz Buchert <tomasz.buchert@inria.fr> wrote:
> During our work we encountered a problem of obtaining
> a reliable and fine-grained measurements of CPU time/wall time
> of a process/thread. The existing methods (taskstats, procfs,
> POSIX CPU clocks) have either unfriendly interface (taskstats)

Well, "unfriendly" is not technical word ...  Taskstat was designed
as extensible method to provide statistics to user space, including
some special needs like yours. What your patches basically do, is get
the value of wall_time(p) = uptime - p->start_time . I do not see
any reason why this calculation can not be done in userspace, getting
uptime and p->start_time from kernel by existing methods (or adding
new one for p->start_time if precise method does not really exist).
Is enough to read p->start_time only once at the beginning, this value
does not change.

Anyway, I think we need better rationale, before we can consider your wall 
clock patches inclusion into the kernel.
 
BTW: If you will repost please cc Thomas Gleixner as he is kernel/*timers*
maintainer.

Cheers
Stanislaw
