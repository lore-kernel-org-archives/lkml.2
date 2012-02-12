Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab2BLOQb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 09:16:31 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7262 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab2BLOQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 09:16:30 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 12 Feb 2012 06:16:29 -0800
Message-ID: <4F37C94E.5000504@nvidia.com>
Date: Sun, 12 Feb 2012 19:44:38 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V4 2/2] regmap: add regmap_bulk_write() for register write
References: <1329036556-15408-1-git-send-email-ldewangan@nvidia.com> <4F37A925.90507@metafoo.de> <20120212131101.GA3395@opensource.wolfsonmicro.com>
In-Reply-To: <20120212131101.GA3395@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 February 2012 06:41 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Sun, Feb 12, 2012 at 12:57:25PM +0100, Lars-Peter Clausen wrote:
>> On 02/12/2012 09:49 AM, Laxman Dewangan wrote:
>>> [...]
>>> +	} else {
>>> +		for (i = 0; i<  val_count; i++) {
>>> +			memcpy(&ival, val + (i * val_bytes), val_bytes);
>> This will have endianess issues. You'll need something like regcache_get_val.
The data pointer of this function is in cpu-endianess and so I am just 
copying it because regmap_write takes integer type value.
>>> +			ret = _regmap_write(map, reg + i, ival);
> Or just don't provide this fallback at all - it's not something the
> underlying device supports anyway and none of the other block or bulk
> operations work on these devices either.
Yaah, Seeing other function I think I can remove this fallback.

> * Unknown Key
> * 0x6E30FDDD

