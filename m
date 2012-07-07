Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab2GGUtf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 16:49:35 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:57611 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab2GGUtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 16:49:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] MFD: twl-core: move device_init_wakeup to after platform_device_add.
Date: Sat, 7 Jul 2012 22:55:03 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-pm@vger.kernel.org
References: <20120707085103.7b1a51ec@notabene.brown>
In-Reply-To: <20120707085103.7b1a51ec@notabene.brown>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201207072255.03300.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 07, 2012, NeilBrown wrote:
> 
> device_init_wakeup uses the dev_name() of the device to set the
> name of the wakeup_source which appears in
> /sys/kernel/debug/wakeup_sources.
> 
> For a platform device, that name is not set until platform_device_add
> calls dev_set_name.
> 
> So the call to device_init_wakeup() must be after the call to
> platform_device_add().
> Making this change causes correct names to appear in the
> wakeup_sources file.
> 
> 
> Signed-off-by: NeilBrown <neilb@suse.de>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> 
> diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
> index 6fc90be..b012efd 100644
> --- a/drivers/mfd/twl-core.c
> +++ b/drivers/mfd/twl-core.c
> @@ -568,7 +568,6 @@ add_numbered_child(unsigned chip, const char *name, int num,
>  		goto err;
>  	}
>  
> -	device_init_wakeup(&pdev->dev, can_wakeup);
>  	pdev->dev.parent = &twl->client->dev;
>  
>  	if (pdata) {
> @@ -593,6 +592,8 @@ add_numbered_child(unsigned chip, const char *name, int num,
>  	}
>  
>  	status = platform_device_add(pdev);
> +	if (status == 0)
> +		device_init_wakeup(&pdev->dev, can_wakeup);
>  
>  err:
>  	if (status < 0) {
> 

