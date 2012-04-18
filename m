Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab2DRUlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 16:41:36 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47631 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab2DRUle convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 16:41:34 -0400
MIME-Version: 1.0
X-Originating-IP: [87.66.84.216]
In-Reply-To: <87k41dkks0.fsf@ti.com>
References: <1332173578-27422-1-git-send-email-j-pihet@ti.com>
	<1332173578-27422-6-git-send-email-j-pihet@ti.com>
	<87k41dkks0.fsf@ti.com>
Date: Wed, 18 Apr 2012 22:41:33 +0200
Message-ID: <CAORVsuXO5jxBZOEjTpJ4NTwOugmkK2JdsPE6yU_HbJ6iSALSGg@mail.gmail.com>
Subject: Re: [PATCH 5/9] ARM: OMAP3: hwmod: rename the smartreflex entries
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Kevin Hilman <khilman@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        Jean Pihet <j-pihet@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin,

On Wed, Apr 18, 2012 at 7:33 PM, Kevin Hilman <khilman@ti.com> wrote:
> +Benoit
>
> jean.pihet@newoldbits.com writes:
>
>> From: Jean Pihet <j-pihet@ti.com>
>>
>> Change the name field value to better reflect the smartreflex
>> integration in the system
>>
>> Signed-off-by: Jean Pihet <j-pihet@ti.com>
>> ---
>>  arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |    8 ++++----
>>  arch/arm/mach-omap2/smartreflex.c          |    2 +-
>>  2 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
>> index d7d4c70..40f57c4 100644
>> --- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
>> +++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
>> @@ -2751,7 +2751,7 @@ static struct omap_hwmod_ocp_if *omap34xx_sr1_slaves[] = {
>>  };
>>
>>  static struct omap_hwmod omap34xx_sr1_hwmod = {
>> -     .name           = "sr1",
>> +     .name           = "mpu_iva",
>
> Should this be "smartreflex_mpu_iva"?
>
> The OMAP4 SR hwmods have a 'smartreflex_' prefix which seems better.
>
>>       .class          = &omap34xx_smartreflex_hwmod_class,
>>       .main_clk       = "sr1_fck",
>>       .prcm           = {
>> @@ -2775,7 +2775,7 @@ static struct omap_hwmod_ocp_if *omap36xx_sr1_slaves[] = {
>>  };
>>
>>  static struct omap_hwmod omap36xx_sr1_hwmod = {
>> -     .name           = "sr1",
>> +     .name           = "mpu_iva",
>>       .class          = &omap36xx_smartreflex_hwmod_class,
>>       .main_clk       = "sr1_fck",
>>       .prcm           = {
>> @@ -2803,7 +2803,7 @@ static struct omap_hwmod_ocp_if *omap34xx_sr2_slaves[] = {
>>  };
>>
>>  static struct omap_hwmod omap34xx_sr2_hwmod = {
>> -     .name           = "sr2",
>> +     .name           = "core",
>>       .class          = &omap34xx_smartreflex_hwmod_class,
>>       .main_clk       = "sr2_fck",
>>       .prcm           = {
>> @@ -2827,7 +2827,7 @@ static struct omap_hwmod_ocp_if *omap36xx_sr2_slaves[] = {
>>  };
>>
>>  static struct omap_hwmod omap36xx_sr2_hwmod = {
>> -     .name           = "sr2",
>> +     .name           = "core",
>>       .class          = &omap36xx_smartreflex_hwmod_class,
>>       .main_clk       = "sr2_fck",
>>       .prcm           = {
>> diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
>> index c18d47d..b2728a5 100644
>> --- a/arch/arm/mach-omap2/smartreflex.c
>> +++ b/arch/arm/mach-omap2/smartreflex.c
>> @@ -184,7 +184,7 @@ static void sr_set_regfields(struct omap_sr *sr)
>>               sr->err_weight = OMAP3430_SR_ERRWEIGHT;
>>               sr->err_maxlimit = OMAP3430_SR_ERRMAXLIMIT;
>>               sr->accum_data = OMAP3430_SR_ACCUMDATA;
>> -             if (!(strcmp(sr->name, "sr1"))) {
>> +             if (!(strcmp(sr->name, "sr_mpu_iva"))) {
>
> Why the 'sr_' prefix?
Historically the sr instance name is generated from hwmod name
prepended with "sr_".
I agree it is better to change the hwmod name and remove the "sr_"
prefix from the sr init code.

>
>>                       sr->senn_avgweight = OMAP3430_SR1_SENNAVGWEIGHT;
>>                       sr->senp_avgweight = OMAP3430_SR1_SENPAVGWEIGHT;
>>               } else {
>
> Kevin

Thanks,
Jean
