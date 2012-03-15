Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161344Ab2COT46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 15:56:58 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:40295 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032198Ab2COT4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 15:56:55 -0400
Message-ID: <4F62497F.1020907@ti.com>
Date: Fri, 16 Mar 2012 01:26:47 +0530
From: Aneesh V <aneesh@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 1/7] misc: ddr: add LPDDR2 data from JESD209-2
References: <1331835457-5390-1-git-send-email-aneesh@ti.com> <1331835457-5390-2-git-send-email-aneesh@ti.com> <20120315190238.GD11142@kroah.com>
In-Reply-To: <20120315190238.GD11142@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 March 2012 12:32 AM, Greg KH wrote:
> On Thu, Mar 15, 2012 at 11:47:31PM +0530, Aneesh V wrote:
>> add LPDDR2 data from the JEDEC spec JESD209-2. The data
>> includes:
>>
>> 1. Addressing information for LPDDR2 memories of different
>>     densities and types(S2/S4)
>> 2. AC timing data.
>>
>> This data will useful for memory controller device drivers
>
> Right now, only one driver, right?

Yes, should that be documented?

>
>> +#ifndef __ASSEMBLY__
>
> Why is this needed?

IIRC, this header file was getting included in an omap specific header
file that was in turn included from an assembly file. I will check if
this is still the case. If not, I will remove it.

>
>> +/* Structure for DDR addressing info from the JEDEC spec */
>> +struct lpddr2_addressing {
>> +	u32 num_banks;
>> +	u32 tREFI_ns;
>> +	u32 tRFCab_ps;
>> +};
>
> Do these structures cross the user/kernel boundry somehow?  If so,
> please use the proper kernel types for this.

No. These structures are meant for use by device drivers.

>
>> --- a/lib/Makefile
>> +++ b/lib/Makefile
>> @@ -123,6 +123,9 @@ obj-$(CONFIG_SIGNATURE) += digsig.o
>>
>>   obj-$(CONFIG_CLZ_TAB) += clz_tab.o
>>
>> +obj-$(CONFIG_DDR) += jedec_ddr_data.o
>> +
>> +
>
> Why the extra line?

Un-intentional. Will remove.

>
>>   hostprogs-y	:= gen_crc32table
>>   clean-files	:= crc32table.h
>>
>> diff --git a/lib/jedec_ddr_data.c b/lib/jedec_ddr_data.c
>> new file mode 100644
>> index 0000000..fc223d6
>> --- /dev/null
>> +++ b/lib/jedec_ddr_data.c
>> @@ -0,0 +1,135 @@
>> +/*
>> + * DDR addressing details and AC timing parameters from JEDEC specs
>> + *
>> + * Copyright (C) 2012 Texas Instruments, Inc.
>> + *
>> + * Aneesh V<aneesh@ti.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include<misc/jedec_ddr.h>
>> +#include<linux/module.h>
>> +
>> +/* LPDDR2 addressing details from JESD209-2 section 2.4 */
>> +const struct lpddr2_addressing
>> +	lpddr2_jedec_addressing_table[NUM_DDR_ADDR_TABLE_ENTRIES] = {
>> +	{B4, T_REFI_15_6, T_RFC_90}, /* 64M */
>> +	{B4, T_REFI_15_6, T_RFC_90}, /* 128M */
>> +	{B4, T_REFI_7_8,  T_RFC_90}, /* 256M */
>> +	{B4, T_REFI_7_8,  T_RFC_90}, /* 512M */
>> +	{B8, T_REFI_7_8, T_RFC_130}, /* 1GS4 */
>> +	{B8, T_REFI_3_9, T_RFC_130}, /* 2GS4 */
>> +	{B8, T_REFI_3_9, T_RFC_130}, /* 4G */
>> +	{B8, T_REFI_3_9, T_RFC_210}, /* 8G */
>> +	{B4, T_REFI_7_8, T_RFC_130}, /* 1GS2 */
>> +	{B4, T_REFI_3_9, T_RFC_130}, /* 2GS2 */
>> +};
>> +EXPORT_SYMBOL(lpddr2_jedec_addressing_table);
>
> EXPORT_SYMBOL_GPL for these and the others?

Will fix all.

Thanks,
Aneesh
