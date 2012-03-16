Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161949Ab2CPU67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 16:58:59 -0400
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:40633 "EHLO
	na3sys009amx257.postini.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161935Ab2CPU6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 16:58:55 -0400
Message-ID: <4F63A987.3@ti.com>
Date: Sat, 17 Mar 2012 02:28:47 +0530
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

Hi Greg,

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
>
>> +#ifndef __ASSEMBLY__
>
> Why is this needed?
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

I have fixed these comments and pushed my latest patches at:
git://github.com/aneeshv/linux.git
branch: emif-upstream-v4

thanks,
Aneesh

