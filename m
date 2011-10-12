Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab1JLVd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 17:33:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36767 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205Ab1JLVd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 17:33:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ming.lei@canonical.com
Subject: Re: [PATCH 1/2] PM/runtime: fix comment for rpm_suspend
Date: Wed, 12 Oct 2011 23:36:15 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1318391613-24364-1-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1318391613-24364-1-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201110122336.15459.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 12, 2011, ming.lei@canonical.com wrote:
> From: Ming Lei <ming.lei@canonical.com>
> 
> This patch fix comments for rpm_suspend:
> 
> - 'Cancel a pending idle notification' should be put before, also
> should be changed as 'Cancel a pending idle notification,
> autosuspend or suspend'
> 
> - after suspend succeeded, idle notification for the device has
> been removed, so update comment for it
> 
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

Both patches applied to linux-pm/linux-next.

Thanks,
Rafael


> ---
>  drivers/base/power/runtime.c |   18 ++++++++++--------
>  1 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
> index 7a6fb5e..aa23a64 100644
> --- a/drivers/base/power/runtime.c
> +++ b/drivers/base/power/runtime.c
> @@ -286,14 +286,16 @@ static int rpm_callback(int (*cb)(struct device *), struct device *dev)
>   * @dev: Device to suspend.
>   * @rpmflags: Flag bits.
>   *
> - * Check if the device's runtime PM status allows it to be suspended.  If
> - * another suspend has been started earlier, either return immediately or wait
> - * for it to finish, depending on the RPM_NOWAIT and RPM_ASYNC flags.  Cancel a
> - * pending idle notification.  If the RPM_ASYNC flag is set then queue a
> - * suspend request; otherwise run the ->runtime_suspend() callback directly.
> - * If a deferred resume was requested while the callback was running then carry
> - * it out; otherwise send an idle notification for the device (if the suspend
> - * failed) or for its parent (if the suspend succeeded).
> + * Check if the device's runtime PM status allows it to be suspended.
> + * Cancel a pending idle notification, autosuspend or suspend. If
> + * another suspend has been started earlier, either return immediately
> + * or wait for it to finish, depending on the RPM_NOWAIT and RPM_ASYNC
> + * flags. If the RPM_ASYNC flag is set then queue a suspend request;
> + * otherwise run the ->runtime_suspend() callback directly. If a deferred
> + * resume was requested while the callback was running then carry it out;
> + * otherwise send an idle notification for its parent (if the suspend
> + * succeeded and both ignore_children of parent->power and irq_safe of
> + * dev->power are not set).
>   *
>   * This function must be called under dev->power.lock with interrupts disabled.
>   */
> 

