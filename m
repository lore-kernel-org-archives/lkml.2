Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab1IVT26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 15:28:58 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34916 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab1IVT2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 15:28:54 -0400
Message-ID: <4E7B8C68.7020407@ti.com>
Date: Thu, 22 Sep 2011 21:28:40 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>
CC: "Munegowda, Keshava" <keshava_mgowda@ti.com>,
        "parthab@india.ti.com" <parthab@india.ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>, "Gadiyar, Anand" <gadiyar@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "Hilman, Kevin" <khilman@ti.com>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "Sripathy, Vishwanath" <vishwanath.bs@ti.com>
Subject: Re: [PATCH 1/5 v11] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
References: <1316691479-1849-1-git-send-email-keshava_mgowda@ti.com> <1316691479-1849-2-git-send-email-keshava_mgowda@ti.com> <alpine.DEB.2.00.1109221213500.10719@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.1109221213500.10719@utopia.booyaka.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 9/22/2011 8:14 PM, Paul Walmsley wrote:
> Hi
>
> On Thu, 22 Sep 2011, Keshava Munegowda wrote:
>
>> Following 4 hwmod structures are added
>> 1. usb_host_hs hwmod of usbhs with uhh base address and functional clock,
>> 2. usb_ehci_hs hwmod with irq and base address,
>> 3. usb_ohci_hs hwmod with irq and base address,
>>     - The ehci and ohci hwmods does not require functional clock
>>       because usb_host_hs has functional clock which is sufficient
>>       to access ehci and ohci address space.
>>     - The usb_ehci_hs and usb_ohci_hs should be two separate hwmods
>>       which should not be combined. This is needed because ehci and
>>       ohci will have separate dedicated ports&  in omap4 there is a
>>       clock per port.We should be able to configure the IO-Wakeup
>>       capability of pins specific to EHCI&  OHCI separately and depending
>>       on the I/O wakeup event  the  only port clocks corresponding
>>       to the wakeup source will be enabled internally by the usb host driver.
>>
>> 4. usb_tll_hs hwmod of usbhs with the TLL base address and irq.
>
> Many of the same issues with the OMAP3 data (missing main_clks, missing
> ADDR_TYPE_RT, etc.) exist with this patch also.

ADDR_TYPE_RT is mainly use for sysconfig access inside hwmod core today, 
so why should we use it in this case?
To be honest, I've been confused with that flag for some time :-)
  * ADDR_TYPE_RT: Address space contains module register target data.
Maybe that's my English, but what does "register target data" mean exactly?
What was the intent? Providing a way to identify some register vs memory 
space?

Regarding main_clk, I do not think that some internal IPs like ohci/ehci 
should have a main_clk, since this is not visible at that level. These 
blocks do not have any PRCM / OCP connection. In fact they should not 
even be hwmod in theory, these are just some internal IPs inside the 
usb_host controller.
These are hwmods just because of the dynamic mux support needed by these 
IPs.
That was one of the comments I made on these, and Keshava explained me 
the rational and added it in the changelog.
Hopefully, we will not have that limitation once we will have migrated 
that to DT :-)


Regards,
Benoit


