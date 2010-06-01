Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab0FAK52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 06:57:28 -0400
Received: from poutre.nerim.net ([62.4.16.124]:60843 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755393Ab0FAK5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 06:57:25 -0400
Date: Tue, 1 Jun 2010 12:57:21 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       linux-i2c@vger.kernel.org
Subject: Re: [PATCH 06/21] drivers/i2c/i2c-dev.c: Remove unnecessary kmalloc
 casts
Message-ID: <20100601125721.4e815e76@hyperion.delvare>
In-Reply-To: <ce6e7e3183f0756b14765076e63251e269e2c9f6.1275360951.git.joe@perches.com>
References: <cover.1275360951.git.joe@perches.com>
	<ce6e7e3183f0756b14765076e63251e269e2c9f6.1275360951.git.joe@perches.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Mon, 31 May 2010 20:23:08 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/i2c/i2c-dev.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
> index e0694e4..b3fcb59 100644
> --- a/drivers/i2c/i2c-dev.c
> +++ b/drivers/i2c/i2c-dev.c
> @@ -219,9 +219,7 @@ static noinline int i2cdev_ioctl_rdrw(struct i2c_client *client,
>  	if (rdwr_arg.nmsgs > I2C_RDRW_IOCTL_MAX_MSGS)
>  		return -EINVAL;
>  
> -	rdwr_pa = (struct i2c_msg *)
> -		kmalloc(rdwr_arg.nmsgs * sizeof(struct i2c_msg),
> -		GFP_KERNEL);
> +	rdwr_pa = kmalloc(rdwr_arg.nmsgs * sizeof(struct i2c_msg), GFP_KERNEL);
>  	if (!rdwr_pa)
>  		return -ENOMEM;
>  

Applied, thanks.

-- 
Jean Delvare
