Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935116Ab2JXOqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 10:46:47 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:49947 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935070Ab2JXOpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 10:45:53 -0400
Message-ID: <5087FF0C.7050303@free-electrons.com>
Date: Wed, 24 Oct 2012 16:45:32 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>
CC: Lior Amsalem <alior@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        David Marlin <dmarlin@redhat.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Eran Ben-Avi <benavi@marvell.com>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Jon Masters <jcm@redhat.com>, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 2/2] arm: mvebu: adding SATA support: dt binding and config
 update
References: <1351086561-13569-1-git-send-email-gregory.clement@free-electrons.com> <1351086561-13569-3-git-send-email-gregory.clement@free-electrons.com> <20121024140801.GB11837@lunn.ch>
In-Reply-To: <20121024140801.GB11837@lunn.ch>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 04:08 PM, Andrew Lunn wrote:
> On Wed, Oct 24, 2012 at 03:49:21PM +0200, Gregory CLEMENT wrote:
>> From: Lior Amsalem <alior@marvell.com>
>>
>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>> Signed-off-by: Lior Amsalem <alior@marvell.com>
>> ---
>>  arch/arm/boot/dts/armada-370-db.dts  |    3 +++
>>  arch/arm/boot/dts/armada-370-xp.dtsi |   10 ++++++++++
>>  arch/arm/boot/dts/armada-xp-db.dts   |    3 +++
>>  arch/arm/configs/mvebu_defconfig     |    7 +++++++
>>  4 files changed, 23 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/armada-370-db.dts b/arch/arm/boot/dts/armada-370-db.dts
>> index 4a31b03..2a2aa75 100644
>> --- a/arch/arm/boot/dts/armada-370-db.dts
>> +++ b/arch/arm/boot/dts/armada-370-db.dts
>> @@ -34,5 +34,8 @@
>>  			clock-frequency = <200000000>;
>>  			status = "okay";
>>  		};
>> +		sata@d00a0000 {
>> +			status = "okay";
>> +		};
>>  	};
>>  };
>> diff --git a/arch/arm/boot/dts/armada-370-xp.dtsi b/arch/arm/boot/dts/armada-370-xp.dtsi
>> index 94b4b9e..3f08233 100644
>> --- a/arch/arm/boot/dts/armada-370-xp.dtsi
>> +++ b/arch/arm/boot/dts/armada-370-xp.dtsi
>> @@ -69,6 +69,16 @@
>>  			compatible = "marvell,armada-addr-decoding-controller";
>>  			reg = <0xd0020000 0x258>;
>>  		};
>> +
>> +		sata@d00a0000 {
>> +                        compatible = "marvell,orion-sata";
>> +                        reg = <0xd00a0000 0x2400>;
>> +                        interrupts = <55>;
>> +                        nr-ports = <2>;
>> +			clocks = <&coreclk 0>;//,  <&coreclk 0>;
>> +                        status = "disabled";
>> +		};
>> +
>>  	};
>>  };
>>  
>> diff --git a/arch/arm/boot/dts/armada-xp-db.dts b/arch/arm/boot/dts/armada-xp-db.dts
>> index b1fc728..b0db9a3 100644
>> --- a/arch/arm/boot/dts/armada-xp-db.dts
>> +++ b/arch/arm/boot/dts/armada-xp-db.dts
>> @@ -46,5 +46,8 @@
>>  			clock-frequency = <250000000>;
>>  			status = "okay";
>>  		};
>> +		sata@d00a0000 {
>> +			status = "okay";
>> +		};
>>  	};
>>  };
> 
> Hi Gregory
> 
> Should there be some pinctrl setup somewhere, to ensure the pins used
> for SATA are really setup up for SATA?

Yes you're right we should not depend of the bootloader configuration.

> 
> Also, for kirkwood, the number of SATA ports varies. So we don't
> define it in the base kirkwood.dtsi and leave each board to set it.
> Do we want to be consistent between kirkwood and 370/xp?

Yes sure. I will move it from dtsi to dts.

> 
> Thanks
>     Andrew
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
