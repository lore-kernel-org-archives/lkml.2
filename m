Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab2EDKLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 06:11:38 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:52228 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754043Ab2EDKLg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 06:11:36 -0400
MIME-Version: 1.0
In-Reply-To: <331ABD5ECB02734CA317220B2BBEABC13E9B1AA2@DBDE01.ent.ti.com>
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
	<1335462041-4949-5-git-send-email-j-keerthy@ti.com>
	<331ABD5ECB02734CA317220B2BBEABC13E9B1AA2@DBDE01.ent.ti.com>
Date: Fri, 4 May 2012 15:41:34 +0530
Message-ID: <CAJ6a13ZSWSa_RpGB9NxtfyChUba9NGivGogpsfyk7oT9pNayjg@mail.gmail.com>
Subject: Re: [PATCH V3 04/10] ARM: OMAP3: hwmod: rename the smartreflex entries
From: "J, KEERTHY" <j-keerthy@ti.com>
To: "AnilKumar, Chimata" <anilkumar@ti.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hilman, Kevin" <khilman@ti.com>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "Pihet-XID, Jean" <j-pihet@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi AnilKumar,

Thanks for reviewing.

On Fri, May 4, 2012 at 2:00 PM, AnilKumar, Chimata <anilkumar@ti.com> wrote:
> On Thu, Apr 26, 2012 at 23:10:35, J, KEERTHY wrote:
>> From: Jean Pihet <j-pihet@ti.com>
>>
>> Change the name field value to better reflect the smartreflex
>> integration in the system.
>>
>> Signed-off-by: Jean Pihet <j-pihet@ti.com>
>> Signed-off-by: J Keerthy <j-keerthy@ti.com>
>> ---
>>  arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |    8 ++++----
>>  arch/arm/mach-omap2/smartreflex.c          |    2 +-
>>  2 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
>> index 144d118..15907b0 100644
>> --- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
>> +++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
>> @@ -1324,7 +1324,7 @@ static struct omap_hwmod_irq_info omap3_smartreflex_mpu_irqs[] = {
>>  };
>>
>>  static struct omap_hwmod omap34xx_sr1_hwmod = {
>> -     .name           = "sr1",
>> +     .name           = "smartreflex_mpu_iva",
>>       .class          = &omap34xx_smartreflex_hwmod_class,
>>       .main_clk       = "sr1_fck",
>>       .prcm           = {
>> @@ -1342,7 +1342,7 @@ static struct omap_hwmod omap34xx_sr1_hwmod = {
>>  };
>>
>>  static struct omap_hwmod omap36xx_sr1_hwmod = {
>> -     .name           = "sr1",
>> +     .name           = "smartreflex_mpu_iva",
>>       .class          = &omap36xx_smartreflex_hwmod_class,
>>       .main_clk       = "sr1_fck",
>>       .prcm           = {
>> @@ -1369,7 +1369,7 @@ static struct omap_hwmod_irq_info omap3_smartreflex_core_irqs[] = {
>>  };
>>
>>  static struct omap_hwmod omap34xx_sr2_hwmod = {
>> -     .name           = "sr2",
>> +     .name           = "smartreflex_core",
>>       .class          = &omap34xx_smartreflex_hwmod_class,
>>       .main_clk       = "sr2_fck",
>>       .prcm           = {
>> @@ -1387,7 +1387,7 @@ static struct omap_hwmod omap34xx_sr2_hwmod = {
>>  };
>>
>>  static struct omap_hwmod omap36xx_sr2_hwmod = {
>> -     .name           = "sr2",
>> +     .name           = "smartreflex_core",
>>       .class          = &omap36xx_smartreflex_hwmod_class,
>>       .main_clk       = "sr2_fck",
>>       .prcm           = {
>> diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
>> index 2edd1e2..d859277 100644
>> --- a/arch/arm/mach-omap2/smartreflex.c
>> +++ b/arch/arm/mach-omap2/smartreflex.c
>> @@ -183,7 +183,7 @@ static void sr_set_regfields(struct omap_sr *sr)
>>               sr->err_weight = OMAP3430_SR_ERRWEIGHT;
>>               sr->err_maxlimit = OMAP3430_SR_ERRMAXLIMIT;
>>               sr->accum_data = OMAP3430_SR_ACCUMDATA;
>> -             if (!(strcmp(sr->name, "sr1"))) {
>> +             if (!(strcmp(sr->name, "smartreflex_mpu_iva"))) {
>
> What if voltage rail is different for mpu and iva? I have seen some devices
> supports SmartReflex have different voltage rails for mpu and iva.
>

I get the point. OMAP3 iva and mpu have a common rail. OMAP4 onwards
even we have different rails for mpu and iva. I will enhance the checks here.

> Regards
> AnilKumar



-- 
Regards and Thanks,
Keerthy
