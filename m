Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784Ab2BNRRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 12:17:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51528 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756562Ab2BNRRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 12:17:41 -0500
Date: Tue, 14 Feb 2012 17:17:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        NeilBrown <neilb@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve Hj?nnevag <arve@android.com>,
        =?utf-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        =?utf-8?B?6rmA64+Z6re8?= <dg77.kim@samsung.com>,
        Greg KH <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, myungjoo.ham@gmail.com
Subject: Re: Re: [PATCH v5 5/5] Extcon: adc-jack driver to support 3.5 pi
	or simliar devices
Message-ID: <20120214171737.GA2321@opensource.wolfsonmicro.com>
References: <1724827.104121329202847962.JavaMail.weblogic@epml06>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1724827.104121329202847962.JavaMail.weblogic@epml06>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 07:00:48AM +0000, MyungJoo Ham wrote:
> Mark Brown wrote:

> > No, that's not what I'm suggesting - what I'm suggesting is that rather
> > than having a callback for implementing the ADC read functionality this
> > should work as an in-kernel IIO driver so it'll just automatically work
> > with any ADC without needing code to hook things up.  Unless I've not
> > understood your comment fully.

> Ok. Do you mean that we should give struct iio_dev * and struct
> iio_chan_spec * instead of a callback?  I thought there was no
> standard framework for ADC (the reason why this is a simple callback);
> however, may I regard iio/adc as the standard for ADC? (I see some ADC
> device drivers in HWMON)

Yes, the idea is that IIO becomes the standard way of using general
purpose ADCs like this in the kernel rather than having lots of similar
custom APIs floating around with callbacks as we do now.

> Do I need to make this driver as an iio device driver in order to do this? I guess including iio.h would be enough anyway.

I'd not expect so, I'd expect it's just a user of IIO.
