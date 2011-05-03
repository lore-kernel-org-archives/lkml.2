Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab1ECPzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 11:55:42 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:55802 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab1ECPzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 11:55:40 -0400
Content-Type: text/plain; charset=UTF-8
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        linux-iio <linux-iio@vger.kernel.org>
Subject: Re: [lm-sensors] [RFC 5/5] hwmon: add support for Technologic Systems TS-5500 A-D converter
In-reply-to: <20110430033938.GA14397@ericsson.com>
References: <1304115712-5299-1-git-send-email-vivien.didelot@savoirfairelinux.com> <1304115712-5299-6-git-send-email-vivien.didelot@savoirfairelinux.com> <20110430033938.GA14397@ericsson.com>
Date: Tue, 03 May 2011 11:55:34 -0400
Message-Id: <1304434162-sup-3877@sfl>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

Excerpts from Guenter Roeck's message of 2011-04-29 23:39:38 -0400:
> Hi Vivien,
> 
> The headline and file name are a bit misleading, since the driver is really
> for MAX197 on a TS-5500 board.
> 
> You should split the driver into two parts, a generic driver
> for the MAX197 and a platform driver (residing somewhere in arch/
> or possibly drivers/platform/) to instantiate it.
> 
> There should be a platform data include file, probably in
> include/linux/platform_data/.
> 
> .ioaddr in platform data should not be necessary. The driver's probe
> function should get the values using platform_get_resource().
> 
> Having said that, from reading the code it looks like the chip is not really
> used for hardware monitoring, but for generic ADC functionality. A quick look
> into the TS-5500 user manual confirms this. So this should not be a hwmon
> driver in the first place, but a generic ADC driver. Given the ADC conversion rate
> of the MAX197, the hwmon ABI is not optimal anyway. You should move this driver
> into the iio subsystem, probably to drivers/staging/iio/adc. Copying the iio
> mailing list for input.
> 
> Thanks,
> Guenter

I've took a closer look to the manual and that's right, in fact the
driver doesn't talk to the MAX197 directly. The board uses a CPLD to
abstract the interface to the MAX197. So all the MAX197 logic is hidden
by the CPLD.  Therefore, the driver files should probably not have
function and structure names with a "max197_" prefix. I'll make the code
a bit clearer. What do you think?

Ok for iio subsystem, several ADC drivers are in drivers/hwmon/ but
drivers/staging/iio/adc seems to be the good place now.

Regards,
Vivien.
