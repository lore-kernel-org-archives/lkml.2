Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab2IGNPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:15:40 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16795 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab2IGNPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:15:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 07 Sep 2012 06:15:36 -0700
Message-ID: <5049EDCD.4050805@nvidia.com>
Date: Fri, 7 Sep 2012 18:21:25 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>,
        "rabin.vincent@gmail.com" <rabin.vincent@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3] regulator: disable supply regulator if it is enabled
 for boot-on
References: <1346682339-13322-1-git-send-email-ldewangan@nvidia.com> <20120907015900.GC6827@opensource.wolfsonmicro.com>
In-Reply-To: <20120907015900.GC6827@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012 07:29 AM, Mark Brown wrote:
> On Mon, Sep 03, 2012 at 07:55:39PM +0530, Laxman Dewangan wrote:
>
>> +	/* If supply enabled during registrtaion then need to disable
>> +	 * when full constraint enabled.
>> +	 */
>> +	unsigned int need_supply_disable:1;
> I don't understand why we need this flag.  Shouldn't we just be making
> the reference counts for the supplies correct and then have the
> regulator disabled in the late initcall as a result of its refcount
> falling to zero when the children are disabled?
Here we are trying to call the supply disable if child refcount become 0.
So when child calls disable, it need to call the supply disable also.

>   I think what we need to
> do here is always take a reference to the supply if the child is enabled
> during boot, then in the initcall we can just disable the parent
> regulator as normal.
My second patch was similar but Rabin has some issue to handle the case 
when is_regulator_enable() is not implementd by regulator device driver.

