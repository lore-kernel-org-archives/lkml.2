Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab2BBTdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:33:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34452 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab2BBTdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:33:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] PM/Freezer/Docs: Document the beauty of freeze/thaw semantics
Date: Thu, 2 Feb 2012 20:36:58 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: tj@kernel.org, pavel@ucw.cz, len.brown@intel.com, rdunlap@xenotime.net,
        linux-pm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20120202022829.13341.64259.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120202022829.13341.64259.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202022036.59167.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 02, 2012, Srivatsa S. Bhat wrote:
> The way the different freeze/thaw functions encapsulate each other are quite
> lovely from a design point of view. And as a side-effect, the way in which
> they are invoked (cleaning up on failure for example) differs significantly
> from how usual functions are dealt with. This is because of the underlying
> semantics that govern the freezing and thawing of various tasks.
> 
> This subtle aspect that differentiates these functions from the rest, is
> worth documenting.
> 
> Many thanks to Tejun Heo for providing enlightenment on this topic.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Applied.

Thanks,
Rafael


> ---
> 
>  Documentation/power/freezing-of-tasks.txt |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/power/freezing-of-tasks.txt b/Documentation/power/freezing-of-tasks.txt
> index ebd7490..ec715cd 100644
> --- a/Documentation/power/freezing-of-tasks.txt
> +++ b/Documentation/power/freezing-of-tasks.txt
> @@ -63,6 +63,27 @@ devices have been reinitialized, the function thaw_processes() is called in
>  order to clear the PF_FROZEN flag for each frozen task.  Then, the tasks that
>  have been frozen leave __refrigerator() and continue running.
>  
> +
> +Rationale behind the functions dealing with freezing and thawing of tasks:
> +-------------------------------------------------------------------------
> +
> +freeze_processes():
> +  - freezes only userspace tasks
> +
> +freeze_kernel_threads():
> +  - freezes all tasks (including kernel threads) because we can't freeze
> +    kernel threads without freezing userspace tasks
> +
> +thaw_kernel_threads():
> +  - thaws only kernel threads; this is particularly useful if we need to do
> +    anything special in between thawing of kernel threads and thawing of
> +    userspace tasks, or if we want to postpone the thawing of userspace tasks
> +
> +thaw_processes():
> +  - thaws all tasks (including kernel threads) because we can't thaw userspace
> +    tasks without thawing kernel threads
> +
> +
>  III. Which kernel threads are freezable?
>  
>  Kernel threads are not freezable by default.  However, a kernel thread may clear
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

