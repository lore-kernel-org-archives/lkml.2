Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab2KSLkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 06:40:12 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41062 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab2KSLkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 06:40:11 -0500
Message-ID: <50AA1A96.20900@openvz.org>
Date: Mon, 19 Nov 2012 15:40:06 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121026 Firefox/10.0.10 Iceape/2.7.10
MIME-Version: 1.0
To: Tushar Behera <tushar.behera@linaro.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        patches@linaro.org
Subject: Re: [PATCH] bug: Fix sparse warning related to BUILD_BUG_ON_INVALID
References: <1353323702-13130-1-git-send-email-tushar.behera@linaro.org>
In-Reply-To: <1353323702-13130-1-git-send-email-tushar.behera@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tushar Behera wrote:
> commit baf05aa9271b ("bug: introduce BUILD_BUG_ON_INVALID() macro")
> introduces this macro when only _CHECKER_ is defined. Define
> a silent macro in the else condition to fix following sparse
> warning.
>
> mm/filemap.c:395:9: error: undefined identifier 'BUILD_BUG_ON_INVALID'
> mm/filemap.c:396:9: error: undefined identifier 'BUILD_BUG_ON_INVALID'
> mm/filemap.c:397:9: error: undefined identifier 'BUILD_BUG_ON_INVALID'
> include/linux/mm.h:419:9: error: undefined identifier 'BUILD_BUG_ON_INVALID'
> include/linux/mm.h:419:9: error: not a function<noident>
>
> Signed-off-by: Tushar Behera<tushar.behera@linaro.org>

Thanks.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

> ---
>   include/linux/bug.h |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/bug.h b/include/linux/bug.h
> index aaac4bb..b1cf40d 100644
> --- a/include/linux/bug.h
> +++ b/include/linux/bug.h
> @@ -15,6 +15,7 @@ struct pt_regs;
>   #define BUILD_BUG_ON_NOT_POWER_OF_2(n)
>   #define BUILD_BUG_ON_ZERO(e) (0)
>   #define BUILD_BUG_ON_NULL(e) ((void*)0)
> +#define BUILD_BUG_ON_INVALID(e) (0)
>   #define BUILD_BUG_ON(condition)
>   #define BUILD_BUG() (0)
>   #else /* __CHECKER__ */

