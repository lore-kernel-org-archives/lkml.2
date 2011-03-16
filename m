Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab1CPJmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 05:42:01 -0400
Received: from smtp-out.google.com ([74.125.121.67]:43024 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab1CPJl4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 05:41:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QBpc+U0/duEw75Civ2fKiniZMcFzC6DG3VYFILaZoqn9sGUOJ2WVHp4O4m6+adliyO
         alVIuPoSm6GCFRdK7WYw==
MIME-Version: 1.0
In-Reply-To: <1299697239.12209.1.camel@rklein-linux2>
References: <1298853672-21330-1-git-send-email-bleung@chromium.org>
	<1298857308-22790-2-git-send-email-bleung@chromium.org>
	<1299697239.12209.1.camel@rklein-linux2>
Date: Wed, 16 Mar 2011 02:41:52 -0700
X-Google-Sender-Auth: gCb8PYBhtTtdaxdf2ufbzBow53I
Message-ID: <AANLkTi=7_+hRgGFOyOuN2VKD8jQRaL5AKi=ih-x+3Ck7@mail.gmail.com>
Subject: Re: [PATCH] power: bq20z75: Fix time and temp units
From: Benson Leung <bleung@chromium.org>
To: Rhyland Klein <rklein@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

Rhyland has LGTM'd my change to the bq20z75 driver to fix temperature
and time units. Can it go upstream?

Thanks,
Benson

On Wed, Mar 9, 2011 at 11:00 AM, Rhyland Klein <rklein@nvidia.com> wrote:
>
> On Sun, 2011-02-27 at 17:41 -0800, Benson Leung wrote:
> > Corrected temperature and time to empty/full conversions.
> > Temperature is in 0.1°C, time is in seconds.
> >
> > Corrected units in comment. "Convert to µWh."
> >
> > Signed-off-by: Benson Leung <bleung@chromium.org>
> > ---
> >  drivers/power/bq20z75.c |   18 ++++++++++++------
> >  1 files changed, 12 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/power/bq20z75.c b/drivers/power/bq20z75.c
> > index 4141775..123e169 100644
> > --- a/drivers/power/bq20z75.c
> > +++ b/drivers/power/bq20z75.c
> > @@ -269,12 +269,15 @@ static void  bq20z75_unit_adjustment(struct i2c_client *client,
> >  {
> >  #define BASE_UNIT_CONVERSION         1000
> >  #define BATTERY_MODE_CAP_MULT_WATT   (10 * BASE_UNIT_CONVERSION)
> > -#define TIME_UNIT_CONVERSION         600
> > -#define TEMP_KELVIN_TO_CELCIUS               2731
> > +#define TIME_UNIT_CONVERSION         60
> > +#define TEMP_KELVIN_TO_CELSIUS               2731
> >       switch (psp) {
> >       case POWER_SUPPLY_PROP_ENERGY_NOW:
> >       case POWER_SUPPLY_PROP_ENERGY_FULL:
> >       case POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN:
> > +             /* bq20z75 provides energy in units of 10mWh.
> > +              * Convert to µWh
> > +              */
> >               val->intval *= BATTERY_MODE_CAP_MULT_WATT;
> >               break;
> >
> > @@ -288,14 +291,17 @@ static void  bq20z75_unit_adjustment(struct i2c_client *client,
> >               break;
> >
> >       case POWER_SUPPLY_PROP_TEMP:
> > -             /* bq20z75 provides battery tempreture in 0.1°K
> > -              * so convert it to 0.1°C */
> > -             val->intval -= TEMP_KELVIN_TO_CELCIUS;
> > -             val->intval *= 10;
> > +             /* bq20z75 provides battery temperature in 0.1K
> > +              * so convert it to 0.1°C
> > +              */
> > +             val->intval -= TEMP_KELVIN_TO_CELSIUS;
> >               break;
> >
> >       case POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG:
> >       case POWER_SUPPLY_PROP_TIME_TO_FULL_AVG:
> > +             /* bq20z75 provides time to empty and time to full in minutes.
> > +              * Convert to seconds
> > +              */
> >               val->intval *= TIME_UNIT_CONVERSION;
> >               break;
> >
>
> LGTM
>
> Acked-by: Rhyland Klein <rklein@nvidia.com>
>
>



--
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
