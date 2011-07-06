Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab1GFNQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 09:16:26 -0400
Received: from smarthost3.mail.uk.easynet.net ([212.135.6.13]:55986 "EHLO
	smarthost3.mail.uk.easynet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752119Ab1GFNQY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 09:16:24 -0400
Thread-Index: Acw73xBE9p0qoUW/RgmlPvb7DgQj5w==
References: <345355.5665.qm@web29002.mail.ird.yahoo.com> <4D9136CA-90AC-4DBB-9AD1-44062FFCF9D4@sonatest.com> <20110705144606.3cc66260.akpm@linux-foundation.org>
In-Reply-To: <20110705144606.3cc66260.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Message-ID: <2ED69AE8-CFA8-41DB-B0DB-43EB12F02EA3@sonatest.com>
Content-Transfer-Encoding: 8BIT
Cc: <linux-kernel@vger.kernel.org>
From: =?iso-8859-1?Q?Jean-Fran=E7ois_Dagenais?= <dagenaisj@sonatest.com>
Subject: Re: [PATCH] w1: ds1wm: add a reset recovery parameter
Content-class: urn:content-classes:message
Date: Wed, 6 Jul 2011 09:16:57 -0400
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4841
Importance: normal
To: "Andrew Morton" <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1084)
X-OriginalArrivalTime: 06 Jul 2011 13:17:31.0933 (UTC) FILETIME=[1003C4D0:01CC3BDF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 5, 2011, at 17:46, Andrew Morton wrote:

> On Mon, 27 Jun 2011 09:17:58 -0400
> Jean-Fran__ois Dagenais <dagenaisj@sonatest.com> wrote:
> 
>> This follows the regression on 3.0 reported by Paul Parsons regarding
>> the removal of the msleep(1) in the ds1wm_reset() function. This
>> sleep should not be required on normal circuitry provided the
>> pull-ups on the bus are correctly adapted to the slaves.
>> Unfortunately, this is not always the case. The sleep is restored
>> but as a parameter to the probe function in the pdata.
> 
> A few things.
> 
> - When fixing a bug, please fully describe that bug in the changelog.
>  So that others can determine whether your patch might fix a bug
>  which they are observing.
> 
>  That's not so important when we're fixing a regression which was
>  introduced since the most recent major kernel release, but it's good
>  practice and who knows, someone might have backported the
>  regression-introducing patch.
> 
> - The patch was missing your signed-off-by.  I added it.  Please
>  ack this.
> 
> - It's conventional to give bug-reporters a hat tip via the
>  Reported-by: tag.
> 
All noted. Thanks for the constructive feedback. ds1wm mods are my first contrib to the kernel.
> Here's what I merged:
> 
> 
> From: Jean-Fran_ois Dagenais <dagenaisj@sonatest.com>
If the c-cedilla doesn't work please replace the '_' by a regular 'c'... actually I will re-submit the patch as v2.
> 
> This fixes a regression on 3.0 reported by Paul Parsons regarding the
> removal of the msleep(1) in the ds1wm_reset() function:
> 
> : The linux-3.0-rc4 DS1WM 1-wire driver is logging "bus error, retrying"
> : error messages on an HP iPAQ hx4700 PDA (XScale-PXA270):
> : 
> : <snip>
> : Driver for 1-wire Dallas network protocol.
> : DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
> : 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
> : ds1wm ds1wm: pass: 1 bus error, retrying
> : ds1wm ds1wm: pass: 2 bus error, retrying
> : ds1wm ds1wm: pass: 3 bus error, retrying
> : ds1wm ds1wm: pass: 4 bus error, retrying
> : ds1wm ds1wm: pass: 5 bus error, retrying
> : ...
> : 
> : The visible result is that the battery charging LED is erratic; sometimes
> : it works, mostly it doesn't.
> : 
> : The linux-2.6.39 DS1WM 1-wire driver worked OK.  I haven't tried 3.0-rc1,
> : 3.0-rc2, or 3.0-rc3.
> 
> This sleep should not be required on normal circuitry provided the
> pull-ups on the bus are correctly adapted to the slaves.  Unfortunately,
> this is not always the case.  The sleep is restored but as a parameter to
> the probe function in the pdata.
> 
> Reported-by: Paul Parsons <lost.distance@yahoo.com>
> Tested-by: Paul Parsons <lost.distance@yahoo.com>
> Signed-off-by: Jean-Fran_ois Dagenais <dagenaisj@sonatest.com>
again, the '_' 
> Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
> drivers/mfd/asic3.c        |    1 +
> drivers/mfd/htc-pasic3.c   |    1 +
> drivers/w1/masters/ds1wm.c |    5 +++++
> include/linux/mfd/ds1wm.h  |    7 +++++++
> 4 files changed, 14 insertions(+)
> 
> diff -puN drivers/mfd/asic3.c~w1-ds1wm-add-a-reset-recovery-parameter drivers/mfd/asic3.c
> --- a/drivers/mfd/asic3.c~w1-ds1wm-add-a-reset-recovery-parameter
> +++ a/drivers/mfd/asic3.c
> @@ -619,6 +619,7 @@ static void asic3_clk_disable(struct asi
> /* MFD cells (SPI, PWM, LED, DS1WM, MMC) */
> static struct ds1wm_driver_data ds1wm_pdata = {
> 	.active_high = 1,
> +	.reset_recover_delay = 1,
> };
> 
> static struct resource ds1wm_resources[] = {
> diff -puN drivers/mfd/htc-pasic3.c~w1-ds1wm-add-a-reset-recovery-parameter drivers/mfd/htc-pasic3.c
> --- a/drivers/mfd/htc-pasic3.c~w1-ds1wm-add-a-reset-recovery-parameter
> +++ a/drivers/mfd/htc-pasic3.c
> @@ -99,6 +99,7 @@ static int ds1wm_disable(struct platform
> 
> static struct ds1wm_driver_data ds1wm_pdata = {
> 	.active_high = 0,
> +	.reset_recover_delay = 1,
> };
> 
> static struct resource ds1wm_resources[] __initdata = {
> diff -puN drivers/w1/masters/ds1wm.c~w1-ds1wm-add-a-reset-recovery-parameter drivers/w1/masters/ds1wm.c
> --- a/drivers/w1/masters/ds1wm.c~w1-ds1wm-add-a-reset-recovery-parameter
> +++ a/drivers/w1/masters/ds1wm.c
> @@ -109,6 +109,7 @@ struct ds1wm_data {
> 	/* byte to write that makes all intr disabled, */
> 	/* considering active_state (IAS) (optimization) */
> 	u8       int_en_reg_none;
> +	unsigned int reset_recover_delay; /* see ds1wm.h */
> };
> 
> static inline void ds1wm_write_register(struct ds1wm_data *ds1wm_data, u32 reg,
> @@ -187,6 +188,9 @@ static int ds1wm_reset(struct ds1wm_data
> 		return 1;
> 	}
> 
> +	if(ds1wm_data->reset_recover_delay)
> +		msleep(ds1wm_data->reset_recover_delay);
> +
> 	return 0;
> }
> 
> @@ -490,6 +494,7 @@ static int ds1wm_probe(struct platform_d
> 	}
> 	ds1wm_data->irq = res->start;
> 	ds1wm_data->int_en_reg_none = (plat->active_high ? DS1WM_INTEN_IAS : 0);
> +	ds1wm_data->reset_recover_delay = plat->reset_recover_delay;
> 
> 	if (res->flags & IORESOURCE_IRQ_HIGHEDGE)
> 		irq_set_irq_type(ds1wm_data->irq, IRQ_TYPE_EDGE_RISING);
> diff -puN include/linux/mfd/ds1wm.h~w1-ds1wm-add-a-reset-recovery-parameter include/linux/mfd/ds1wm.h
> --- a/include/linux/mfd/ds1wm.h~w1-ds1wm-add-a-reset-recovery-parameter
> +++ a/include/linux/mfd/ds1wm.h
> @@ -3,4 +3,11 @@
> struct ds1wm_driver_data {
> 	int active_high;
> 	int clock_rate;
> +	/* in milliseconds, the amount of time to */
> +	/* sleep following a reset pulse. Zero    */
> +	/* should work if your bus devices recover*/
> +	/* time respects the 1-wire spec since the*/
> +	/* ds1wm implements the precise timings of*/
> +	/* a reset pulse/presence detect sequence.*/ 
> +	unsigned int reset_recover_delay;
> };
> _
> 
>

Jean-Francois Dagenais 
Software Architect - B.Sc.A


Experience the new veo phased array flaw detector at www.sonatestveo.com.


Sonatest AP
2900 chemin des Quatre-Bourgeois
Bureau 305
Quebec City Quebec G1V 1Y4

T| +1 (418) 683 6222 x106   F| +1 (418) 683 7032   M|    W| www.sonatest.com



This message (and any associated files) is intended only for the use of akpm@linux-foundation.org, linux-kernel@vger.kernel.org and may contain information that is confidential, subject to copyright or constitutes a trade secret. If you are not the above recipient(s) you are hereby notified that any dissemination, copying or distribution of this message, or files associated with this message, is strictly prohibited. If you have received this message in error, please notify us immediately by replying to the message and deleting it from your computer. Any views or opinions presented are solely those of the author and do not necessarily represent those of the company.

Think green - help the environment by not printing this email.
