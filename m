Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab1LEE1P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 23:27:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50752 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab1LEE1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 23:27:14 -0500
MIME-Version: 1.0
In-Reply-To: <CAKnK67T9S6Z=f9qmn9ov7YNyTKjdDbOZHJDRO-7_fqkJGZzXbA@mail.gmail.com>
References: <1322838172-11149-1-git-send-email-ming.lei@canonical.com>
	<1322838172-11149-3-git-send-email-ming.lei@canonical.com>
	<CAKnK67T9S6Z=f9qmn9ov7YNyTKjdDbOZHJDRO-7_fqkJGZzXbA@mail.gmail.com>
Date: Mon, 5 Dec 2011 12:27:11 +0800
Message-ID: <CACVXFVNxX9tHZrdsRw6Wm14g59x44dR1Rm5jLeqxx4m6Jxe5-Q@mail.gmail.com>
Subject: Re: [RFC PATCH v1 2/7] omap4: build fdif omap device from hwmod
From: Ming Lei <ming.lei@canonical.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Sylwester Nawrocki <snjw23@gmail.com>, Greg KH <greg@kroah.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Dec 3, 2011 at 12:28 AM, Aguirre, Sergio <saaguirre@ti.com> wrote:
> Hi Ming,
>
> Thanks for the patches.

Thanks for your review.

> On Fri, Dec 2, 2011 at 9:02 AM, Ming Lei <ming.lei@canonical.com> wrote:
>> Signed-off-by: Ming Lei <ming.lei@canonical.com>
>> ---
>>  arch/arm/mach-omap2/devices.c |   33 +++++++++++++++++++++++++++++++++
>>  1 files changed, 33 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
>> index 1166bdc..a392af5 100644
>> --- a/arch/arm/mach-omap2/devices.c
>> +++ b/arch/arm/mach-omap2/devices.c
>> @@ -728,6 +728,38 @@ void __init omap242x_init_mmc(struct omap_mmc_platform_data **mmc_data)
>>
>>  #endif
>>
>> +static struct platform_device* __init omap4_init_fdif(void)
>> +{
>> +       int id = -1;
>
> You could remove this , as it is being used only once, and never changed.

Yes.

>
>> +       struct platform_device *pd;
>> +       struct omap_hwmod *oh;
>> +       const char *dev_name = "fdif";
>> +
>> +       oh = omap_hwmod_lookup("fdif");
>> +       if (!oh) {
>> +               pr_err("Could not look up fdif hwmod\n");
>> +               return NULL;
>> +       }
>> +
>> +       pd = omap_device_build(dev_name, id, oh, NULL, 0, NULL, 0, 0);
>
> Just do:
>
> pd = omap_device_build(dev_name, -1, oh, NULL, 0, NULL, 0, 0);
>
>> +       WARN(IS_ERR(pd), "Can't build omap_device for %s.\n",
>> +                               dev_name);
>> +       return pd;
>> +}
>> +
>> +static void __init omap_init_fdif(void)
>> +{
>> +       if (cpu_is_omap44xx()) {
>> +               struct platform_device *pd;
>> +
>> +               pd = omap4_init_fdif();
>> +               if (!pd)
>> +                       return;
>> +
>> +               pm_runtime_enable(&pd->dev);
>> +       }
>> +}
>
> IMHO, you could reduce 1 level of indentation here, like this:
>
> static void __init omap_init_fdif(void)
> {
>        struct platform_device *pd;
>
>        if (!cpu_is_omap44xx())
>                return;
>
>        pd = omap4_init_fdif();
>        if (!pd)
>                return;
>
>        pm_runtime_enable(&pd->dev);
> }

OK, will take this.

thanks,
--
Ming Lei
