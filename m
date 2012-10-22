Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab2JVT5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:57:35 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50565 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab2JVT5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:57:33 -0400
Date: Mon, 22 Oct 2012 12:57:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: anish kumar <anish198519851985@gmail.com>
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [PATCH] extcon: driver model release call not needed
Message-ID: <20121022195730.GB13640@kroah.com>
References: <1350580326-1574-1-git-send-email-anish198519851985@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350580326-1574-1-git-send-email-anish198519851985@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 02:12:06AM +0900, anish kumar wrote:
> From: anish kumar <anish198519851985@gmail.com>
> 
> We don't need a release call in this file as we are doing
> everything needed in unregister call and we don't have any
> more pointer to free up.
> 
> Signed-off-by: anish kumar <anish198519851985@gmail.com>
> ---
>  drivers/extcon/extcon-class.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index 946a318..cf30eb1 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -585,9 +585,7 @@ static void extcon_cleanup(struct extcon_dev *edev, bool skip)
>  
>  static void extcon_dev_release(struct device *dev)
>  {
> -	struct extcon_dev *edev = (struct extcon_dev *) dev_get_drvdata(dev);
> -
> -	extcon_cleanup(edev, true);
> +	/* We don't have any thing to free here */
>  }

In the future (I know you fixed this up), doing an empty release()
function will get you in big trouble.  Please read the kobject
documentation for more information about why this is.

greg k-h
