Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab2FULzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 07:55:46 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49595 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab2FULzo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 07:55:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAAAP30G6zE5UmVMPPDGpwzHXG5zN3ZZfJ9u4W2TM1B5ccF50Lw@mail.gmail.com>
References: <1339678763-14509-1-git-send-email-aletes.xgr@gmail.com>
	<CAMSQXEHOtgk7wRRqOdpMaTvpxFd1Cpom=BG65GheY6Z4p2Jc3A@mail.gmail.com>
	<CAAAP30G6zE5UmVMPPDGpwzHXG5zN3ZZfJ9u4W2TM1B5ccF50Lw@mail.gmail.com>
Date: Thu, 21 Jun 2012 08:55:43 -0300
Message-ID: <CAAAP30F1gWgvPwO2VT8fcP7X8veJuMfFjg34LkRaz-q7mwGfWg@mail.gmail.com>
Subject: Re: [PATCH] SPI: at25: Parse dt settings
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Ivo Sieben <meltedpianoman@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Chris Wright <chrisw@sous-sol.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roland Stigge <stigge@antcom.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 8:10 AM, Alexandre Pereira da Silva
<aletes.xgr@gmail.com> wrote:
> On Thu, Jun 21, 2012 at 6:49 AM, Ivo Sieben <meltedpianoman@gmail.com> wrote:
>> One small remark:
>> In case of platform_data, the "if (!chip)" check has been removed and
>> is now only handled in the device tree initialization.
>> Maybe add this check to the platform initialization as well:
>>
>> } else {
>>        if (!spi->dev.platform_data) {
>>                dev_dbg(&spi->dev, "no chip description\n");
>>                err = -ENODEV;
>>                goto fail;
>>        }
>>        chip =  *(struct spi_eeprom *)spi->dev.platform_data;
>> }

Please ignore my last email. Not enough coffee.

I'm sorry. The code looks right to me.

-       chip = spi->dev.platform_data;
-       if (!chip) {
-               dev_dbg(&spi->dev, "no chip description\n");
-               err = -ENODEV;
-               goto fail;
-       }
+       if (!spi->dev.platform_data) {
+               if (np) {
                             /* No platform data and DT node present,
DT handling */
+               } else {
                            /* No DT and No platform description,
handle error */
+                       dev_dbg(&spi->dev, "no chip description\n");
+                       err = -ENODEV;
+                       goto fail;
+               }
+       } else
                 /* At this point chip is guaranteed to have valid data */
+               chip = *(struct spi_eeprom *)spi->dev.platform_data;
