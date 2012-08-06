Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab2HFJZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 05:25:58 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:45465 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755765Ab2HFJZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 05:25:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120806085221.GE17551@arwen.pp.htv.fi>
References: <1343639400-28725-1-git-send-email-kishon@ti.com>
	<20120806085221.GE17551@arwen.pp.htv.fi>
Date: Mon, 6 Aug 2012 14:55:53 +0530
Message-ID: <CAAe_U6KsyRppEd4Z__t448SD=SzvWa2u7pec86rwn6KW8tuB+Q@mail.gmail.com>
Subject: Re: [PATCH v6 00/11] omap: musb: Add device tree support
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: balbi@ti.com
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        rnayak@ti.com, tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 2:22 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Mon, Jul 30, 2012 at 02:39:49PM +0530, Kishon Vijay Abraham I wrote:
>> This patch series adds device tree support for MUSB and device
>> tree support for all the related modules to get MUSB working in
>> OMAP platform.
>>
>> A new omap-usb2 phy driver has been added (with only dt suppport)
>> to perform phy configurations. Previously this configuration was
>> performed by twl6030, using pdata function pointers.
>>
>> With the addition of omap-usb2 to perform phy configurations,
>> twl6030 is made as a comparator driver to detect VBUS and ID events
>> and notify it to the glue layer.
>>
>> musb core is _NOT_ yet converted to support device tree support as it
>> would need lot of driver re-design because of its enormous use of
>> function pointers. That will be in _TO DO_ list.
>>
>> Changes from v5:
>> minor cleanups like checking for return value in get_sync and few changes
>> in the documentation has been done.
>>
>> Changes from v4:
>> duplicate getting of 'mode' property is removed in omap-musb glue.
>>
>> Changes from v3:
>> remove the address in the node name of usb_otg_hs since the usb_otg_hs
>> node doesn't have a reg property. Thanks Ajay Gupta for finding this.
>>
>> Changes from v2:
>> Fixed Sergei's comment to remove *0x* prefix in usb2phy@0x4a0ad080
>>
>> Changes from v1:
>> * Fixed Rajendra Nayak comments (regulator naming, compatible naming of
>> musb and other minor cleanups.)
>> * It's agreed to have ocp2scp in drivers/bus and usb2 phy is a child of
>> ocp2scp, the documentation is updated accordingly.
>>
>> Changes from RFC:
>> Removed the dependency on [RFC PATCH 00/11] OMAP System Control Module.
>> Writing to control module register is now handled in otg driver itself.
>> Once the system control module driver get upstreamed, I'll send a patch
>> to make use of API's in control module driver to write to control
>> module register.
>>
>> This series was developed on
>> git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git xceiv
>>
>> This patch series depends on
>> [PATCH 0/2] omap: add ocp2scp as a bus driver
>>
>> Performed MUSB device mode testing on OMAP4 panda, OMAP4 SDP
>> and OMAP3 beagle.
>>
>> Kishon Vijay Abraham I (11):
>>   drivers: usb: otg: add a new driver for omap usb2 phy
>>   arm/dts: omap: Add omap-usb2 dt data
>>   drivers: usb: otg: make twl6030_usb as a comparator driver to
>>     omap_usb2
>>   arm: omap: hwmod: add a new addr space in otg for writing to control
>>     module
>>   drivers: usb: twl6030: Add dt support for twl6030 usb
>>   arm/dts: Add twl6030-usb data
>>   drivers: usb: twl4030: Add device tree support for twl4030 usb
>>   arm/dts: Add twl4030-usb data
>>   drivers: usb: musb: Add device tree support for omap musb glue
>>   arm/dts: omap: Add usb_otg and glue data
>>   arm: omap: phy: remove unused functions from omap-phy-internal.c
>
> When you send your next series, can you please split the stuff based on
> their dependencies or at least note here what depends on what ? I mean,
> I cannot take the DT patches without an Acked-by Grant and Tony, but the
> drivers themselves I could take queue them since they're already in good
> shape ;-)
>
> Maybe just start the series with patches without dependencies on one
> another, and the rest of the series would be ones that need to go
> together, or something. That'll help me ;-)

Ok Felipe.

Thanks
Kishon
