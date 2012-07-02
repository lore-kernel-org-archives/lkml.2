Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab2GBP1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 11:27:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64786 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2GBP1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 11:27:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vinayak Holikatti <vinholikatti@gmail.com>
Subject: Re: [PATCH 2/4] [SCSI] ufs: Add Platform glue driver for ufshcd
Date: Mon, 2 Jul 2012 15:27:19 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linux-samsung-soc@vger.kernel.org, santoshsy@gmail.com,
        arnd@linaro.org, girish.shivananjappa@linaro.org,
        saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org,
        k.rajesh@samsung.com, yejin.moon@samsung.com, dsaxena@linaro.org,
        ilho215.lee@samsung.com, nala.la@samsung.com, stephen.doel@linaro.org,
        sreekumar.c@samsung.com
References: <1341239572-7408-1-git-send-email-vinholikatti@gmail.com> <1341239572-7408-3-git-send-email-vinholikatti@gmail.com>
In-Reply-To: <1341239572-7408-3-git-send-email-vinholikatti@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207021527.19888.arnd@arndb.de>
X-Provags-ID: V02:K0:xkI4uct/G1vyPfp/OJ6HgzB/F5qQ6Fk8JNLDaBvWhlr
 2bRlC3MZQJQeJZB8tRi5dwn6tJiI9OCatiQjf9p6mfjhRNxPoA
 U88Wl1XjPP7ymNIi2tlg225Scke1m7sm73yR8o3QLoWO4Dm5y/
 L3N1n5HL1Rkxagv0EZ0px+llzY57AAeXeyYmqAKaPgoHjKe2bz
 mxIZw55nND2nLkp9wy6+Gu+G7vKpDLpAp5iIyAzGxMP598K9u6
 AOff4R8YGZULleYpVKW+hlzvEzJGQH+m2lcIWlIF0rCYSyMHA2
 T4x3Zaf9NbPLiUPnhDudlyZigr3EDYfIlBmkJKJdpF75dZYgHD
 2XGVB7G3s6z4DFhEx2m8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 July 2012, Vinayak Holikatti wrote:
> +static struct platform_driver ufshcd_pltfrm_driver = {
> +       .probe  = ufshcd_pltfrm_probe,
> +       .remove = __devexit_p(ufshcd_pltfrm_remove),
> +#ifdef CONFIG_PM
> +       .suspend = ufshcd_pltfrm_suspend,
> +       .resume = ufshcd_pltfrm_resume,
> +#endif
> +       .driver = {
> +               .name   = "ufshcd",
> +               .owner  = THIS_MODULE,
> +       },
> +};

Hi Vinayak,

Please add a device tree match table here to allow the driver to be
used by modern platforms that only do device tree based hardware
detection. Just look in other drivers for existing uses of
"of_match_table" to be used.

I'm not sure what the "compatible" string should be in this case,
because the it matches a JEDEC specification, not a particular
vendor's implementation of it. The match table can have multiple
entries, which is useful if you have multiple implementations
that are slightly different or don't fully conform to the spec.

Maybe a list like

static const struct of_device_id ufs_of_match[] = {
	{ .compatible = "jedec,ufs-1.1" },
}

would be enough for now.

	Arnd
