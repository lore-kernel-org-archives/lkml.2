Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188Ab1CDUm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 15:42:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52816 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760065Ab1CDUm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 15:42:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [PATCH] power: disable hibernation if module loading is disabled
Date: Fri, 4 Mar 2011 21:42:09 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc7+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        linux-pm@lists.linux-foundation.org
References: <1299255084-4390-1-git-send-email-segoon@openwall.com>
In-Reply-To: <1299255084-4390-1-git-send-email-segoon@openwall.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201103042142.09247.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 04, 2011, Vasiliy Kulikov wrote:
> If /proc/sys/kernel/modules_disabled is set to 1, then nobody (even full
> root) may not read/write arbitrary kernel memory.  In spite of it,
> hibernation allows anyone with an access to either /dev/snapshot or
> /sys/power/ make the full snapshot of the system.  This snapshot may be
> freely changed and uploaded back.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

That "everyone" is actually the "full root" (in the case of /sys/power/state)
or someone having CAP_SYS_ADMIN in the /dev/snapshot case, right?

So the changelog is misleading and please fix it.

Second, there's _zero_ relationship between /proc/sys/kernel/modules_disabled
and the hibernation interface, so please find a different way to solve the
problem (if there is any).

Thanks,
Rafael


> ---
>  kernel/power/hibernate.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index 1832bd2..1ac9eee 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -328,6 +328,9 @@ int hibernation_snapshot(int platform_mode)
>  {
>  	int error;
>  
> +	if (modules_disabled)
> +		return -EPERM;
> +
>  	error = platform_begin(platform_mode);
>  	if (error)
>  		goto Close;
> @@ -385,6 +388,9 @@ static int resume_target_kernel(bool platform_mode)
>  {
>  	int error;
>  
> +	if (modules_disabled)
> +		return -EPERM;
> +
>  	error = dpm_suspend_noirq(PMSG_QUIESCE);
>  	if (error) {
>  		printk(KERN_ERR "PM: Some devices failed to power down, "
> 

