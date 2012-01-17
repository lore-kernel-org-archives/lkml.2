Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab2AQTst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 14:48:49 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39535 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab2AQTss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 14:48:48 -0500
Message-ID: <4F15D09D.3030401@gmail.com>
Date: Tue, 17 Jan 2012 13:48:45 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Stephen Warren <swarren@nvidia.com>
CC: "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Dong Aisheng <dongas86@gmail.com>
Subject: Re: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
References: <7FE21149F4667147B645348EC6057885075542@039-SN2MPN1-013.039d.mgd.msft.net> <74CDBE0F657A3D45AFBB94109FB122FF176CC743EF@HQMAIL01.nvidia.com> <CAA+hA=RBqpSmntS2h+6xMQuRvSRHenmDgrYSSzMXHtOCpU+HCQ@mail.gmail.com> <74CDBE0F657A3D45AFBB94109FB122FF17761F18F8@HQMAIL01.nvidia.com> <7FE21149F4667147B645348EC605788507F698@039-SN2MPN1-013.039d.mgd.msft.net> <74CDBE0F657A3D45AFBB94109FB122FF177EE39E6B@HQMAIL01.nvidia.com> <7FE21149F4667147B645348EC605788508AC65@039-SN2MPN1-013.039d.mgd.msft.net> <74CDBE0F657A3D45AFBB94109FB122FF177EE3A76A@HQMAIL01.nvidia.com> <CAA+hA=RCmctmQJU4-k7YhzQDMi8KuyisBqOFhuMd3RV4_E=gCA@mail.gmail.com> <74CDBE0F657A3D45AFBB94109FB122FF17801D1FAB@HQMAIL01.nvidia.com> <20120114011029.GC1810@S2101-09.ap.freescale.net> <74CDBE0F657A3D45AFBB94109FB122FF17801D22FB@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17801D22FB@HQMAIL01.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2012 01:35 PM, Stephen Warren wrote:
> Shawn Guo wrote at Friday, January 13, 2012 6:11 PM:
>> On Fri, Jan 13, 2012 at 10:33:21AM -0800, Stephen Warren wrote:
>>> So of_device_alloc(), which is called by of_platform_populate() for each
>>> device, already parses basic DT content such as reg and interrupts, and
>>> converts them to Linux resources. I'd consider parsing any pinmux properties
>>> and registering them with the pinctrl subsystem to be of a similar nature,
>>> so adding some code to of_device_alloc() that calls a core pinmux function
>>> to parse the DT node seems reasonable to me.
>>
>> I hardly believe that device tree maintainers would agree here.
>> Grant, Rob?
> 
> I'm explicitly putting Grant and Rob on the To line here to make this
> question stand out to them.
> 

But then the same could be argued for regulators, clocks and whatever
else infrastructure type bindings we have. I think the distinction here
is reg and interrupts are already standard properties of
platform_devices. As I believe Linus W said, all the pin mux/ctrl stuff
has to work for non-DT as well. So if the infrastructure is handling
this for DT, how would this work in the non-DT case?

There are already ways to hook into the device creation with bus notifiers.

Rob
