Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab2GFPyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 11:54:53 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:53980 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab2GFPyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 11:54:52 -0400
Message-ID: <4FF70A49.3040802@gmail.com>
Date: Fri, 06 Jul 2012 11:54:49 -0400
From: Daniel Hazelton <dshadowwolf@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Kyungmin Park <kmpark@infradead.org>
CC: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] staging: ccg: print MAC addresses via %pM
References: <1341588498-21689-1-git-send-email-andriy.shevchenko@linux.intel.com> <1341588498-21689-6-git-send-email-andriy.shevchenko@linux.intel.com> <CAH9JG2XzWS_PF8E4V2bHjq=PtTMEtdDcm1Q03GxK8h4E28Rpjw@mail.gmail.com>
In-Reply-To: <CAH9JG2XzWS_PF8E4V2bHjq=PtTMEtdDcm1Q03GxK8h4E28Rpjw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2012 11:32 AM, Kyungmin Park wrote:
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>
> On Sat, Jul 7, 2012 at 12:28 AM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/staging/ccg/ccg.c |    8 ++------
>>  1 file changed, 2 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/staging/ccg/ccg.c b/drivers/staging/ccg/ccg.c
>> index a5b36a9..62f5d92 100644
>> --- a/drivers/staging/ccg/ccg.c
>> +++ b/drivers/staging/ccg/ccg.c
>> @@ -564,9 +564,7 @@ static int rndis_function_bind_config(struct ccg_usb_function *f,
>>                 return -1;
>>         }
>>
>> -       pr_info("%s MAC: %02X:%02X:%02X:%02X:%02X:%02X\n", __func__,
>> -               rndis->ethaddr[0], rndis->ethaddr[1], rndis->ethaddr[2],
>> -               rndis->ethaddr[3], rndis->ethaddr[4], rndis->ethaddr[5]);
>> +       pr_info("%s MAC: pM\n", __func__, rndis->ethaddr);
You lost a % there - it should be "%s MAC: %pM\n", no ?

DRH
>>
>>         ret = gether_setup_name(c->cdev->gadget, rndis->ethaddr, "rndis");
>>         if (ret) {
>> @@ -654,9 +652,7 @@ static ssize_t rndis_ethaddr_show(struct device *dev,
>>  {
>>         struct ccg_usb_function *f = dev_get_drvdata(dev);
>>         struct rndis_function_config *rndis = f->config;
>> -       return sprintf(buf, "%02x:%02x:%02x:%02x:%02x:%02x\n",
>> -               rndis->ethaddr[0], rndis->ethaddr[1], rndis->ethaddr[2],
>> -               rndis->ethaddr[3], rndis->ethaddr[4], rndis->ethaddr[5]);
>> +       return sprintf(buf, "%pM\n", rndis->ethaddr);
>>  }
>>
>>  static ssize_t rndis_ethaddr_store(struct device *dev,
>> --
>> 1.7.10.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


