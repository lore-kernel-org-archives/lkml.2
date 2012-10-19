Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab2JSOyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:54:00 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4121 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829Ab2JSOx6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:53:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 19 Oct 2012 07:42:11 -0700
From: Philip Rakity <prakity@nvidia.com>
To: Sangho Yi <antiroot@gmail.com>
CC: "aaron.lu@amd.com" <aaron.lu@amd.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "chuanxiao.dong@intel.com" <chuanxiao.dong@intel.com>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Date: Fri, 19 Oct 2012 16:53:54 +0200
Subject: Re: [PATCH 1/2] mmc: core: bus.c: removed unnecessary NULL check
 for kfree(...)
Thread-Topic: [PATCH 1/2] mmc: core: bus.c: removed unnecessary NULL check
 for kfree(...)
Thread-Index: Ac2uCY39VQinW3Y6SbGq8hS5eX35/g==
Message-ID: <CF479BD7-8340-4428-9466-8A7BB688BD28@nvidia.com>
References: <n> <1350655138-2252-1-git-send-email-antiroot@gmail.com>
In-Reply-To: <1350655138-2252-1-git-send-email-antiroot@gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 19 Oct 2012, at 14:58, Sangho Yi <antiroot@gmail.com> wrote:

> kfree(NULL) is safe so I removed the if statements for NULL check.
> 
> Signed-off-by: Sangho Yi <antiroot@gmail.com>
> ---
> drivers/mmc/core/bus.c |    3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
> index 9b68933..420cb67 100644
> --- a/drivers/mmc/core/bus.c
> +++ b/drivers/mmc/core/bus.c
> @@ -225,8 +225,7 @@ static void mmc_release_card(struct device *dev)
> 
> 	sdio_free_common_cis(card);
> 
> -	if (card->info)
> -		kfree(card->info);
> +	kfree(card->info);
> 
> 	kfree(card);
> }
> -- 
> 1.7.9.5

Reviewed-by: Philip Rakity <prakity@nvidia.com>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

