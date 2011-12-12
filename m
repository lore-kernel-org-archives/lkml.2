Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab1LLA2i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 19:28:38 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38799 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab1LLA2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 19:28:36 -0500
Date: Mon, 12 Dec 2011 01:28:29 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vincent Li <vincent.mc.li@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Softlockup (out of cpu) killer
Message-ID: <20111212002826.GA23901@somewhere>
References: <1323643735-1999-1-git-send-email-vincent.mc.li@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323643735-1999-1-git-send-email-vincent.mc.li@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 11, 2011 at 02:48:55PM -0800, Vincent Li wrote:
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

That assumes a signal would be enough to pull a process out of its softlockup.
I believe this is seldom the case. A process in a softlockup is stuck in some
place that has preemption disabled. Unless it luckily polls there for pending
signals, that won't work.

But may be that happens more often than I think. May be other people have
more insight.
