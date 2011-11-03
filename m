Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab1KCAQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 20:16:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47151 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004Ab1KCAQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 20:16:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] Freezer / Documentation: Update freezer documentation
Date: Thu, 3 Nov 2011 01:19:28 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: pavel@ucw.cz, len.brown@intel.com, rdunlap@xenotime.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
References: <20111029173418.4559.3699.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20111029173418.4559.3699.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111030119.28921.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 29, 2011, Srivatsa S. Bhat wrote:
> This patch:
>  * substitutes some obsolete references to kernel/power/process.c by
>    kernel/freezer.c
>  * mentions kernel/freezer.c as being part of the "freezer" code along
>    with the rest of the files
>  * fixes a trivial typo.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Applied to linux-pm/linux-next.

Thanks,
Rafael


> ---
> 
>  Documentation/power/freezing-of-tasks.txt |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/power/freezing-of-tasks.txt b/Documentation/power/freezing-of-tasks.txt
> index 38b5724..316c2ba 100644
> --- a/Documentation/power/freezing-of-tasks.txt
> +++ b/Documentation/power/freezing-of-tasks.txt
> @@ -22,12 +22,12 @@ try_to_freeze_tasks() that sets TIF_FREEZE for all of the freezable tasks and
>  either wakes them up, if they are kernel threads, or sends fake signals to them,
>  if they are user space processes.  A task that has TIF_FREEZE set, should react
>  to it by calling the function called refrigerator() (defined in
> -kernel/power/process.c), which sets the task's PF_FROZEN flag, changes its state
> +kernel/freezer.c), which sets the task's PF_FROZEN flag, changes its state
>  to TASK_UNINTERRUPTIBLE and makes it loop until PF_FROZEN is cleared for it.
>  Then, we say that the task is 'frozen' and therefore the set of functions
>  handling this mechanism is referred to as 'the freezer' (these functions are
> -defined in kernel/power/process.c and include/linux/freezer.h).  User space
> -processes are generally frozen before kernel threads.
> +defined in kernel/power/process.c, kernel/freezer.c & include/linux/freezer.h).
> +User space processes are generally frozen before kernel threads.
>  
>  It is not recommended to call refrigerator() directly.  Instead, it is
>  recommended to use the try_to_freeze() function (defined in
> @@ -95,7 +95,7 @@ after the memory for the image has been freed, we don't want tasks to allocate
>  additional memory and we prevent them from doing that by freezing them earlier.
>  [Of course, this also means that device drivers should not allocate substantial
>  amounts of memory from their .suspend() callbacks before hibernation, but this
> -is e separate issue.]
> +is a separate issue.]
>  
>  3. The third reason is to prevent user space processes and some kernel threads
>  from interfering with the suspending and resuming of devices.  A user space
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

