Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab2IXHFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 03:05:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:19698 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab2IXHFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 03:05:20 -0400
X-AuditID: cbfee61b-b7f2b6d000000f14-3d-5060062e6571
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        "'Arnd Bergmann'" <arnd@arndb.de>
References: <1347858583-13338-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1347858583-13338-1-git-send-email-sachin.kamat@linaro.org>
Subject: RE: [PATCH] ARM: dma-mapping: Fix potential memory leak in
 atomic_pool_init()
Date: Mon, 24 Sep 2012 09:05:08 +0200
Organization: SPRC
Message-id: <049301cd9a22$f0b8c960$d22a5c20$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2Uk3geBk3prpoPSnOMTou7Qmgv5AFjrCWg
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t9jQV09toQAg8NvuCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGtnmfmAo2clTsvdTC3sB4i62LkZNDQsBEYsPqiUwQtpjEhXvr
	weJCAtMZJbZP1e9i5AKyZzFJ3FnUCVbEJmAo0fW2C6xIRCBE4vjSZWBxZoFwid2LpzJDNLtL
	HPv4HyzOKeAh0TbhGyuILSwQITG9sxksziKgKnH3wQKgOAcHv4CQxMRZCiBhXgEXiaWP2lkg
	bEGJH5PvsUCM15JYv/M41Cp5ic1r3jKDtEoIqEs8+qsLYooIGElc3KoOUSEicbfhOesERuFZ
	SAbNQjJoFpJBs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHNrPpHcwrmqwOMQo
	wMGoxMO74Ux8gBBrYllxZe4hRgkOZiUR3ohnQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8wp8C
	A4QE0hNLUrNTUwtSi2CyTBycUg2MGsYX/dfvWWK1Om2jSO/D/iOLzXcVrrr3heHPbEd5H+7z
	LC9iWO6uLmh/peX5Z53Ypi/nr7qWbJMzNTnel96bIPSi+arWEu21nxbEnbhiN1tjanTUP58J
	+8JFV2UGRfoeSlc59cBPYYPQl9Lwxu9v91WtW5jdFnNIfcep9Wy85xmnnQ3NjP+iqMRSnJFo
	qMVcVJwIAPwoxaBpAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Monday, September 17, 2012 7:10 AM Sachin Kamat wrote:

> When either of __alloc_from_contiguous or __alloc_remap_buffer fails
> to provide a valid pointer, allocated memory is freed up and an error
> is returned. 'pages' was however not freed before returning error.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  arch/arm/mm/dma-mapping.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index 546a3e8..477a2d2 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -367,6 +367,8 @@ static int __init atomic_pool_init(void)
>  		       (unsigned)pool->size / 1024);
>  		return 0;
>  	}
> +
> +	kfree(pages);
>  no_pages:
>  	kfree(bitmap);
>  no_bitmap:
> --
> 1.7.4.1

Applied to my fixes-for-3.6 branch. Thanks for spotting this issue!

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


