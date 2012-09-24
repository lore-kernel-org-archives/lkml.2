Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab2IXHYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 03:24:24 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39893 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab2IXHYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 03:24:21 -0400
X-AuditID: cbfee61b-b7f2b6d000000f14-48-50600aa4eaa6
Message-id: <50600AA0.3080907@samsung.com>
Date: Mon, 24 Sep 2012 16:24:16 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Peter Huewe <peterhuewe@gmx.de>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2] extcon: unregister compat link on cleanup
References: <1348278070-22202-1-git-send-email-peterhuewe@gmx.de>
 <1348278070-22202-2-git-send-email-peterhuewe@gmx.de>
In-reply-to: <1348278070-22202-2-git-send-email-peterhuewe@gmx.de>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsVy+t9jAd0lXAkBBkf3W1hc3jWHzWLBxkeM
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXs6djCXnCcv+LUJvYGxlbeLkZODgkBE4nTe68yQdhi
	EhfurWfrYuTiEBJYxCixZt1xJgjnJaPEyZ+bmUGqeAW0JFrvfweq4uBgEVCVODc3GyTMBhTe
	/+IGWFhUIELiVz8HRLWgxI/J91hAbBEBZYn9r/axg4xkFuhklDi1qo0RJCEs4CSxbONzVhBb
	SKBS4tDsE2A2J1B85bY3bCA2s4COxP7WaVC2vMTmNW+ZJzAKzEKyYxaSsllIyhYwMq9iFE0t
	SC4oTkrPNdIrTswtLs1L10vOz93ECA7EZ9I7GFc1WBxiFOBgVOLh3XAmPkCINbGsuDL3EKME
	B7OSCG/EM6AQb0piZVVqUX58UWlOavEhRmkOFiVxXuFPgQFCAumJJanZqakFqUUwWSYOTqkG
	RumPz46ZSSkpO/k80I3R4xB7rxZY077B2/Jn8YXzPX+un1TYO3HJoiWH7l9bv0j3g8LSMoW2
	Smtmrc7aiwm33b8Xrn+x7Ertv7p/dWovfnLKr9f9+MpX5N/xp11JL527PdKqbvvt+V1g/W6K
	VJe3Ve2EaezFc3PMxRlEZ5i5Olw+b6IoHsiiqMRSnJFoqMVcVJwIABqRpnFAAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2012 10:41 AM, Peter Huewe wrote:

> Since extcon registers this compat link at device registration
> (extcon_dev_register), we should probably remove them at deregistration/cleanup.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---

Applied, thank you.

Also, there were some minor issue, but I fixed them up.

You will check it after some hours on below git repository.
-
http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/extcon-for-next


>  drivers/extcon/extcon_class.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/extcon/extcon_class.c b/drivers/extcon/extcon_class.c
> index 6e914d0..7610b4e 100644
> --- a/drivers/extcon/extcon_class.c
> +++ b/drivers/extcon/extcon_class.c
> @@ -575,6 +575,11 @@ static void extcon_cleanup(struct extcon_dev *edev, bool skip)
>  			kfree(edev->cables);
>  		}
>  
> +#if defined(CONFIG_ANDROID)
> +		if (switch_class)
> +			ret = class_compat_remove_link(switch_class, edev->dev,
> +						       NULL);
> +#endif /* CONFIG_ANDROID */


This patch have build break which show below log because 'ret' variable
isn't defined on extcon_cleanup function and class_compat_remove_link
function return void type after function call. So, I remove 'ret' variable.

drivers/extcon/extcon-class.c: In function 'extcon_cleanup':
drivers/extcon/extcon-class.c:574: error: 'ret' undeclared (first use in
this function)
drivers/extcon/extcon-class.c:574: error: (Each undeclared identifier is
reported only once
drivers/extcon/extcon-class.c:574: error: for each function it appears in.)
drivers/extcon/extcon-class.c: In function 'extcon_class_exit':
drivers/extcon/extcon-class.c:825: warning: extra tokens at end of
#ifdef directive
make[2]: *** [drivers/extcon/extcon-class.o] Error 1
make[1]: *** [drivers/extcon] Error 2
make[1]: *** Waiting for unfinished jobs....

Thanks,
Chanwoo Choi

