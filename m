Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab2ENOme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 10:42:34 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:47933 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab2ENOmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 10:42:33 -0400
Message-ID: <4FB119CA.2080606@linux.vnet.ibm.com>
Date: Mon, 14 May 2012 09:42:18 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] zram: remove comment in Kconfig
References: <1336985134-31967-1-git-send-email-minchan@kernel.org> <1336985134-31967-2-git-send-email-minchan@kernel.org>
In-Reply-To: <1336985134-31967-2-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051414-3270-0000-0000-00000652F23F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2012 03:45 AM, Minchan Kim wrote:

> Exactly speaking, zram should has dependency with
> zsmalloc, not x86. So x86 dependeny check is redundant.
> 
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  drivers/staging/zram/Kconfig |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/zram/Kconfig b/drivers/staging/zram/Kconfig
> index 9d11a4c..ee23a86 100644
> --- a/drivers/staging/zram/Kconfig
> +++ b/drivers/staging/zram/Kconfig
> @@ -1,8 +1,6 @@
>  config ZRAM
>  	tristate "Compressed RAM block device support"
> -	# X86 dependency is because zsmalloc uses non-portable pte/tlb
> -	# functions
> -	depends on BLOCK && SYSFS && X86
> +	depends on BLOCK && SYSFS


Two comments here:

1) zram should really depend on ZSMALLOC instead of selecting it
because, as the patch has it, zram could be selected on an arch that
zsmalloc doesn't support.

2) This change would need to be done in zcache as well.

Seth

