Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab2JXLud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:50:33 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:47936 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab2JXLub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:50:31 -0400
Message-ID: <5087D5F4.9060104@free-electrons.com>
Date: Wed, 24 Oct 2012 13:50:12 +0200
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
        Russell King <linux@arm.linux.org.uk>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Eran Ben-Avi <benavi@marvell.com>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Jon Masters <jcm@redhat.com>, Rob Herring <rob.herring@calxeda.com>,
        Ben Dooks <ben-linux@fluff.org>, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 2/2] arm: mvebu: Add hardware I/O Coherency support
References: <1351065841-18654-1-git-send-email-gregory.clement@free-electrons.com> <1351065841-18654-3-git-send-email-gregory.clement@free-electrons.com> <20121024082529.GZ11837@lunn.ch>
In-Reply-To: <20121024082529.GZ11837@lunn.ch>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 10:25 AM, Andrew Lunn wrote:
> On Wed, Oct 24, 2012 at 10:04:01AM +0200, Gregory CLEMENT wrote:
>> Armada 370 and XP come with an unit called coherency fabric. This unit
>> allows to use the Armada XP as a nearly coherent architecture. The
>> coherency mechanism uses snoop filters to ensure the coherency between
>> caches, DRAM and devices. This mechanism needs a synchronization
>> barrier which guarantees that all memory write initiated by the
>> devices has reached their target and do not reside in intermediate
>> write buffers. That's why the architecture is not totally coherent and
>> we need to provide our own functions for some DMA operations.
>>
>> Beside the use of the coherency fabric, the device units will have to
>> set the attribute flag to select the accurate coherency process for
>> the memory transaction. This is done each device driver programs the
>> DRAM address windows. The value of the attribute set by the driver is
>> retrieved through the orion_addr_map_cfg struct filled during the
>> early initialization of the platform.
>>
>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>> Reviewed-by: Yehuda Yitschak <yehuday@marvell.com>
>> ---
>>  arch/arm/boot/dts/armada-370-xp.dtsi |    3 +-
>>  arch/arm/mach-mvebu/addr-map.c       |    3 ++
>>  arch/arm/mach-mvebu/armada-370-xp.c  |    1 +
>>  arch/arm/mach-mvebu/coherency.c      |   87 ++++++++++++++++++++++++++++++++++
>>  arch/arm/mach-mvebu/common.h         |    2 +
>>  5 files changed, 95 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/boot/dts/armada-370-xp.dtsi b/arch/arm/boot/dts/armada-370-xp.dtsi
>> index 18ba60b..af22e53 100644
>> --- a/arch/arm/boot/dts/armada-370-xp.dtsi
>> +++ b/arch/arm/boot/dts/armada-370-xp.dtsi
>> @@ -38,7 +38,8 @@
>>  
>>  	coherency-fabric@d0020200 {
>>  		compatible = "marvell,coherency-fabric";
>> -		reg = <0xd0020200 0xb0>;
>> +		reg = <0xd0020200 0xb0>,
>> +		      <0xd0021010 0x1c>;
>>  	};
> 
> ...
> 
>>  int __init armada_370_xp_coherency_init(void)
>>  {
>>  	struct device_node *np;
>> @@ -82,7 +159,17 @@ int __init armada_370_xp_coherency_init(void)
>>  	if (np) {
>>  		pr_info("Initializing Coherency fabric\n");
>>  		coherency_base = of_iomap(np, 0);
>> +		coherency_cpu_base = of_iomap(np, 1);
> 
> Is this already in the binding documentation?

No indeed, the documentation should be completed. I will do it
the V2

> 
>    Thanks
> 	Andrew
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
