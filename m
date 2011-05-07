Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab1EGWSi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 18:18:38 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33659 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287Ab1EGWSh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 18:18:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iSYnij3rFMsP4txX0a3vjxn7quDHFRIbT2VOEwXaWNuwSpUMNM01JId1bQFIVNsxUR
         WFmEb0AQn2iKSSGDyzvURqeg8+V2lnvE2fSCIht+8hzS5GNjwKt/2VdBtwsBL5N2MIhw
         Tlx/6B6wTxN27jIILjMGf56YgTUGas3goRaG4=
MIME-Version: 1.0
In-Reply-To: <1304795706-27308-3-git-send-email-per.forlin@linaro.org>
References: <1304795706-27308-1-git-send-email-per.forlin@linaro.org>
	<1304795706-27308-3-git-send-email-per.forlin@linaro.org>
Date: Sun, 8 May 2011 01:18:36 +0300
Message-ID: <BANLkTim2k_hb0Bw_cYeTUv-dMzyWVPO+gA@mail.gmail.com>
Subject: Re: [PATCH v3 02/12] mmc: mmc_test: add debugfs file to list all tests
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Per Forlin <per.forlin@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Chris Ball <cjb@laptop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 7, 2011 at 10:14 PM, Per Forlin <per.forlin@linaro.org> wrote:
> Add a debugfs file "testlist" to print all available tests
>
> Signed-off-by: Per Forlin <per.forlin@linaro.org>
> ---
>  drivers/mmc/card/mmc_test.c |   30 ++++++++++++++++++++++++++++++
>  1 files changed, 30 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
> index abc1a63..c1c3c5a 100644
> --- a/drivers/mmc/card/mmc_test.c
> +++ b/drivers/mmc/card/mmc_test.c


> @@ -2476,6 +2502,10 @@ static int mmc_test_register_file_test(struct mmc_card *card)
>                file = debugfs_create_file("test", S_IWUSR | S_IRUGO,
>                        card->debugfs_root, card, &mmc_test_fops_test);
>
> +       if (card->debugfs_root)
> +               file = debugfs_create_file("testlist", S_IRUGO,
> +                       card->debugfs_root, card, &mmc_test_fops_testlist);
> +
>        if (IS_ERR_OR_NULL(file)) {
>                dev_err(&card->dev,
>                        "Can't create file. Perhaps debugfs is disabled.\n");
I think you also need to use similar error path for both files: test
and testlist.


-- 
With Best Regards,
Andy Shevchenko
