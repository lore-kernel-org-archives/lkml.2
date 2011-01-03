Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab1ACJwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 04:52:37 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:60528 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab1ACJwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 04:52:36 -0500
Date: Mon, 3 Jan 2011 01:52:31 -0800
From: Andres Salomon <dilinger@queued.net>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: sameo@linux.intel.com, akpm@linux-foundation.org, tj@kernel.org,
        joe@perches.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] misc/cs5535: Fix section mismatch derived from
 cs5535_mfgpt_drv variable
Message-ID: <20110103015231.1a0e6997@queued.net>
In-Reply-To: <1294023088-31687-1-git-send-email-sedat.dilek@gmail.com>
References: <1294023088-31687-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 Jan 2011 03:51:28 +0100
Sedat Dilek <sedat.dilek@googlemail.com> wrote:

> From my build.log:
> 
> WARNING: drivers/misc/cs5535-mfgpt.o(.data+0x0): Section mismatch in
> reference from the variable cs5535_mfgpt_drv to the
> function .devinit.text:cs5535_mfgpt_probe() The variable
> cs5535_mfgpt_drv references the function __devinit
> cs5535_mfgpt_probe() If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the
> variable: *driver, *_template, *_timer, *_sht, *_ops, *_probe,
> *_probe_one, *_console,
> 
> This patch fixes the warning.
> 
> Tested with linux-next (next-20101231)
> 
> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
> ---
>  drivers/misc/cs5535-mfgpt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/misc/cs5535-mfgpt.c b/drivers/misc/cs5535-mfgpt.c
> index d02d302..d80bd14 100644
> --- a/drivers/misc/cs5535-mfgpt.c
> +++ b/drivers/misc/cs5535-mfgpt.c
> @@ -329,7 +329,7 @@ done:
>  	return err;
>  }
>  
> -static struct platform_driver cs5535_mfgpt_drv = {
> +static struct platform_driver cs5535_mfgpt_drv __refdata = {
>  	.driver = {
>  		.name = DRV_NAME,
>  		.owner = THIS_MODULE,

Hm, I'm confused.  There are plenty of other drivers in mfd/ and gpio/
that have their probe/remove functions marked as __dev{init,exit}, with
their associated platform_driver definitions not marked with any kind
of init marking.  Are they all generating this warning and getting
the same __refdata treatment?


