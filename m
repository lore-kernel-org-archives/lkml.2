Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628Ab2DZAOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 20:14:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:47388 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932453Ab2DZAOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 20:14:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="133858362"
From: "Moore, Robert" <robert.moore@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lin, Ming M" <ming.m.lin@intel.com>
Subject: RE: Warning: pnp 00:0b: can't evaluate _CRS: 12311
Thread-Topic: Warning: pnp 00:0b: can't evaluate _CRS: 12311
Thread-Index: AQHNITY8ggyhHlhlsU+L3vOq3I8c0JaoxPuAgACoCICAAAZTgIACkBZQgAB5pQD//5XrAIAAfL6AgAACkoCAAAvyAP//oX6g
Date: Thu, 26 Apr 2012 00:14:50 +0000
Message-ID: <94F2FBAB4432B54E8AACC7DFDE6C92E346A779ED@ORSMSX101.amr.corp.intel.com>
References: <CA+icZUWVwUr19xL0Dn5mHnZjQaVjj6VYD3BMMktEWO0vgoZEXw@mail.gmail.com>
 <CA+icZUUGFaz0c-tHa9EGUxZaxPj_M=zrE+kE0dv5UMoA6GyN3w@mail.gmail.com>
 <CAErSpo5vZSf_EZr6-XnAA8N2Luv6rA92YtZsidWZCZ8rarkPUQ@mail.gmail.com>
 <CA+icZUU+asnLWAevwqKBgnvrmKNitL8-0+8ijDii4pt9VsjspA@mail.gmail.com>
 <94F2FBAB4432B54E8AACC7DFDE6C92E346A77806@ORSMSX101.amr.corp.intel.com>
 <CAErSpo5E3E=A+EEAZjmkYc8x3B==9ZtYufNaG4t8xQegtOfxfA@mail.gmail.com>
 <94F2FBAB4432B54E8AACC7DFDE6C92E346A77908@ORSMSX101.amr.corp.intel.com>
 <CAErSpo7Yj6_QZCSeNKXksiYayV53gkUubVBTnRRu8z1pyWeMQQ@mail.gmail.com>
 <CA+icZUVHO-7SXq3+qz1Gh3yrWtT+R15iiRG0DCLbcKn2PchVHA@mail.gmail.com>
 <CAErSpo4Jsx5C2JG6qtU=qnA6RFNH+H4mDajEuKgAFkAodakF3Q@mail.gmail.com>
In-Reply-To: <CAErSpo4Jsx5C2JG6qtU=qnA6RFNH+H4mDajEuKgAFkAodakF3Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>                Method (_CRS, 0, NotSerialized)
>                {
>                    If (IGDS)
>                    {
>                        Return (CRS)
>                    }
>                }
>            }
>
>I don't know whether this is legal or not.  If "(!IGDS)", _CRS
>apparently don't return anything at all, and I don't know what happens
>then.


Yes, it is illegal to return nothing from _CRS.

Newer versions of ACPICA (and iASL) will squawk at this, but we currently do not attempt to actually perform a runtime "repair".

The driver is probably getting an Integer object of value zero, which might explain the behavior seen.

Bob







>-----Original Message-----
>From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
>owner@vger.kernel.org] On Behalf Of Bjorn Helgaas
>Sent: Wednesday, April 25, 2012 3:49 PM
>To: sedat.dilek@gmail.com
>Cc: Moore, Robert; linux-acpi@vger.kernel.org; Len Brown; linux-
>kernel@vger.kernel.org; Lin, Ming M
>Subject: Re: Warning: pnp 00:0b: can't evaluate _CRS: 12311
>
>On Wed, Apr 25, 2012 at 4:06 PM, Sedat Dilek <sedat.dilek@googlemail.com>
>wrote:
>> On Wed, Apr 25, 2012 at 11:57 PM, Bjorn Helgaas <bhelgaas@google.com>
>wrote:
>>> On Wed, Apr 25, 2012 at 3:39 PM, Moore, Robert <robert.moore@intel.com>
>wrote:
>>>> This disassembly might make more sense. From the looks of the ASL,
>several of the address base and length fields are being updated
>dynamically.  I don't see anything that would corrupt a resource
>descriptor, however.
>>>>
>>>>
>>>> Are we certain that the ACPI Error and pnp messages are directly
>related to the PNP0C02 device ID?
>>>>
>>>> [    0.293699] system 00:0a: Plug and Play ACPI device, IDs PNP0c02
>(active)
>>>> [    0.294032] ACPI Error: Invalid/unsupported resource descriptor:
>Type 0x00 (20120320/utresrc-650)
>>>> [    0.294037] pnp 00:0b: can't evaluate _CRS: 12311
>>>
>>> Oh, I'm sorry, I just wasted your time.  I didn't notice the 0a/0b
>>> mismatch.  You're right, the _CRS error is on 00:0b, and we don't know
>>> what the path is or the PNP ID for 00:0b.
>>>
>>> Sedat, can you run "grep . /sys/bus/pnp/devices/*/id" please?  That
>>> will at least show us the PNP ID of device 00:0b.
>>>
>>> Bjorn
>>
>> Here we go:
>> ...
>> /sys/bus/pnp/devices/00:0b/id:PNP0c01
>
>There's only one PNP0C01 device:
>
>            Device (^^MEM2)
>            {
>                Name (_HID, EisaId ("PNP0C01"))
>                Name (_UID, 0x02)
>                Name (CRS, ResourceTemplate ()
>                {
>                    Memory32Fixed (ReadWrite,
>                        0x20000000,         // Address Base
>                        0x00200000,         // Address Length
>                        )
>                    Memory32Fixed (ReadWrite,
>                        0x40000000,         // Address Base
>                        0x00200000,         // Address Length
>                        )
>                })
>                Method (_CRS, 0, NotSerialized)
>                {
>                    If (IGDS)
>                    {
>                        Return (CRS)
>                    }
>                }
>            }
>
>I don't know whether this is legal or not.  If "(!IGDS)", _CRS
>apparently don't return anything at all, and I don't know what happens
>then.
>--
>To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
