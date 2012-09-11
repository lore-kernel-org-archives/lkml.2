Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825Ab2IKLHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:07:42 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:45527 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758087Ab2IKLHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:07:41 -0400
MIME-Version: 1.0
In-Reply-To: <504F0DDE.308@ti.com>
References: <1347345381-4390-1-git-send-email-kishon@ti.com>
	<1347345381-4390-3-git-send-email-kishon@ti.com>
	<504F0DDE.308@ti.com>
Date: Tue, 11 Sep 2012 16:37:39 +0530
Message-ID: <CAAe_U6JQc62acMkv9XZR8sB8z1-iCfZikCyZQtiB0n7VrNt2NA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] arm/dts: Add twl4030-usb data
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Benoit Cousson <b-cousson@ti.com>
Cc: balbi@ti.com, linux@arm.linux.org.uk, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, tony@atomide.com, rnayak@ti.com,
        hvaibhav@ti.com, peter.ujfalusi@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 11, 2012 at 3:39 PM, Benoit Cousson <b-cousson@ti.com> wrote:
> On 09/11/2012 08:36 AM, Kishon Vijay Abraham I wrote:
>> Add twl4030-usb data node in twl4030 device tree file.
>
> IIRC, the usb part on twl4030 was doing more than it does on twl6030.

Indeed. twl4030 is the usb phy as well (unlike twl6030 which is only a
comparator). But there is not much difference in dt data.
>
> Could you describe what part of the USB is really done by the TWL in
> that case?
>
>> Acked-by: Felipe Balbi <balbi@ti.com>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>  arch/arm/boot/dts/twl4030.dtsi |   21 +++++++++++++++++++++
>>  1 file changed, 21 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/twl4030.dtsi b/arch/arm/boot/dts/twl4030.dtsi
>> index 22f4d13..761a5a5 100644
>> --- a/arch/arm/boot/dts/twl4030.dtsi
>> +++ b/arch/arm/boot/dts/twl4030.dtsi
>> @@ -37,6 +37,18 @@
>>               regulator-max-microvolt = <3150000>;
>>       };
>>
>> +     vusb1v5: regulator-vusb1v5 {
>> +             compatible = "ti,twl4030-vusb1v5";
>> +     };
>> +
>> +     vusb1v8: regulator-vusb1v8 {
>> +             compatible = "ti,twl4030-vusb1v8";
>> +     };
>> +
>> +     vusb3v1: regulator-vusb3v1 {
>> +             compatible = "ti,twl4030-vusb3v1";
>> +     };
>> +
>>       twl_gpio: gpio {
>>               compatible = "ti,twl4030-gpio";
>>               gpio-controller;
>> @@ -44,4 +56,13 @@
>>               interrupt-controller;
>>               #interrupt-cells = <1>;
>>       };
>> +
>> +     twl4030-usb {
>
> Same comment than before about the name. Is it the usb-comparator as well?
No. Here it's the phy as well.
>
>> +             compatible = "ti,twl4030-usb";
>> +             interrupts = < 10 4 >;
>> +             usb1v5-supply = <&vusb1v5>;
>> +             usb1v8-supply = <&vusb1v8>;
>> +             usb3v1-supply = <&vusb3v1>;
>> +             usb_mode = <1>;
>
> Is this a TI only attribute or something generic?

It's describes the way twl4030 is connected is connected to omap. So I
think it should be prefixed with "ti".

Thanks
Kishon
