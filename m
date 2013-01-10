Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675Ab3AJBmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 20:42:21 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39872 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383Ab3AJBmT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 20:42:19 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "Jeong, Daniel" <Daniel.Jeong@ti.com>,
        "gshark.jeong@gmail.com" <gshark.jeong@gmail.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] leds-lm355x: support LED trigger functionality
Thread-Topic: [PATCH] leds-lm355x: support LED trigger functionality
Thread-Index: Ac3tamdBMmTZX6X9SjO98uZflN6jNQBIokoAABFjhGA=
Date: Thu, 10 Jan 2013 01:42:14 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E12243@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E11A6C@DQHE02.ent.ti.com>
 <CAK5ve-+mork5jCziq64zcHC09fATth9mRCoJFiRDsFSO=+B0JA@mail.gmail.com>
In-Reply-To: <CAK5ve-+mork5jCziq64zcHC09fATth9mRCoJFiRDsFSO=+B0JA@mail.gmail.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.78]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Bryan Wu [mailto:cooloney@gmail.com]
> Sent: Thursday, January 10, 2013 10:16 AM
> To: Kim, Milo
> Cc: Jeong, Daniel; gshark.jeong@gmail.com; linux-leds@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] leds-lm355x: support LED trigger functionality
> 
> On Mon, Jan 7, 2013 at 10:35 PM, Kim, Milo <Milo.Kim@ti.com> wrote:
> >  LM355x family devices provide flash, torch and indicator functions.
> >  This patch support LED trigger feature.
> >  Using LED trigger APIs(), other driver simply turn on/off the flash,
> torch
> >  and indicator.
> >
> >  Platform data
> >   the name of LED trigger is configurable.
> >
> >  Documentation
> >   example and detailed description added.
> >
> > Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> > ---
> >  Documentation/leds/leds-lm3556.txt        |   62
> +++++++++++++++++++++++++++++
> >  drivers/leds/leds-lm355x.c                |    3 ++
> >  include/linux/platform_data/leds-lm355x.h |    8 ++++
> >  3 files changed, 73 insertions(+)
> >
> > diff --git a/Documentation/leds/leds-lm3556.txt
> b/Documentation/leds/leds-lm3556.txt
> > index d9eb91b..73244cd 100644
> > --- a/Documentation/leds/leds-lm3556.txt
> > +++ b/Documentation/leds/leds-lm3556.txt
> > @@ -83,3 +83,65 @@ and register it in the platform init function
> >  Example:
> >         board_register_i2c_bus(4, 400,
> >                                 board_i2c_ch4,
> ARRAY_SIZE(board_i2c_ch4));
> > +
> > +Support LED Triggers
> > +--------------------
> > +Flash, torch and indicator can be controlled not only by an user-
> space but also
> > +by other drivers, kernel space.
> > +For example, flash turns on by camera driver internally.
> > +To support this functionality, LED trigger is registered.
> > +The name of LED trigger is configurable in the platform data.
> > +
> > +Example: LED trigger name for flash
> > +#include <linux/platform_data/leds-lm355x.h>
> > +
> > +struct lm355x_trigger_name lm3556_trigger_name = {
> > +       .flash = "flash",
> > +};
> > +
> > +struct lm355x_platform_data lm3556_pdata = {
> > +       ...
> > +       .trigger = &lm3556_trigger_name,
> > +};
> > +
> > +Example: Flash control in simple camera driver
> 
> Hi Milo,
> 
> Can we share this camera flash trigger with other users? just
> introduce a new trigger in drivers/leds/ledtrig-flash.c,
> drivers/leds/ledtrig-torch.c, drivers/leds/ledtrig-indicator.c. So it
> can shared by plenty of users.
> 
> And this trigger can be independent with LM355x and use other LED
> hardware driver underneath.
> 
> So I expect such trigger driver instead of a specific trigger in LED
> hardware driver and in other subsystem.

Good idea, Bryan. Thanks!
Then added name field of lm355x platform data can be gone and driver is
replaced with fixed name field.
And how about gathering ledtrig-* drivers in new subdirectory under drivers/leds
?(eg. drivers/leds/trigger/)

Best Regards,
Milo

