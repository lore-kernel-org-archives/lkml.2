Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab2BIMq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 07:46:59 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10342 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab2BIMq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 07:46:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 09 Feb 2012 04:46:57 -0800
Message-ID: <4F33BFDE.7020006@nvidia.com>
Date: Thu, 9 Feb 2012 18:15:18 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1] regmap: add bulk_write() for non-volatile register
 set
References: <1328789531-10067-1-git-send-email-ldewangan@nvidia.com> <20120209121704.GF3058@opensource.wolfsonmicro.com>
In-Reply-To: <20120209121704.GF3058@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 February 2012 05:47 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Thu, Feb 09, 2012 at 05:42:11PM +0530, Laxman Dewangan wrote:
>
>> +	if (vol || map->cache_type == REGCACHE_NONE) {
>> +		ret = _regmap_raw_write(map, reg, val, val_bytes * val_count);
> You still need to do the byte swap here.
I saw the regmap_raw_write() and it is using the same way without byte 
swapping.
Want to use the same function as it is.. I am not sure why do we require 
byte-swapping in this case. Required things will be done by 
_regmap_raw_write only.
This api just break the transfer in register-wise if any of the register 
is cached..

>> +	} else {
>> +		for (i = 0; i<  val_count; i++) {
>> +			memcpy(map->work_buf, val + (i * val_bytes), val_bytes);
>> +			ival = map->format.parse_val(map->work_buf);
> They're currently symmetric but really this should use format_val().
>
The format_val is require integer argument and issue is that I dont have 
this otherwise I need not to parse, can use directly.

Am I missing something here?


> * Unknown Key
> * 0x6E30FDDD

