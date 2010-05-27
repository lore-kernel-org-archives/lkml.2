Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab0E0FZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 01:25:32 -0400
Received: from mail4.comsite.net ([205.238.176.238]:55429 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab0E0FZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 01:25:31 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.98.68;
From: Milton Miller <miltonm@bga.com>
To: Len Brown <len.brown@intel.com>
X-Mailer: vi
Cc: Peter Zijlstra <peterz@infradead.org>, <linux-acpi@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
In-Reply-To: <4a831611847e8965ed5f3328e52fe8758115b951.1274926772.git.len.brown@intel.com>
References: <4a831611847e8965ed5f3328e52fe8758115b951.1274926772.git.len.brown@intel.com>
	<1274928151-30919-1-git-send-email-lenb@kernel.org>
	<e099975ca65a7f6ac7f8bc3fee84d3e03893aa31.1274926772.git.len.brown@intel.com>
Date: Thu, 27 May 2010 00:25:29 -0500
Subject: (No subject header)
X-Originating-IP: 71.22.98.68
Message-ID: <1274937929_9182@mail4.comsite.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Hmm, why did this not appear in patchwork.kernel.org?  Now
I have to guess a CC list.]

On Wed, 26 May 2010 around 22:43:50 -0400 (EDT), Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
> 
> TS_POLLING set tells the scheduler a task will poll
> need_resched() to look for work.
> 

True

> TS_POLLING clear tells resched_task() and wake_up_idle_cpu()
> that the remote CPU is sleeping in idle, and thus requires
> a reschedule interrupt to wake them to notice work.

No, that only applies to the idle task.


> 
> Update the description of TS_POLLING to reflect how it works.
> "cleared when sleeping in idle, requiring reschedule interrupt"

That would imply its set for every normal task that is not in some
kind of sleep state.


> 
> Signed-off-by: Len Brown <len.brown@intel.com>
> Acked-by: Peter Zijlstra <peterz@infradead.org>

> -#define TS_POLLING		0x0004	/* true if in idle loop
> -					   and not sleeping */
> +#define TS_POLLING		0x0004	/* clear when sleeping in idle
> +					   requiring reschedule interrupt */

How about "idle task polling need_resched, skip sending interrupt"?

milton
