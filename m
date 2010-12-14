Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381Ab0LNEvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 23:51:10 -0500
Received: from mail.windriver.com ([147.11.1.11]:45045 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758283Ab0LNEvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 23:51:04 -0500
Message-ID: <4D06F798.9000006@windriver.com>
Date: Mon, 13 Dec 2010 22:50:32 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Tilman Sauerbeck <tilman@code-monkey.de>,
        kernel-janitors@vger.kernel.org, Kgdb-bugreport@lists.sourceforge.net
Subject: Re: [patch] kgdb: strlen() doesn't count the terminator
References: <20101209112821.GU10623@bicker>
In-Reply-To: <20101209112821.GU10623@bicker>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Dec 2010 04:50:33.0657 (UTC) FILETIME=[710A3290:01CB9B4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2010 05:28 AM, Dan Carpenter wrote:
> This is an off by one because strlen() doesn't count the null
> terminator.  We strcpy() these strings into an array of size
> MAX_CONFIG_LEN.
> 

I'll queue this patch for the 2.6.38 merge window since it is not
something you can exploit without root access, and the fact that the
vast majority of configurations do not include the kgdb test suite at
all.

Thanks,
Jason.

> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
> index 59c118c..27dc463 100644
> --- a/drivers/misc/kgdbts.c
> +++ b/drivers/misc/kgdbts.c
> @@ -988,7 +988,7 @@ static void kgdbts_run_tests(void)
>  
>  static int kgdbts_option_setup(char *opt)
>  {
> -	if (strlen(opt) > MAX_CONFIG_LEN) {
> +	if (strlen(opt) >= MAX_CONFIG_LEN) {
>  		printk(KERN_ERR "kgdbts: config string too long\n");
>  		return -ENOSPC;
>  	}
> diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
> index 3374618..ec1748b 100644
> --- a/drivers/serial/kgdboc.c
> +++ b/drivers/serial/kgdboc.c
> @@ -130,7 +130,7 @@ static void kgdboc_unregister_kbd(void)
>  
>  static int kgdboc_option_setup(char *opt)
>  {
> -	if (strlen(opt) > MAX_CONFIG_LEN) {
> +	if (strlen(opt) >= MAX_CONFIG_LEN) {
>  		printk(KERN_ERR "kgdboc: config string too long\n");
>  		return -ENOSPC;
>  	}

