Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab1F3OsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 10:48:21 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50095 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab1F3OsQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 10:48:16 -0400
MIME-Version: 1.0
In-Reply-To: <20110630141823.GF1997@pengutronix.de>
References: <1309440959-18692-1-git-send-email-w.sang@pengutronix.de>
 <20110630161101.4bee9b19@endymion.delvare> <20110630141823.GF1997@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 30 Jun 2011 08:47:55 -0600
X-Google-Sender-Auth: gN2IyFPsfLRFnpC_3Z2HiW_RVdA
Message-ID: <BANLkTimNPnjsW1ny0AvsFuw7_bSmnF0Ejw@mail.gmail.com>
Subject: Re: [PATCH] gpio: pca953x: change driver name to be unique
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 8:18 AM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> On Thu, Jun 30, 2011 at 04:11:01PM +0200, Jean Delvare wrote:
>> On Thu, 30 Jun 2011 15:35:59 +0200, Wolfram Sang wrote:
>> > This driver handles the variants pca9534-pca9539, so it chose the name
>> > "pca953x". However, there is a led driver which decided on the same
>> > name. As a result, those two can't be loaded at the same time. Add a
>> > subsystem prefix to make the driver name unique. Device matching will
>> > not suffer, because both are I2C drivers which match using a
>> > i2c_device_id-table which is not altered.
>> >
>> > Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
>> > ---
>> >  drivers/gpio/pca953x.c |    2 +-
>> >  1 files changed, 1 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
>> > index 0451d7a..b30dd0b 100644
>> > --- a/drivers/gpio/pca953x.c
>> > +++ b/drivers/gpio/pca953x.c
>> > @@ -742,7 +742,7 @@ static int pca953x_remove(struct i2c_client *client)
>> >
>> >  static struct i2c_driver pca953x_driver = {
>> >     .driver = {
>> > -           .name   = "pca953x",
>> > +           .name   = "gpio-pca953x",
>> >     },
>> >     .probe          = pca953x_probe,
>> >     .remove         = pca953x_remove,
>>
>> With the proposed change to the leds-pca9532 driver, you could leave
>> this one alone, for the sake of simplicity and consistency with the
>> pca953x, pcf857x and max732x gpio drivers.
>>
>> But I am not objecting to this change, if you like it.
>
> I am fine with your suggestion.

All right, I'll ignore this patch then.

g.
