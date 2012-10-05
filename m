Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab2JEICA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:02:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13812 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2JEIB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:01:58 -0400
X-AuditID: cbfee61a-b7f726d000000ec7-59-506e93f5c1c7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1348868177-21205-1-git-send-email-arnd@arndb.de>
 <1348868177-21205-5-git-send-email-arnd@arndb.de>
In-reply-to: <1348868177-21205-5-git-send-email-arnd@arndb.de>
Subject: Re: [PATCH 04/12] video: exynos: warnings in exynos_dp_core.c
Date: Fri, 05 Oct 2012 17:01:56 +0900
Message-id: <002001cda2cf$b0b69c60$1223d520$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2dwVL6U8ZRx/g1RX6ajUuqFp8fYQFDM+Ng
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jAd2vk/MCDN6s5be4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZcz9KFHzhr5i/9x1rA+M03i5GDg4JAROJbxPVuhg5gUwxiQv3
	1rN1MXJxCAksYpSY/2wHE4Qzm0ni8olTzCBVbAJqEl++HGYHsUUElCWOv7zDAlLELLCNUWL9
	wmVMIAkhgUKJRQ1XmEE2cArYSbS8NgAJCwu4SfS8+AHWyyKgKnG4/wdYOa+ArcTcOd1sELag
	xI/J91hAbGYBLYnN25pYIWx5ic1r3jJDHK0u8eivLsQJRhLLJryFKheR2PfiHeMERqFZSCbN
	QjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHMTPpHYwrmywOMQowMGo
	xMOb8DA3QIg1say4MvcQowQHs5II79WkvAAh3pTEyqrUovz4otKc1OJDjNIcLErivM0eKQFC
	AumJJanZqakFqUUwWSYOTqkGxjNN/M8CF87cp7FAVNTUnos3q3vOZ8apZqlcstetq7lzq1wZ
	wk+vXt9+WtnWN+Wn6bmEcuPkA/F9IrOn/S8tnTTt9vP+d6W/L6zlzOfN+nlDJeKf1+VSseQV
	G3jO7OGYc/4f93bDp4/j/Y0a2r6sfnY3a8vTueLPixYsXrou9vjJt5IWYtv4hZVYijMSDbWY
	i4oTAfgLHPReAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, September 29, 2012 6:36 AM Arnd Bergmann wrote
> 
> Something is wrong with the exynos_dp_core logic, and gcc
> emits a warning about this. An array is declared in
> exynos_dp_process_equalizer_training with length '2',
> and exynos_dp_channel_eq_ok tries to access the third
> element of it.
> 
> This patch is certainly not correct, but hopefully helps
> highlight the actual problem. The problem apparently was
> introduced by d5c0eed01 "video: exynos_dp: adjust voltage
> swing and pre-emphasis during Link Training".
> 
> This is what we get in exynos_defconfig:
> drivers/video/exynos/exynos_dp_core.c: In function 'exynos_dp_process_equalizer_training':
> drivers/video/exynos/exynos_dp_core.c:341:13: warning: array subscript is above array bounds [-Warray-
> bounds]

Hi Arnd Bergmann,

This problem was fixed. So, this patch is not necessary.

As you mentioned, this problem was introduced by d5c0eed01
"video: exynos_dp: adjust voltage swing and pre-emphasis
during Link Training".

However, this problem was resolved by e75478b "video: exynos_dp:
replace link_status with link_align to check channel equalization".

The patch was merged to 'fbdev-next', and will be merged to
'3.7-rc1', soon. Thank you.

Best regards,
Jingoo Han


> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Jingoo Han <jg1.han@samsung.com>
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> ---
>  drivers/video/exynos/exynos_dp_core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/exynos/exynos_dp_core.c
> index cdc1398..358b595 100644
> --- a/drivers/video/exynos/exynos_dp_core.c
> +++ b/drivers/video/exynos/exynos_dp_core.c
> @@ -542,7 +542,7 @@ reduce_link_rate:
> 
>  static int exynos_dp_process_equalizer_training(struct exynos_dp_device *dp)
>  {
> -	u8 link_status[2];
> +	u8 link_status[3];
>  	u8 link_align[3];
>  	int lane;
>  	int lane_count;
> --
> 1.7.10

