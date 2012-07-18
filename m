Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab2GRBsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 21:48:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60475 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab2GRBsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 21:48:06 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-4f-500615d4da2d
Message-id: <500615D4.1020002@samsung.com>
Date: Wed, 18 Jul 2012 10:48:04 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: thomas.abraham@linaro.org, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, sameo@linux.intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 1/2] mfd: add irq domain support for max8997
 interrupts
References: <1341187375-16333-1-git-send-email-cw00.choi@samsung.com>
 <20120717163427.GA3756@kroah.com>
In-reply-to: <20120717163427.GA3756@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t9jAd0romwBBgvuilhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MP7vXMhZsFKy4u2wWawPjV94uRk4OCQETieOnj7JC2GISF+6t
	Z+ti5OIQEljEKPF/zWkWkISQQBeTxIdWQRCbV0BLYu/dY+xdjBwcLAKqEp+PKYGE2YDC+1/c
	YAMJiwpESPzq54CoFpT4Mfke2BQRAQ2Jl0dvsYCMZxY4zSjxsGEeI0hCWCBE4vGkVUwQqzIl
	Zt59A9bAKaAncfnhTXYQm1lAR2J/6zQ2CFteYvOat8wTGAVmIdkxC0nZLCRlCxiZVzGKphYk
	FxQnpeca6RUn5haX5qXrJefnbmIEh98z6R2MqxosDjEKcDAq8fB+EGYLEGJNLCuuzD3EKMHB
	rCTCK/icNUCINyWxsiq1KD++qDQntfgQozQHi5I4r4n3V38hgfTEktTs1NSC1CKYLBMHp1QD
	Y+63C7a5G3Ml9jyqPShXm17GdkOuc9bk3HJhzx0lunUXLkzy73pyolAqIT5girJ6Scrjbw4b
	K05xd12bsC7y8KIA6ycVOwQ3ZOgJNepkfj2rJLnA1C5JxzPPV7mmuXWJr8z8xrvnTHzmTXr+
	9knItbU2k1evSm+92Fn6NDjMvu7tae5zn7r4lViKMxINtZiLihMB7OEP9jsCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2012 01:34 AM, Greg KH wrote:

> On Mon, Jul 02, 2012 at 09:02:55AM +0900, Chanwoo Choi wrote:
>> From: Thomas Abraham <thomas.abraham@linaro.org>
>>
>> Add irq domain support for max8997 interrupts. The reverse mapping method
>> used is linear mapping since the sub-drivers of max8997 such as regulator
>> and charger drivers can use the max8997 irq_domain to get the linux irq
>> number for max8997 interrupts. All uses of irq_base in platform data and
>> max8997 driver private data are removed.
>>
>> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
>> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>> Acked-by: Samuel Ortiz <sameo@linux.intel.com>
>> 	[Fix two bug which set max8997->irq_domain and correct wrong parameter]
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  arch/arm/mach-exynos/mach-nuri.c    |    4 --
>>  arch/arm/mach-exynos/mach-origen.c  |    1 -
>>  drivers/mfd/Kconfig                 |    1 +
>>  drivers/mfd/max8997-irq.c           |   62 +++++++++++++++++++++--------------
>>  drivers/mfd/max8997.c               |    1 -
>>  include/linux/mfd/max8997-private.h |    4 ++-
>>  include/linux/mfd/max8997.h         |    1 -
>>  7 files changed, 41 insertions(+), 33 deletions(-)
> 
> Once again, this patch breaks the build.
> 
> Please be more careful with your patches, and TEST THEM BEFORE SENDING
> THEM OUT.
> 


I have posted patchset including below two patch. If only first patch is
applied to build test, this patch breaks the build. The second patch fix
that extcon-max8997 driver use irq_domain instead of irq_base field in
'struct max8997_dev'.

[PATCH v3 1/2] mfd: add irq domain support for max8997 interrupts
[PATCH v3 2/2] Extcon: MAX8997: Add support irq domain for MAX8997 muic

Please apply second patch when test this patchset.

Sorry, I didn't consolidate second patch in the first patch to resolve
build break because of converting  MUIC driver of MAX8997
from 'max8997-muic.c' to 'extcon-max8997.c'.

- http://lkml.org/lkml/2012/5/20/142

Best Regards,
Chanwoo Choi
