Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab2DTPfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:35:42 -0400
Received: from antcom.de ([188.40.178.216]:51341 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819Ab2DTPfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:35:41 -0400
Message-ID: <4F91824A.10207@antcom.de>
Date: Fri, 20 Apr 2012 17:35:38 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: jic23@cam.ac.uk, gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Kevin Wells <kevin.wells@nxp.com>,
        Srinivas Bakki <srinivas.bakki@nxp.com>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND v3] iio: Add device tree support to LPC32xx ADC
References: <1334932713-19231-1-git-send-email-stigge@antcom.de> <4F917AE3.7050808@metafoo.de>
In-Reply-To: <4F917AE3.7050808@metafoo.de>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/20/2012 05:04 PM, Lars-Peter Clausen wrote:
>> --- /dev/null
>> +++ linux-2.6/Documentation/devicetree/bindings/staging/iio/adc/lpc32xx-adc.txt
>> @@ -0,0 +1,16 @@
>> +* NXP LPC32xx SoC ADC controller
>> +
>> +Required properties:
>> +- compatible: must be "nxp,lpc32xx-adc"
>> +- reg: physical base address of the controller and length of memory mapped
>> +  region.
>> +- interrupts: The ADC interrupt
>> +
>> +Example:
>> +
>> +	adc@40048000 {
>> +		compatible = "nxp,lpc32xx-adc";
> 
> In my opinion it seems to be a bad idea to use wildcard names in devicetree
> compatible strings.

In the above case, the situation is as follows:

* NXP has LPC3220, LPC3230, LPC3240 and LPC3250 (differing in SRAM size
  and in the existence of its Ethernet and LCD controllers)
* The ADC controller is present in every single one of those
* We already have "lpc32xx" in the kernel everywhere
* Current state is that NXP isn't planning to issue LPC32xx without ADC
* I'm providing a lpc32xx.dtsi file to be used by all LPC32xx variants.
  This one is referencing the above "compatible" string. Splitting up
  in all possible numbers (see below) doesn't help much, here.

What would you prefer?

+static const struct of_device_id lpc32xx_adc_match[] = {
+       { .compatible = "nxp,lpc3220-adc" },
+       { .compatible = "nxp,lpc3230-adc" },
+       { .compatible = "nxp,lpc3240-adc" },
+       { .compatible = "nxp,lpc3250-adc" },
+       {},
+};

?

What is a better strategy here?

Thanks in advance,

Roland
