Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab3AGVwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 16:52:22 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34368 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab3AGVwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 16:52:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] cpuidle: fix number of initialized/destroyed states
Date: Mon, 07 Jan 2013 22:58:03 +0100
Message-ID: <339419841.p0RXgOP6cW@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc2+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1357585921-3391-1-git-send-email-krzysiek@podlesie.net>
References: <1357585921-3391-1-git-send-email-krzysiek@podlesie.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the patch!

I'd like Daniel to have a look at it still.

Thanks,
Rafael


On Monday, January 07, 2013 08:12:01 PM Krzysztof Mazur wrote:
> Commit bf4d1b5ddb78f86078ac6ae0415802d5f0c68f92 (cpuidle: support
> multiple drivers) changed the number of initialized state kobjects
> in cpuidle_add_state_sysfs() from device->state_count to drv->state_count,
> but leaved device->state_count in cpuidle_remove_state_sysfs().
> Those two values might have different values, causing for instance
> NULL pointer dereference in cpuidle_remove_state_sysfs().
> 
> Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
> ---
> Hi,
> 
> commit bf4d1b5ddb78f86078ac6ae0415802d5f0c68f92
> (cpuidle: support multiple drivers, merged in v3.8-rc1) causes NULL pointer
> dereference in cpuidle_remove_state_sysfs() when I plug the AC line to my
> laptop. I'm using the acpi_idle cpuidle driver and the C4 state is
> available only on when the system runs from battery. The problem still
> exists in v3.8-rc2 and f243b9b46a22e5790dbbc36f574c2417af49a41.
> 
> I noticed that the commit bf4d1b5ddb78f86078ac6ae0415802d5f0c68f92
> (merged in v3.8-rc1) changed device->state_count to drv->state_count
> in only one of two places, which seems to be incorrect. This patch restores
> device->state_count in both places. It fixes the problem on my system.
> 
> Krzysiek
> 
>  drivers/cpuidle/sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
> index 3409429..428754a 100644
> --- a/drivers/cpuidle/sysfs.c
> +++ b/drivers/cpuidle/sysfs.c
> @@ -374,7 +374,7 @@ static int cpuidle_add_state_sysfs(struct cpuidle_device *device)
>  	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(device);
>  
>  	/* state statistics */
> -	for (i = 0; i < drv->state_count; i++) {
> +	for (i = 0; i < device->state_count; i++) {
>  		kobj = kzalloc(sizeof(struct cpuidle_state_kobj), GFP_KERNEL);
>  		if (!kobj)
>  			goto error_state;
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
