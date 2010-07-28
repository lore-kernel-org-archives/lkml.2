Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab0G1PFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 11:05:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36718 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882Ab0G1PFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 11:05:04 -0400
Message-ID: <4C504719.3020007@ti.com>
Date: Wed, 28 Jul 2010 10:04:57 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: "Ramos Falcon, Ernesto" <ernesto@ti.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "Ramirez Luna, Omar" <omar.ramirez@ti.com>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>,
        "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/5] staging:ti dspbridge: remove unnecessary check for
 NULL pointer in cmm.c
References: <1280328052-31292-1-git-send-email-ernesto@ti.com> <1280328052-31292-2-git-send-email-ernesto@ti.com> <1280328052-31292-3-git-send-email-ernesto@ti.com>
In-Reply-To: <1280328052-31292-3-git-send-email-ernesto@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramos Falcon, Ernesto had written, on 07/28/2010 09:40 AM, the following:
> Remove unnecessary check for NULL pointer in cmm.c.
> 
> Signed-off-by: Ernesto Ramos <ernesto@ti.com>
> ---
>  drivers/staging/tidspbridge/pmgr/cmm.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/tidspbridge/pmgr/cmm.c b/drivers/staging/tidspbridge/pmgr/cmm.c
> index 8e808d9..874ed64 100644
> --- a/drivers/staging/tidspbridge/pmgr/cmm.c
> +++ b/drivers/staging/tidspbridge/pmgr/cmm.c
> @@ -992,16 +992,12 @@ int cmm_xlator_create(struct cmm_xlatorobject **xlator,
>  int cmm_xlator_delete(struct cmm_xlatorobject *xlator, bool force)
>  {
>  	struct cmm_xlator *xlator_obj = (struct cmm_xlator *)xlator;
> -	int status = 0;
>  
>  	DBC_REQUIRE(refs > 0);
>  
> -	if (xlator_obj)
> -		kfree(xlator_obj);
> -	else
> -		status = -EFAULT;
> +	kfree(xlator_obj);
>  
> -	return status;
> +	return 0;
>  }
>  
>  /*
which kind of begs the question - does this function need to any longer 
return int?

-- 
Regards,
Nishanth Menon
