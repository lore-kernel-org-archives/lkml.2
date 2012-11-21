Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab2KUAke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 19:40:34 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:56762 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab2KUAkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 19:40:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Cyril Roelandt <tipecaml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] acpi_system_write_wakeup_device(): fix error check for unsigned variable.
Date: Wed, 21 Nov 2012 01:44:59 +0100
Message-ID: <1732852.VDXGV3Ao2T@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1353117263-6957-1-git-send-email-tipecaml@gmail.com>
References: <1353117263-6957-1-git-send-email-tipecaml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 17, 2012 02:54:23 AM Cyril Roelandt wrote:
> The LEN variable is unsigned, therefore checking whether it is less than 0 is
> useless.
> 
> Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
> ---
>  drivers/acpi/proc.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/acpi/proc.c b/drivers/acpi/proc.c
> index 27adb09..37871a7 100644
> --- a/drivers/acpi/proc.c
> +++ b/drivers/acpi/proc.c
> @@ -366,8 +366,6 @@ acpi_system_write_wakeup_device(struct file *file,
>  
>  	if (len > 4)
>  		len = 4;
> -	if (len < 0)
> -		return -EFAULT;

I would prefer to check if count < 0 instead.

>  
>  	if (copy_from_user(strbuf, buffer, len))
>  		return -EFAULT;

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
