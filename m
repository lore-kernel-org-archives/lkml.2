Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165Ab2GIECc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 00:02:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:10268 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab2GIEC3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 00:02:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="190030979"
From: "Moore, Robert" <robert.moore@intel.com>
To: "Lan, Tianyu" <tianyu.lan@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
CC: "Zhang, Rui" <rui.zhang@intel.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jkosina@suse.cz" <jkosina@suse.cz>, "chatty@enac.fr" <chatty@enac.fr>,
        "jj_ding@emc.com.tw" <jj_ding@emc.com.tw>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "abelay@mit.edu" <abelay@mit.edu>,
        "Lin, Ming M" <ming.m.lin@intel.com>,
        "Tang, Feng" <feng.tang@intel.com>
Subject: RE: Fwd: Hid over I2C and ACPI interaction
Thread-Topic: Fwd: Hid over I2C and ACPI interaction
Thread-Index: AQHNWnwJr0W0E9kVHkW4sw/UYE1YhJccN3QAgASNsoD//5TS4A==
Date: Mon, 9 Jul 2012 04:02:25 +0000
Message-ID: <94F2FBAB4432B54E8AACC7DFDE6C92E346B0A606@ORSMSX101.amr.corp.intel.com>
References: <CAN+gG=GnMX8Gu6w9za2QrjoVrmORncFgq-+hhmHvxtOPEB=nDw@mail.gmail.com>
 <4FF52C70.9010601@intel.com> <1341471717.1682.125.camel@rui.sh.intel.com>
 <20120706055234.GC2237@intel.com> <4FFA4EFD.6090708@intel.com>
In-Reply-To: <4FFA4EFD.6090708@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are already defined in acpica - in the file acrestyp.h

    ACPI_RESOURCE_FIXED_DMA                 FixedDma;

    ACPI_RESOURCE_GPIO                      Gpio;
    ACPI_RESOURCE_I2C_SERIALBUS             I2cSerialBus;
    ACPI_RESOURCE_SPI_SERIALBUS             SpiSerialBus;
    ACPI_RESOURCE_UART_SERIALBUS            UartSerialBus;
    ACPI_RESOURCE_COMMON_SERIALBUS          CommonSerialBus;



>-----Original Message-----
>From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
>owner@vger.kernel.org] On Behalf Of Lan Tianyu
>Sent: Sunday, July 08, 2012 8:25 PM
>To: Mika Westerberg
>Cc: Zhang, Rui; khali@linux-fr.org; ben-linux@fluff.org;
>w.sang@pengutronix.de; lenb@kernel.org; linux-acpi@vger.kernel.org; linux-
>i2c@vger.kernel.org; linux-kernel@vger.kernel.org; jkosina@suse.cz;
>chatty@enac.fr; jj_ding@emc.com.tw; bhelgaas@google.com; abelay@mit.edu
>Subject: Re: Fwd: Hid over I2C and ACPI interaction
>
>On 2012年07月06日 13:52, Mika Westerberg wrote:
>> On Thu, Jul 05, 2012 at 03:01:57PM +0800, Zhang Rui wrote:
>>> +Note that although these are ACPI devices, we prefer to use PnP drivers
>>> for them,
>>> +this is because:
>>> +1. all the non-ACPI-predefined Devices are exported as PnP devices as
>>> well
>>> +2. PnP bus is a well designed bus. Probing via PnP layer saves a lot of
>>> work
>>> +   for the device driver, e.g. getting&  parsing ACPI resources.
>>
>> (Nice BKM, thanks for sharing)
>>
>> I have few questions about using PnP drivers instead of pure ACPI
>drivers.
>>
>> ACPI 5.0 defined some new resources, for example "Fixed DMA descriptor"
>> that has information about the request line + channel for the device to
>> use. Hovewer, PnP drivers pass resources as 'struct resource', which
>> basically only has start and end - how do you represent all this new
>stuff
>> using 'struct resource'?
>>
>I think we can add new interface to get acpi specific resources. e.g
>struct acpi_resource pnp_get_acpi_resource(...). When the pnp acpi devices
>were initialized, put those acpi specific resources into a new resource
>list
>pnpdev->acpi_resources. What pnp_get_acpi_resource does is to get specified
>type acpi resources and return. We also need to define some acpi resource
>types.
>
>ACPI_RESOURCE_DMA
>ACPI_RESOURCE_I2C_SERIALBUS
>ACPI_RESOURCE_SPI_SERIALBUS
>ACPI_RESOURCE_UART_SERIALBUS
>ACPI_RESOURCE_COMMON_SERIALBUS
>...
>
>How about this? welcome to comments.
>
>> Or should we use acpi_walk_resources() where 'struct resource' is not
>> suitable?
>>
>
>--
>Best Regards
>Tianyu Lan
>linux kernel enabling team
>--
>To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
