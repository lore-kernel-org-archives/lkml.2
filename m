Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab2EBGuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 02:50:32 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:57593 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753926Ab2EBGu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 02:50:29 -0400
Message-ID: <4FA0D930.3080806@ti.com>
Date: Wed, 02 May 2012 12:20:24 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 0/7] Add TI EMIF SDRAM controller driver
References: <y> <1335529449-28046-1-git-send-email-santosh.shilimkar@ti.com> <20120502051623.GA23705@kroah.com>
In-Reply-To: <20120502051623.GA23705@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

On Wednesday 02 May 2012 10:46 AM, Greg KH wrote:
> On Fri, Apr 27, 2012 at 05:54:02PM +0530, Santosh Shilimkar wrote:
>> Add a driver for the EMIF SDRAM controller used in Texas Instrument SoCs
>>
>> EMIF is an SDRAM controller that supports, based on its revision,
>> one or more of LPDDR2/DDR2/DDR3 protocols.This driver adds support
>> for LPDDR2.
>>
>> The driver supports the following features:
>> - Calculates the DDR AC timing parameters to be set in EMIF
>>   registers using data from the device data-sheets and based
>>   on the DDR frequency. If data from data-sheets is not available
>>   default timing values from the JEDEC spec are used. These
>>   will be safe, but not necessarily optimal
>> - API for changing timings during DVFS or at boot-up
>> - Temperature alert configuration and handling of temperature
>>   alerts, if any for LPDDR2 devices
>>   * temperature alert is based on periodic polling of MR4 mode
>>     register in DDR devices automatically performed by hardware
>>   * timings are de-rated and brought back to nominal when
>>     temperature raises and falls respectively
>> - Cache of calculated register values to avoid re-calculating
>>   them
>>
>> The driver will need some minor updates when it is eventually
>> integrated with Dynamic Voltage and Frequency Scaling (DVFS).
>> This can not be done now as DVFS support is not available in
>> the mainline yet.
>>
>> Discussions with Santosh Shilimkar <santosh.shilimkar@ti.com>
>> were immensely helpful in shaping up the interfaces. Vibhore Vardhan
>> <vvardhan@gmail.com> did the initial code snippet for thermal
>> handling.
>>
>> Testing: 
>> - The driver is tested on OMAP4430 SDP.
>> - The driver in a slightly adapted form is also tested on OMAP5.
>> - Since mainline kernel doesn't have DVFS support yet,
>>   testing was done using a test module.
>> - Temperature alert handling was tested with simulated interrupts
>>   and faked temperature values as testing all cases in real-life
>>   scenarios is difficult.
>> - Tested the driver as a module
>>
>> Cc: Greg KH <greg@kroah.com>
> 
> This all looks good to me now, thanks for reworking this.
> 
> So, do you want me to take this through my "driver" tree to get to Linus
> for 3.5, or do you want it to go through somewhere else?
> 
> If somewhere else, that's fine with me, consider this an:
> 	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> If you want me to take it, just let me know, whichever you prefer is
> fine with me.
> 
Can you take this one through your 3.5 driver tree please ?
Thanks for help.

Regards
Santosh


