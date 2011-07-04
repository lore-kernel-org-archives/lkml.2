Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab1GDQBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 12:01:00 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62564 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700Ab1GDQA5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 12:00:57 -0400
MIME-Version: 1.0
In-Reply-To: <19985.57715.78894.466149@ipc1.ka-ro>
References: <1309522131-2237-1-git-send-email-LW@KARO-electronics.de>
 <1309522131-2237-2-git-send-email-LW@KARO-electronics.de> <20110704064844.GM15152@ponder.secretlab.ca>
 <19985.35317.629981.97373@ipc1.ka-ro> <20110704153944.GD29977@ponder.secretlab.ca>
 <19985.57715.78894.466149@ipc1.ka-ro>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 4 Jul 2011 10:00:37 -0600
X-Google-Sender-Auth: uN_UShGHl3I9TM_iiZ5ZjeHIrc8
Message-ID: <CACxGe6v87WboQwZn9L0QtND2=B6g6ScQcPgTPnU_2whn=-B9HA@mail.gmail.com>
Subject: Re: [PATCH] add missing intialisation of bgc->dir
To: =?ISO-8859-1?Q?Lothar_Wa=DFmann?= <LW@karo-electronics.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 4, 2011 at 9:51 AM, Lothar Waﬂmann <LW@karo-electronics.de> wrote:
> Hi,
>
> Grant Likely writes:
>> On Mon, Jul 04, 2011 at 11:37:57AM +0200, Lothar Waﬂmann wrote:
>> > Hi,
>> >
>> > Grant Likely writes:
>> > > On Fri, Jul 01, 2011 at 02:08:51PM +0200, Lothar Waﬂmann wrote:
>> > > > ---
>> > > > †drivers/gpio/basic_mmio_gpio.c | † †1 +
>> > > > †1 files changed, 1 insertions(+), 0 deletions(-)
>> > > >
>> > > > diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
>> > > > index 8152e9f..e69a453 100644
>> > > > --- a/drivers/gpio/basic_mmio_gpio.c
>> > > > +++ b/drivers/gpio/basic_mmio_gpio.c
>> > > > @@ -399,6 +399,7 @@ int __devinit bgpio_init(struct bgpio_chip *bgc,
>> > > > † † † † † † † † return ret;
>> > > >
>> > > > † † † † bgc->data = bgc->read_reg(bgc->reg_dat);
>> > > > + † † † bgc->dir = bgc->read_reg(bgc->reg_dir);
>> > >
>> > > Hi Lothar.
>> > >
>> > > You'll need to double check your email setup. †The patch got emailed
>> > > separately from the description.
>> > >
>> > git-send-email did that.
>>
>> It appears that you asked it to send a cover letter, which you usually
>> don't want when sending a single patch. †The patch description should
>> be part of the git commit itself.
>>
> Yes, I noticed that already.
>
>> > > I don't know if this is a valid thing to do or not. †Not every GPIO
>> > > controller supports reading back the initial state from the direction
>> > > register. †I suspect it is better to leave initialization of the
>> > > direction to the gpio controller driver itself.
>> > >
>> > That would mean, that external software would have to have access to
>> > the bgpio internal data structures which is a Bad Thing(TM) IMO. Or we
>> > need a function that allows to explicitly initialize the internal
>> > shadow registers.
>>
>> What device are you using this for. †Are you using the basic gpio
>> platform_driver, or do you have a driver using the library part of the
>> basic gpio code?
>>
> I'm using it via drivers/gpio/gpio-mxc.

You can safely do the "bgc->dir = bgc->read_reg(bgc->reg_dir);" in
gpio-mxc after bgpio_init returns.

g.
