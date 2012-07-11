Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab2GKEOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 00:14:16 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58803 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab2GKEOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 00:14:14 -0400
MIME-Version: 1.0
In-Reply-To: <201207021527.19888.arnd@arndb.de>
References: <1341239572-7408-1-git-send-email-vinholikatti@gmail.com>
	<1341239572-7408-3-git-send-email-vinholikatti@gmail.com>
	<201207021527.19888.arnd@arndb.de>
Date: Wed, 11 Jul 2012 09:44:13 +0530
Message-ID: <CAKVbJB98eQKsFHNxPtj4mryKzi-dnHCXN8XpzuVWrLRnm_gTCg@mail.gmail.com>
Subject: Re: [PATCH 2/4] [SCSI] ufs: Add Platform glue driver for ufshcd
From: vinayak holikatti <vinholikatti@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linux-samsung-soc@vger.kernel.org, santoshsy@gmail.com,
        arnd@linaro.org, girish.shivananjappa@linaro.org,
        saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org,
        k.rajesh@samsung.com, yejin.moon@samsung.com, dsaxena@linaro.org,
        ilho215.lee@samsung.com, nala.la@samsung.com, stephen.doel@linaro.org,
        sreekumar.c@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 2, 2012 at 8:57 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 02 July 2012, Vinayak Holikatti wrote:
>> +static struct platform_driver ufshcd_pltfrm_driver = {
>> +       .probe  = ufshcd_pltfrm_probe,
>> +       .remove = __devexit_p(ufshcd_pltfrm_remove),
>> +#ifdef CONFIG_PM
>> +       .suspend = ufshcd_pltfrm_suspend,
>> +       .resume = ufshcd_pltfrm_resume,
>> +#endif
>> +       .driver = {
>> +               .name   = "ufshcd",
>> +               .owner  = THIS_MODULE,
>> +       },
>> +};
>
> Hi Vinayak,
>
> Please add a device tree match table here to allow the driver to be
> used by modern platforms that only do device tree based hardware
> detection. Just look in other drivers for existing uses of
> "of_match_table" to be used.
>
> I'm not sure what the "compatible" string should be in this case,
> because the it matches a JEDEC specification, not a particular
> vendor's implementation of it. The match table can have multiple
> entries, which is useful if you have multiple implementations
> that are slightly different or don't fully conform to the spec.
>
> Maybe a list like
>
> static const struct of_device_id ufs_of_match[] = {
>         { .compatible = "jedec,ufs-1.1" },
> }
>
> would be enough for now.
Ok, will implement device tree match table.
>
>         Arnd
