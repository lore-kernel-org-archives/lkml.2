Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab2K0F27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 00:28:59 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62906 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab2K0F25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 00:28:57 -0500
Message-ID: <50B44FB3.5090308@linaro.org>
Date: Tue, 27 Nov 2012 10:59:23 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        wim@iguana.be, patches@linaro.org, Anthony.Olech@diasemi.com
Subject: Re: [PATCH] watchdog: da9052: Fix invalid free of devm_ allocated
 data
References: <1353559384-26570-1-git-send-email-tushar.behera@linaro.org> <CAM=Q2csrtLOCvQpkSfLfE3teCYU1GUzdVaBpuWwocLy2j-9Wuw@mail.gmail.com>
In-Reply-To: <CAM=Q2csrtLOCvQpkSfLfE3teCYU1GUzdVaBpuWwocLy2j-9Wuw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 06:31 PM, Shubhrajyoti Datta wrote:
> On Thu, Nov 22, 2012 at 10:13 AM, Tushar Behera
> <tushar.behera@linaro.org> wrote:
>> It is not required to free devm_ allocated data. Since kref_put
>> needs a valid release function, da9052_wdt_release_resources()
>> is not deleted.
>>
>> Fixes following warning.
>> drivers/watchdog/da9052_wdt.c:59:1-6: WARNING: invalid free of
>> devm_ allocated data
>>
>> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
>> ---
>>  drivers/watchdog/da9052_wdt.c |    4 ----
>>  1 files changed, 0 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/watchdog/da9052_wdt.c b/drivers/watchdog/da9052_wdt.c
>> index f7abbae..20071de 100644
>> --- a/drivers/watchdog/da9052_wdt.c
>> +++ b/drivers/watchdog/da9052_wdt.c
>> @@ -53,10 +53,6 @@ static const struct {
>>
>>  static void da9052_wdt_release_resources(struct kref *r)
>>  {
>> -       struct da9052_wdt_data *driver_data =
>> -               container_of(r, struct da9052_wdt_data, kref);
>> -
>> -       kfree(driver_data);
> 
> However now the function will be empty right?
> 
> 

Yes, the function would be empty now. It is kept just to avoid the
run-time warning.

>>  }
>>
>>  static int da9052_wdt_set_timeout(struct watchdog_device *wdt_dev,
>> --
>> 1.7.4.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Tushar Behera
