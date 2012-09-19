Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab2ISMZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 08:25:44 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:33507 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050Ab2ISMZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 08:25:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: hongfeng <hongfeng@marvell.com>
Subject: Re: [PATCH] PM / Sleep: use resume event when call dpm_resume_early
Date: Wed, 19 Sep 2012 14:32:10 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: pavel@ucw.cz, len.brown@intel.com, gregkh@linuxfoundation.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Raul Xiong <xjian@marvell.com>, Neil Zhang <zhangwm@marvell.com>
References: <1348024674-13050-1-git-send-email-hongfeng@marvell.com>
In-Reply-To: <1348024674-13050-1-git-send-email-hongfeng@marvell.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201209191432.10406.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 19, 2012, hongfeng wrote:
> When dpm_suspend_noirq fail, state is PMSG_SUSPEND,
> should change to PMSG_RESUME when dpm_resume_early is called
> 
> Change-Id: If815218d4934b4648e330235ab1ae26e713284bd
> Signed-off-by: Feng Hong <hongfeng@marvell.com>
> Signed-off-by: Raul Xiong <xjian@marvell.com>
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>

Applied to the linux-next branch of the linux-pm.git tree as v3.7 material.

Thanks,
Rafael


> ---
>  drivers/base/power/main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index 0113adc..2700f2e 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -996,7 +996,7 @@ int dpm_suspend_end(pm_message_t state)
>  
>  	error = dpm_suspend_noirq(state);
>  	if (error) {
> -		dpm_resume_early(state);
> +		dpm_resume_early(resume_event(state));
>  		return error;
>  	}
>  
> 

