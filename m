Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab2E0KmV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 06:42:21 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:50189 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941Ab2E0KmR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 06:42:17 -0400
MIME-Version: 1.0
In-Reply-To: <87d35q1gjb.fsf@laptop.org>
References: <1337414319-27719-1-git-send-email-santosh.shilimkar@ti.com> <87d35q1gjb.fsf@laptop.org>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Sun, 27 May 2012 16:11:55 +0530
Message-ID: <CAMQu2gxH0e=Kdh5eABi3W07Rg_HNsCChUmNOtV4HmxYpQssmFA@mail.gmail.com>
Subject: Re: [PATCH] mmc: core: Fix build warning with !CONFIG_SUSPEND
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2012 at 8:22 AM, Chris Ball <cjb@laptop.org> wrote:
> Hi,
>
> On Sat, May 19 2012, Santosh Shilimkar wrote:
>> With !CONFIG_SUSPEND, mmc core layer throws below build warnings.
>>
>> drivers/mmc/core/bus.c:125: warning: 'mmc_bus_suspend' defined but not used
>> drivers/mmc/core/bus.c:136: warning: 'mmc_bus_resume' defined but not used
>> drivers/mmc/core/sdio_bus.c:197: warning: 'pm_no_operation' defined but not used
>>
>> Fix is by wrapping suspend hooks under CONFIG_SUSPEND
>>
>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> Cc: Chris Ball <cjb@laptop.org>
>> ---
>>  drivers/mmc/core/bus.c      |    2 ++
>>  drivers/mmc/core/sdio_bus.c |    2 +-
>>  2 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
>> index c60cee9..ca8925d 100644
>> --- a/drivers/mmc/core/bus.c
>> +++ b/drivers/mmc/core/bus.c
>> @@ -122,6 +122,7 @@ static int mmc_bus_remove(struct device *dev)
>>       return 0;
>>  }
>>
>> +#ifdef CONFIG_SUSPEND
>>  static int mmc_bus_suspend(struct device *dev)
>>  {
>>       struct mmc_driver *drv = to_mmc_driver(dev->driver);
>> @@ -143,6 +144,7 @@ static int mmc_bus_resume(struct device *dev)
>>               ret = drv->resume(card);
>>       return ret;
>>  }
>> +#endif
>>
>>  #ifdef CONFIG_PM_RUNTIME
>>
>> diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
>> index 236842e..87d1b7e 100644
>> --- a/drivers/mmc/core/sdio_bus.c
>> +++ b/drivers/mmc/core/sdio_bus.c
>> @@ -192,7 +192,7 @@ static int sdio_bus_remove(struct device *dev)
>>       return ret;
>>  }
>>
>> -#ifdef CONFIG_PM
>> +#ifdef CONFIG_SUSPEND
>>
>>  static int pm_no_operation(struct device *dev)
>>  {
>
> This patch doesn't apply against mmc-next, and I think this has already
> been fixed upstream -- please could you retest against Linus HEAD?
>
Indeed. It got fixed by commit 0dd1bfeb6.
Thanks for the update.

Regards
Santosh
