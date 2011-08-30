Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab1H3G7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 02:59:41 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33149 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab1H3G7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 02:59:40 -0400
Date: Mon, 29 Aug 2011 23:59:31 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-input@vger.kernel.org
Subject: Re: [PATCH] input: fix misc/twl6040-vibra.c warning
Message-ID: <20110830065931.GA5791@core.coreip.homeip.net>
References: <20110829125017.9337299c.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110829125017.9337299c.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Mon, Aug 29, 2011 at 12:50:17PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix warning from Geert's build summary emails by changing "if" to
> "ifdef".  Also handle the case of CONFIG_PM_SLEEP not enabled.
> 
> drivers/input/misc/twl6040-vibra.c:231:5: warning: "CONFIG_PM_SLEEP" is not defined
> 
> Builds cleanly with CONFIG_PM_SLEEP enabled or disabled.
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  drivers/input/misc/twl6040-vibra.c |   11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> --- linux-next-20110829.orig/drivers/input/misc/twl6040-vibra.c
> +++ linux-next-20110829/drivers/input/misc/twl6040-vibra.c
> @@ -228,7 +228,7 @@ static void twl6040_vibra_close(struct i
>  	mutex_unlock(&info->mutex);
>  }
>  
> -#if CONFIG_PM_SLEEP
> +#ifdef CONFIG_PM_SLEEP

This is actually the only change that is needed. In case when
CONFIG_PM_SLEEP is not defined SIMPLE_DEV_PM_OPS() produces empty
'struct dev_pm_ops' so no additional #ifdef-ing is needed.

Thanks.

-- 
Dmitry
