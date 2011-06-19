Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336Ab1FSAZA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 20:25:00 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52692 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab1FSAY7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 20:24:59 -0400
MIME-Version: 1.0
In-Reply-To: <201106182027.22974.arnd@arndb.de>
References: <1308410354-21387-1-git-send-email-shawn.guo@linaro.org>
 <1308410354-21387-3-git-send-email-shawn.guo@linaro.org> <201106182027.22974.arnd@arndb.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 18 Jun 2011 18:24:38 -0600
X-Google-Sender-Auth: 984UFqJC9FmwmArIV97qsRxuvXE
Message-ID: <BANLkTimkT2G8v=hrzy0oB8Y0wfzc4jECuA@mail.gmail.com>
Subject: Re: [PATCH 2/3] net/fec: add device tree support
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Jason Liu <jason.hui@linaro.org>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 18, 2011 at 12:27 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 18 June 2011 17:19:13 Shawn Guo wrote:
>> diff --git a/Documentation/devicetree/bindings/net/fsl-fec.txt b/Documentation/devicetree/bindings/net/fsl-fec.txt
>> new file mode 100644
>> index 0000000..705111d
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/fsl-fec.txt
>> @@ -0,0 +1,14 @@
>> +* Freescale Fast Ethernet Controller (FEC)
>> +
>> +Required properties:
>> +- compatible : should be "fsl,<soc>-fec", "fsl,fec"
>> +- reg : address and length of the register set for the device
>> +- interrupts : should contain fec interrupt
>> +
>> +Example:
>> +
>> +fec@83fec000 {
>> +     compatible = "fsl,imx51-fec", "fsl,fec";
>> +     reg = <0x83fec000 0x4000>;
>> +     interrupts = <87>;
>> +};
>
> How about also adding device_type="network" as required here, so you
> inherit the attributes like "local-mac-address".

local-mac-address should be used regardless.  "device_type" only makes
sense when a platform uses real OpenFirmware with the runtime services
api.  It should not be used with the flat tree.

> I would also suggest adding a call to of_get_mac_address() so you
> can read the address out of the device tree when it is not configured
> in hardware. Today, the driver relies on a module parameter or
> platform_data on hardware with a mac address set.

Yes, of_get_mac_address() is the right thing to do.

g.
