Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab2HNK1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 06:27:53 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:39621 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612Ab2HNK1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 06:27:51 -0400
MIME-Version: 1.0
In-Reply-To: <502A20DD.5030707@ti.com>
References: <1344852313-30484-1-git-send-email-sourav.poddar@ti.com>
	<1344852313-30484-3-git-send-email-sourav.poddar@ti.com>
	<502A20DD.5030707@ti.com>
Date: Tue, 14 Aug 2012 15:57:50 +0530
Message-ID: <CAKdam57ri9HxCt5q1yhJzRFfHkVk2oGO8=aqLvYqwWWoYASdVw@mail.gmail.com>
Subject: Re: [PATCHv2 2/4] arm/dts: omap5-evm: Add tmp102 sensor support
From: "Poddar, Sourav" <sourav.poddar@ti.com>
To: Benoit Cousson <b-cousson@ti.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Felipe Balbi <balbi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On Tue, Aug 14, 2012 at 3:26 PM, Benoit Cousson <b-cousson@ti.com> wrote:
> On 08/13/2012 12:05 PM, Sourav Poddar wrote:
>> Add tmp102 temperature sensor data in omap5 evm dts file.
>>
>> Tested on omap5430 evm with 3.5 custom kernel.
>>
>> Cc: Benoit Cousson <b-cousson@ti.com>
>> Cc: Felipe Balbi <balbi@ti.com>
>> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> Acked-by: Felipe Balbi <balbi@ti.com>
>> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
>> ---
>>  arch/arm/boot/dts/omap5-evm.dts |    9 +++++++++
>>  1 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/omap5-evm.dts b/arch/arm/boot/dts/omap5-evm.dts
>> index 200c39a..45a8aeb 100644
>> --- a/arch/arm/boot/dts/omap5-evm.dts
>> +++ b/arch/arm/boot/dts/omap5-evm.dts
>> @@ -18,3 +18,12 @@
>>               reg = <0x80000000 0x40000000>; /* 1 GB */
>>       };
>>  };
>> +
>> +&i2c4 {
>> +     clock-frequency = <400000>;
>
> Have you checked if we cannot run at faster speed? Reducing the speed
> will impact every devices on the bus.
> It might be needed, I just wanted to be sure.
>
Indeed, tmp 102(i2c4) and bmp085(i2c2) can run at speed upto 3.4 MHz.

Though, there are other devices on i2c2(tsl2771) and i2c4
(touchscreen) that will eventually come, support upto
400 KHz.  May be I will change this to 3.4 MHz for now?And when
tsl2771 and touch device are added, I will
change it back to 400 kHz??

~Sourav
> You should maybe just add a small comment to explain what the device is
> doing with potentially a link to the HW spec if available.
>
> The same comments are applicable to the bmp085 patch.
>
> Regards,
> Benoit
>
