Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab1JQMoC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 08:44:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33276 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab1JQMoA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 08:44:00 -0400
Subject: Re: [PATCH 0/5] ipc/sem.c: multiple fixes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>
Date: Mon, 17 Oct 2011 14:43:48 +0200
In-Reply-To: <1318684879-1887-1-git-send-email-manfred@colorfullife.com>
References: <1318684879-1887-1-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318855428.4172.16.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-10-15 at 15:21 +0200, Manfred Spraul wrote:
> Hi all,
> 
> The wakeup scheme used by semtimedop() does not work as intended on -rt.
> 
> The following series:
> - fixes one bug that I noticed while thinking about a -rt compatible
>   implementation
> - prevents the code from returning to user space due to spurious wakeups.
>   (noticed by Peter Zijlstra)
> - moves private structures from include/linux/sem.h to ipc/sem.c
> - saves some memory if sysvipc is disabled.
> - reworks the wakeup scheme and adds a 2nd wakeup scheme that is based
>   on a completion. For CONFIG_PREEMPT_RT_BASE, this scheme is used.
> 
> What do you think?
> The rework of the wakeup should also help to convert the code to
> using the wake_up_list framework.
> 
> Andrew: Could you replace the patches in -mm with this series?
> I would prefer to keep the current scheme as the default, it's
> ~5% faster (6.5 usec vs. 6.8 usec per wakeup).
> 
> The patches pass checkpatch.pl and I didn't observe any problems
> with my test apps.

For patches 1-4:

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

I still need to kick my brain in gear and parse patch 5.
