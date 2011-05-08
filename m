Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab1EHNMu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 09:12:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52100 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab1EHNMr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 09:12:47 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTim2k_hb0Bw_cYeTUv-dMzyWVPO+gA@mail.gmail.com>
References: <1304795706-27308-1-git-send-email-per.forlin@linaro.org>
	<1304795706-27308-3-git-send-email-per.forlin@linaro.org>
	<BANLkTim2k_hb0Bw_cYeTUv-dMzyWVPO+gA@mail.gmail.com>
Date: Sun, 8 May 2011 15:12:46 +0200
Message-ID: <BANLkTindMsH4ozajW3E3ifBnrsS=gpOaOQ@mail.gmail.com>
Subject: Re: [PATCH v3 02/12] mmc: mmc_test: add debugfs file to list all tests
From: Per Forlin <per.forlin@linaro.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Chris Ball <cjb@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 May 2011 00:18, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> On Sat, May 7, 2011 at 10:14 PM, Per Forlin <per.forlin@linaro.org> wrote:
>> Add a debugfs file "testlist" to print all available tests
>>
>> Signed-off-by: Per Forlin <per.forlin@linaro.org>
>> ---
>>  drivers/mmc/card/mmc_test.c |   30 ++++++++++++++++++++++++++++++
>>  1 files changed, 30 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
>> index abc1a63..c1c3c5a 100644
>> --- a/drivers/mmc/card/mmc_test.c
>> +++ b/drivers/mmc/card/mmc_test.c
>
>
>> @@ -2476,6 +2502,10 @@ static int mmc_test_register_file_test(struct mmc_card *card)
>>                file = debugfs_create_file("test", S_IWUSR | S_IRUGO,
>>                        card->debugfs_root, card, &mmc_test_fops_test);
>>
>> +       if (card->debugfs_root)
>> +               file = debugfs_create_file("testlist", S_IRUGO,
>> +                       card->debugfs_root, card, &mmc_test_fops_testlist);
>> +
>>        if (IS_ERR_OR_NULL(file)) {
>>                dev_err(&card->dev,
>>                        "Can't create file. Perhaps debugfs is disabled.\n");
> I think you also need to use similar error path for both files: test
> and testlist.
Thanks, I'll fix that and add this check for both.

>
>
> --
> With Best Regards,
> Andy Shevchenko
>
Regards,
Per
