Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab2JHGcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 02:32:04 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16094 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab2JHGcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 02:32:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 07 Oct 2012 23:29:49 -0700
Message-ID: <50726B84.4020603@nvidia.com>
Date: Mon, 8 Oct 2012 11:28:28 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "axel.lin@gmail.com" <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] regulator: tps65090: add external control support
 for DCDC
References: <1349536671-31714-1-git-send-email-ldewangan@nvidia.com> <1349536671-31714-7-git-send-email-ldewangan@nvidia.com> <D958900912E20642BCBC71664EFECE3E6DDF8AF38E@BGMAIL02.nvidia.com>
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DDF8AF38E@BGMAIL02.nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 October 2012 11:15 AM, Venu Byravarasu wrote:
>> -----Original Message-----
>> From: Laxman Dewangan
>> Sent: Saturday, October 06, 2012 8:48 PM
>> To: broonie@opensource.wolfsonmicro.com; lrg@ti.com;
>> sameo@linux.intel.com
>> Cc: Venu Byravarasu; axel.lin@gmail.com; linux-kernel@vger.kernel.org;
>> Laxman Dewangan
>> Subject: [PATCH 5/5] regulator: tps65090: add external control support for
>> DCDC
>>
>>
>>   static int tps65090_voltage_get_voltage(struct regulator_dev *rdev)
>>   {
>>   	struct tps65090_regulator *ri = rdev_get_drvdata(rdev);
>> @@ -54,12 +67,17 @@ static int tps65090_voltage_list_voltage(struct
>> regulator_dev *rdev,
>>   	return ri->microvolts;
>>   }
>>
>> -static struct regulator_ops tps65090_ops = {
>> +static struct regulator_ops tps65090_ext_control_ops = {
> Where tps65090_ext_control_ops are used?
>


It is used when external control is enabled.
I have the code as
ri->desc->ops = &tps65090_ext_control_ops;
