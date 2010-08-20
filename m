Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab0HTS1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 14:27:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49847 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab0HTS1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 14:27:35 -0400
Date: Fri, 20 Aug 2010 11:27:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: rpurdie@rpsys.net, sameo@linux.intel.com, mjg@redhat.com,
        error27@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] backlight: 88pm860x_bl: fix build failure
Message-Id: <20100820112701.3f722b81.randy.dunlap@oracle.com>
In-Reply-To: <1282327315-5259-1-git-send-email-henne@nachtwindheim.de>
References: <1282327315-5259-1-git-send-email-henne@nachtwindheim.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Aug 2010 20:01:55 +0200 Henrik Kretzschmar wrote:

> On x86_64 system this driver fails to build, since theres already a

fails as in an error, not just a warning?

I see this:

drivers/video/backlight/88pm860x_bl.c:24:1: warning: "CURRENT_MASK" redefined
arch/x86/include/asm/page_64_types.h:6:1: warning: this is the location of the previous definition


> macro called CURRENT_MASK in arch/asm/include/page_64_types.h
> So I renamed this macro to BL_CURRENT_MASK to aviod a collision.
> 
> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
> ---
> This patch is against Linux tree and tested.
> 
>  drivers/video/backlight/88pm860x_bl.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/backlight/88pm860x_bl.c b/drivers/video/backlight/88pm860x_bl.c
> index 38ffc3f..68bd602 100644
> --- a/drivers/video/backlight/88pm860x_bl.c
> +++ b/drivers/video/backlight/88pm860x_bl.c
> @@ -21,7 +21,7 @@
>  #define MAX_BRIGHTNESS		(0xFF)
>  #define MIN_BRIGHTNESS		(0)
>  
> -#define CURRENT_MASK		(0x1F << 1)
> +#define BL_CURRENT_MASK		(0x1F << 1)
>  
>  struct pm860x_backlight_data {
>  	struct pm860x_chip *chip;
> @@ -85,7 +85,7 @@ static int pm860x_backlight_set(struct backlight_device *bl, int brightness)
>  	if ((data->current_brightness == 0) && brightness) {
>  		if (data->iset) {
>  			ret = pm860x_set_bits(data->i2c, wled_idc(data->port),
> -					      CURRENT_MASK, data->iset);
> +					      BL_CURRENT_MASK, data->iset);
>  			if (ret < 0)
>  				goto out;
>  		}
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
