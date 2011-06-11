Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406Ab1FKQWi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 12:22:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50781 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750835Ab1FKQWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 12:22:37 -0400
Date: Sat, 11 Jun 2011 17:05:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ashish Jangam <Ashish.Jangam@kpitcummins.com>,
        "sameo@openedhand.com" <sameo@openedhand.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun Chen <Dajun.Chen@diasemi.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Subject: Re: [PATCHv3 -next] MFD: MFD module of DA9052 PMIC driver
Message-ID: <20110611160523.GA7079@opensource.wolfsonmicro.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BC62219@KCINPUNHJCMS01.kpit.com> <201106111249.05204.arnd@arndb.de> <20110611113705.GA2738@opensource.wolfsonmicro.com> <201106111635.42563.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106111635.42563.arnd@arndb.de>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 11, 2011 at 04:35:42PM +0200, Arnd Bergmann wrote:
> On Saturday 11 June 2011 13:37:06 Mark Brown wrote:
> > On Sat, Jun 11, 2011 at 12:49:04PM +0200, Arnd Bergmann wrote:

> This is entirely pointless for this particular driver. While I can
> see good reasons to share idioms across similar drivers, this one
> just doesn't need it. The only two functions where the data is used
> AFAICT are da9052_irq_sync_unlock and da9052_irq_unmask, and both
> could replace the table lookup with a trivial computation.

Yes, indeed.

> I only looked at the first function in the list (da9052_adc_manual_read)
> and noticed that it doesn't have any users at all. It's certainly
> ok to export a complete API set when some functions belong together,
> but I had the impression that in this case it wasn't actually clear
> what the API is or should be.

> Maybe an explanation about what da9052_adc_manual_read does or why
> it's exported would be useful, I'm objecting the other exports.

There's been a hwmon driver posted which will use it I expect.  Many
PMICs have an ADC in them used for monitoring things like temperature
and supply rails, and typically also provide some generic inputs for
systems to use.  This is the sort of low rate ADC I'd like to see IIO be
able to handle but right now a custom interface like that is the
standard way to expose the ADC to the subsystems that can use it
(including machine specific code).
