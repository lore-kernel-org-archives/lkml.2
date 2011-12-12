Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab1LLJjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 04:39:14 -0500
Received: from [205.233.59.134] ([205.233.59.134]:33237 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab1LLJjN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 04:39:13 -0500
Message-ID: <1323682702.16764.59.camel@twins>
Subject: Re: [PATCH] Softlockup (out of cpu) killer
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vincent Li <vincent.mc.li@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org
Date: Mon, 12 Dec 2011 10:38:22 +0100
In-Reply-To: <1323643735-1999-1-git-send-email-vincent.mc.li@gmail.com>
References: <1323643735-1999-1-git-send-email-vincent.mc.li@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-12-11 at 14:48 -0800, Vincent Li wrote:
> In kernel, there is out of memory (OOM) killer, why not make an out of cpu (OOC) killer?
> I tested following patch by running an user-space cpu hogging process and the softlockukp
> detector killed the process successfully.
> 
>  Softlockup could be caused by user-space process hogging cpu, add softlockup_kill kernel
>  config to allow kernel to kill the user space cpu hogging process. this feature is
>  useful for high availability systems that have uptime gurantees and where a softlockup
>  must be resolved ASAP
> 
> echo 1 > /proc/sys/kernel/softlockukp_kill to enable cpu hog process killer
> echo 0 > /proc/sys/kernel/softlockup_kill to disable cpu hog process killer
> 
> Signed-off-by: Vincent Li <vincent.mc.li@gmail.com>

Your whole premise is broken. Being a cpu hog and the softlockup
mechanism aren't related at all.

Furthermore, since the normal scheduling policy is a proportional one, a
cpu hog can't in fact starve anybody (although a fork bomb could). And
FIFO/RR are privileged ops.

Furthermore the distinction between memory and cpu-time is that memory
isn't a renewable resource, whereas time is. There's always more time,
but there's not always more memory.

So no, I don't think either you patch nor your concept make any sense.
Consider it nacked. 
