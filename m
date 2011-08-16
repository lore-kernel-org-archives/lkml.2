Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab1HPX1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 19:27:11 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38889 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab1HPX1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 19:27:10 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6440"; a="110614362"
Message-ID: <4E4AFCC9.7020109@codeaurora.org>
Date: Tue, 16 Aug 2011 17:27:05 -0600
From: Kenneth Heitke <kheitke@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100722 Eudora/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: sdharia@codeaurora.org, David Brown <davidb@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        bryanh@codeaurora.org, linux-arm-msm@vger.kernel.org,
        rdunlap@xenotime.net, rmk+kernel@arm.linux.org.uk,
        john.stultz@linaro.org, akpm@linux-foundation.org, ohad@wizery.com,
        gregkh@suse.de, stefanr@s5r6.in-berlin.de, lethal@linux-sh.org,
        linville@tuxdriver.com, zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org> <4E4AA52E.1070706@codeaurora.org> <0446c62c2d4a2c60442c582b4f61f5d3.squirrel@www.codeaurora.org> <4380004.YTvKt3Mlxd@wuerfel>
In-Reply-To: <4380004.YTvKt3Mlxd@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2011 01:49 PM, Arnd Bergmann wrote:
> On Tuesday 16 August 2011 10:44:35 sdharia@codeaurora.org wrote:
>>>
>>> SLIMbus is a MIPI standard bus primarily used for digital audio devices.
>>>    The devices on the bus SLIMbus enumerate themselves by sending an
>>> IDENTITY message.  I'll let Sagar clarify further.
>>
>> Thanks everyone for taking your time to review the RFC.
>> Regarding device discovery:
>> Every device sends a "PRESENT" message when it comes up. Every device has
>> 48-bit address like Ethernet and spec lets upto 256 devices (each getting
>> 8-bit logical address) on one bus.
>> The device can report anytime (when it's plugged in, when a dynamic module
>> powers it on etc.)
>> Typical use case will be to have it board-specific but as Mark
>> mentioned,we may have plug-in cards with slimbus devices so we want
>> dynamic support as well.
>
> Thanks for the info. The part that I still don't understand is how the
> 48-bit address and the 8 bit address are chosen. Do you mean that
> the 8-bit address identifies the location on the bus and is used
> when talking to the device locally while the 48-bit address is globally
> unique and different for each individual board?
>
> In that case, we would still not have any way to identify the type
> of device, other than using a look-up table of 8-bit addresses to
> device names (or numbers).
>
> Or does the 48-bit number actually tell us something about what
> device we're talking to, e.g. 24 bit vendor plus 24 bit device
> type and revision or such. If that's the case, the number needs
> to be the primary key that gets used to identify the driver,
> just like we do it in case of USB or PCI devices.
>
> 	Arnd
>

The 8-bit address is a logical address that is assigned by the SLIMbus 
framework.  The framework maintains the mapping of logical addresses to 
the 48-bit Enumeration Address (EA).  The 8-bit logical address is then 
used for any further SLIMbus device addressing.

The slim_get_logical_addr() API call is used by the client drivers to 
get the logical address that has been assigned to the device.

For the proposed implementation, the client drivers are probed before 
their devices are discovered because the client driver may need to 
power-up the device or pull it out of reset.  Once the device is powered 
up, the call to get_logical_address() will let the client know whether 
or not their device has enumerated.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
