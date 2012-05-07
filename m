Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab2EGIKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 04:10:09 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:1143 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753021Ab2EGIKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 04:10:07 -0400
Message-ID: <1336378205.1933.3.camel@x61.thuisdomein>
Subject: Re: [PATCH] ramster: depend on CONFIG_NET for sock_* functions
From: Paul Bolle <pebolle@tiscali.nl>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: gregkh@linuxfoundation.org, dan.magenheimer@oracle.com,
        sjenning@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Mon, 07 May 2012 10:10:05 +0200
In-Reply-To: <1336377752-23985-1-git-send-email-levinsasha928@gmail.com>
References: <1336377752-23985-1-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 07 May 2012 08:10:05.0420 (UTC) FILETIME=[CF70C2C0:01CD2C28]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 10:02 +0200, Sasha Levin wrote:
> Building ramster without CONFIG_NET would cause linkage issue due to missing

I'd say s/CONFIG_NET/NET/ 

> sock_*() functions in cluster/tcp.c
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  drivers/staging/ramster/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/ramster/Kconfig b/drivers/staging/ramster/Kconfig
> index 4af1f8d..8e334cb 100644
> --- a/drivers/staging/ramster/Kconfig
> +++ b/drivers/staging/ramster/Kconfig
> @@ -1,6 +1,6 @@
>  config RAMSTER
>  	bool "Cross-machine RAM capacity sharing, aka peer-to-peer tmem"
> -	depends on (CLEANCACHE || FRONTSWAP) && CONFIGFS_FS=y && !ZCACHE && !XVMALLOC && !HIGHMEM
> +	depends on (CLEANCACHE || FRONTSWAP) && CONFIGFS_FS=y && !ZCACHE && !XVMALLOC && !HIGHMEM && CONFIG_NET

s/CONFIG_NET/NET/ again, I'd say. How was this tested?

>  	select LZO_COMPRESS
>  	select LZO_DECOMPRESS
>  	default n


Paul Bolle

