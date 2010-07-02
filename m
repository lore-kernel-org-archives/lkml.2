Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab0GBKxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 06:53:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48516 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755348Ab0GBKxw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 06:53:52 -0400
From: "Datta, Shubhrajyoti" <shubhrajyoti@ti.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
       "sfking@fdwdc.com" <sfking@fdwdc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 2 Jul 2010 16:23:40 +0530
Subject: RE: [RFC] [PATCH] digital compass hmc5843
Thread-Topic: [RFC] [PATCH] digital compass hmc5843
Thread-Index: AcsZzwdzUqLFoukMSUacjEkscxuLvwAAeFpQ
Message-ID: <0680EC522D0CC943BC586913CF3768C003B360338A@dbde02.ent.ti.com>
References: <0680EC522D0CC943BC586913CF3768C003B360319D@dbde02.ent.ti.com>
 <4C2CBB40.5070104@cam.ac.uk>
 <0680EC522D0CC943BC586913CF3768C003B3603331@dbde02.ent.ti.com>
 <4C2DBBE3.1020804@cam.ac.uk>
In-Reply-To: <4C2DBBE3.1020804@cam.ac.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> <snip>
> >
> > I think that having a Hz as units will have its own issues. First the
> decimal implementation. However I am open to the implementation.
> > Also do you know of a driver that takes care of this.
> None of the current drivers go below 1Hz so not quite the same.
> lis3l02dq (accelerometer) does the match against a list, but it
> is done numerically rather than via string matches as would be needed
> here.
> >
> >>
> >> static IIO_CONST_ATTR_SAMP_FREQ_AVAIL("0.5 1 2 5 10 20 50");
> >>
> >>
> >> Then strncmp with the options to set the value up.  The rounding
> approach
> >> gets tricky with a non integer value so probably easier to only allow
> >> these
> >> values.

What is a recommended way of getting a double or float
Is there any Strict_srttod etc.

> >
> > Allowing only this value will result in default/ reject case and will
> keep the previous value, may confuse the application
> Then the application is ignoring the interface spec that says it must read
> _available files if they are there.
> This way the rounding behaviour is left to userspace and what the
> application prefers rather
> than in kernel actually making it the most flexible option.

Agree 
> >
> >>
> >>> +static IIO_DEV_ATTR_AVAIL_SAMP_FREQ(show_avail_samp_freq);
> >>> +
> >>> +static s32 hmc5843_set_rate(struct i2c_client *client,
> >>> +                               u8 rate)
> >>> +{
> >>> +       struct hmc5843_data *data = i2c_get_clientdata(client);
> >>> +       u8 reg_val;
> >>> +
