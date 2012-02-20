Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab2BTUuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 15:50:40 -0500
Received: from mail-1.atlantis.sk ([80.94.52.57]:45602 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766Ab2BTUuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 15:50:39 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH] i740fb: fix compile error when CONFIG_MTRR is not selected
Date: Mon, 20 Feb 2012 21:49:47 +0100
User-Agent: KMail/1.9.10
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
References: <20120216162900.e2dd164732084f48e5b239f0@canb.auug.org.au> <1329687211-6545-1-git-send-email-FlorianSchandinat@gmx.de>
In-Reply-To: <1329687211-6545-1-git-send-email-FlorianSchandinat@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201202202149.52869.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 February 2012 22:33:31 Florian Tobias Schandinat wrote:
> Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> ---
>  drivers/video/i740fb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/video/i740fb.c b/drivers/video/i740fb.c
> index 8be0302..fe574d8 100644
> --- a/drivers/video/i740fb.c
> +++ b/drivers/video/i740fb.c
> @@ -1179,9 +1179,9 @@ static void __devexit i740fb_remove(struct pci_dev
> *dev) struct fb_info *info = pci_get_drvdata(dev);
>
>  	if (info) {
> -#ifdef CONFIG_MTRR
>  		struct i740fb_par *par = info->par;
>
> +#ifdef CONFIG_MTRR
>  		if (par->mtrr_reg >= 0) {
>  			mtrr_del(par->mtrr_reg, 0, 0);
>  			par->mtrr_reg = -1;

Thanks for fixing my stupid bug. I thought that I tested it without 
CONFIG_MTRR. But obviously didn't.

-- 
Ondrej Zary
