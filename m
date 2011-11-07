Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab1KGQST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:18:19 -0500
Received: from mail.windriver.com ([147.11.1.11]:42434 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab1KGQSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:18:17 -0500
Message-ID: <4EB8044B.7020403@windriver.com>
Date: Mon, 7 Nov 2011 11:16:11 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: <linux-kernel@vger.kernel.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 2/2] mfd: include linux/module.h for ab5500-debugfs
References: <1320635954.10415.1.camel@phoenix> <1320636009.10415.2.camel@phoenix>
In-Reply-To: <1320636009.10415.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-11-06 10:20 PM, Axel Lin wrote:
> Include linux/module.h to fix below build error:
> 
>   CC      drivers/mfd/ab5500-debugfs.o
> drivers/mfd/ab5500-debugfs.c:571: error: 'THIS_MODULE' undeclared here (not in a function)
> make[2]: *** [drivers/mfd/ab5500-debugfs.o] Error 1
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/ab5500-debugfs.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/ab5500-debugfs.c b/drivers/mfd/ab5500-debugfs.c
> index 6be1fe6..b7b2d348 100644
> --- a/drivers/mfd/ab5500-debugfs.c
> +++ b/drivers/mfd/ab5500-debugfs.c
> @@ -4,6 +4,7 @@
>   * Debugfs support for the AB5500 MFD driver
>   */
>  
> +#include <linux/module.h>

This one looks incorrect.  I don't see any uses of MODULE_* or
module_* in the file, so I'll make a commit for it to use export.h
and retest.

P.

>  #include <linux/debugfs.h>
>  #include <linux/seq_file.h>
>  #include <linux/mfd/ab5500/ab5500.h>
