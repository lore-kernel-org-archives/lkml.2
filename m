Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab2GBP4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 11:56:12 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:36548 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2GBP4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 11:56:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAK5ve-JaNGoWuCTP5ddMEEfpA3ucWNL_ayj5ULU3+++5a02pWw@mail.gmail.com>
References: <1341218420-22377-1-git-send-email-devendra.aaru@gmail.com>
	<CAK5ve-JaNGoWuCTP5ddMEEfpA3ucWNL_ayj5ULU3+++5a02pWw@mail.gmail.com>
Date: Mon, 2 Jul 2012 21:26:09 +0530
Message-ID: <CAHdPZaNDW+XCrf9Mse-N3jtgtrrx9Z0+W1YZX8nPETa7ZZFB1w@mail.gmail.com>
Subject: Re: [PATCH] leds-mc13783: set platform data to NULL at mc13783_led_remove
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 2, 2012 at 7:23 PM, Bryan Wu <bryan.wu@canonical.com> wrote:
> On Mon, Jul 2, 2012 at 4:40 PM, Devendra Naga <devendra.aaru@gmail.com> wrote:
>> the platform_set_drvdata (pdev, NULL) to be set at the remove of the
>> driver, as we have set the platform data to led at probe.
>>
>> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
>
> Nice catch. I applied this patch in my for-next branch.
>
> But I also find the same issue in other LED drivers, are you
> interested in fixing them?
>
Yes, i will do those.
I will send out changes...
> Thanks,
> -Bryan
>

Thanks
>> ---
>>  drivers/leds/leds-mc13783.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/leds/leds-mc13783.c b/drivers/leds/leds-mc13783.c
>> index 4cc6a2e..6515c11 100644
>> --- a/drivers/leds/leds-mc13783.c
>> +++ b/drivers/leds/leds-mc13783.c
>> @@ -372,6 +372,7 @@ static int __devexit mc13783_led_remove(struct platform_device *pdev)
>>
>>         mc13xxx_unlock(dev);
>>
>> +       platform_set_drvdata(pdev, NULL);
>>         kfree(led);
>>         return 0;
>>  }
>> --
>> 1.7.9.5
>>
>
>
>
> --
> Bryan Wu <bryan.wu@canonical.com>
> Kernel Developer    +86.186-168-78255 Mobile
> Canonical Ltd.      www.canonical.com
> Ubuntu - Linux for human beings | www.ubuntu.com
