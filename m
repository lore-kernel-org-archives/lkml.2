Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab0IAIZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 04:25:19 -0400
Received: from smtp.nokia.com ([192.100.105.134]:34759 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab0IAIZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 04:25:15 -0400
Message-ID: <4C7E0DFA.2090403@nokia.com>
Date: Wed, 01 Sep 2010 11:25:30 +0300
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: ext Andy Shevchenko <andy.shevchenko@gmail.com>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Hunter Adrian (Nokia-MS/Helsinki)" <adrian.hunter@nokia.com>,
        "Shevchenko Andriy (EXT-Teleca/Helsinki)" 
	<ext-andriy.shevchenko@nokia.com>
Subject: Re: [PATCH 2/3] mmc_test: change simple_strtol() to strict_strtol()
References: <cover.1283276161.git.ext-andriy.shevchenko@nokia.com> <e144c2087fbdfd718b5caeac4eb7d0a7ce4896e0.1283276161.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <e144c2087fbdfd718b5caeac4eb7d0a7ce4896e0.1283276161.git.ext-andriy.shevchenko@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Sep 2010 08:24:32.0496 (UTC) FILETIME=[1A9F8F00:01CB49AF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/01/2010 09:26 AM, ext Andy Shevchenko wrote:

No patch summary?
> Signed-off-by: Andy Shevchenko<ext-andriy.shevchenko@nokia.com>
> ---
>   drivers/mmc/card/mmc_test.c |   12 +++++++-----
>   1 files changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
> index 359fae9..5423ac9 100644
> --- a/drivers/mmc/card/mmc_test.c
> +++ b/drivers/mmc/card/mmc_test.c
> @@ -1836,9 +1836,10 @@ static const struct mmc_test_case mmc_test_cases[] = {
>
>   static DEFINE_MUTEX(mmc_test_lock);
>
> -static void mmc_test_run(struct mmc_test_card *test, int testcase)
> +static void mmc_test_run(struct mmc_test_card *test, long testcase)
>   {
> -	int i, ret;
> +	long i;

Why this change? isn't unsigned int sufficient for the mmc test cases?

> +	int ret;
>
>   	printk(KERN_INFO "%s: Starting tests of card %s...\n",
>   		mmc_hostname(test->card->host), mmc_card_id(test->card));
> @@ -1849,7 +1850,7 @@ static void mmc_test_run(struct mmc_test_card *test, int testcase)
>   		if (testcase&&  ((i + 1) != testcase))
>   			continue;
>
> -		printk(KERN_INFO "%s: Test case %d. %s...\n",
> +		printk(KERN_INFO "%s: Test case %ld. %s...\n",
>   			mmc_hostname(test->card->host), i + 1,
>   			mmc_test_cases[i].name);
>
> @@ -1920,9 +1921,10 @@ static ssize_t mmc_test_store(struct device *dev,
>   {
>   	struct mmc_card *card = mmc_dev_to_card(dev);
>   	struct mmc_test_card *test;
> -	int testcase;
> +	long testcase;
>
> -	testcase = simple_strtol(buf, NULL, 10);
> +	if (strict_strtol(buf, 10,&testcase))
space required                    ^ here

> +		return -EINVAL;
>
>   	test = kzalloc(sizeof(struct mmc_test_card), GFP_KERNEL);
>   	if (!test)


-- 
regards,
-roger
