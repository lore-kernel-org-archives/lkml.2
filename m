Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab2KMUNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 15:13:34 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42553 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab2KMUNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 15:13:32 -0500
Date: Tue, 13 Nov 2012 11:52:52 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Arpith Easow Alexander <arpith99@gmail.com>
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        hsweeten@visionengravers.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: drivers: replaced printk with dev_dbg
Message-ID: <20121113195252.GA13648@kroah.com>
References: <20121110070833.GA18391@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121110070833.GA18391@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2012 at 12:38:38PM +0530, Arpith Easow Alexander wrote:
> This is a patch to the vmk80xx.c file that replaces the printk with dev_dbg.
> This fixes the warnings found by the checkpatch.pl tool.
> 
> Signed-off-by: Arpith Easow Alexander <arpith99@gmail.com>
> ---
>  drivers/staging/comedi/drivers/vmk80xx.c |   30 ++++++++++++++++++------------
>  1 file changed, 18 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
> index df277aa..6eb5361 100644
> --- a/drivers/staging/comedi/drivers/vmk80xx.c
> +++ b/drivers/staging/comedi/drivers/vmk80xx.c
> @@ -131,10 +131,10 @@ static int dbgcm = 1;
>  static int dbgcm;
>  #endif
>  
> -#define dbgcm(fmt, arg...)                     \
> +#define dbgcm(dev, fmt, arg...)                     \
>  do {                                           \
>  	if (dbgcm)                             \
> -		printk(KERN_DEBUG fmt, ##arg); \
> +		dev_dbg(dev, fmt, ##arg); \

So a macro called dbgcm tests a variable called dbgcm?  Gotta love c at
times...

Just delete the macro, and the variable, and call dev_dbg() directly
please.

thanks.

greg k-h
