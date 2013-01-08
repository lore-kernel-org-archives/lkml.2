Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab3AHABl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 19:01:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39674 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115Ab3AHABj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 19:01:39 -0500
Date: Mon, 7 Jan 2013 16:01:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Devendra Naga'" <devendra.aaru@gmail.com>
Subject: Re: [PATCH] backlight: check null deference of name when device is
 registered
Message-Id: <20130107160137.dec5098a.akpm@linux-foundation.org>
In-Reply-To: <000b01cdea55$92725aa0$b7570fe0$%han@samsung.com>
References: <000b01cdea55$92725aa0$b7570fe0$%han@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Jan 2013 17:29:11 +0900
Jingoo Han <jg1.han@samsung.com> wrote:

> NULL deference of name is checked when device is registered.
> If the name is null, it will cause a kernel oops in dev_set_name().
> 
> ...
>
> --- a/drivers/video/backlight/backlight.c
> +++ b/drivers/video/backlight/backlight.c
> @@ -292,6 +292,11 @@ struct backlight_device *backlight_device_register(const char *name,
>  	struct backlight_device *new_bd;
>  	int rc;
>  
> +	if (name == NULL) {
> +		pr_err("backlight name is null\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
>  	pr_debug("backlight_device_register: name=%s\n", name);

I don't understand this.

Is there some driver which is calling these functions with name=NULL? 
If so, which one(s)?

If "no" then why don't we declare that "passing name=NULL is a bug" and
leave the code as-is?

