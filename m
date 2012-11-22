Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546Ab2KVWf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:35:59 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:33705 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756239Ab2KVWf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 17:35:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Cyril Roelandt <tipecaml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] acpi_system_write_wakeup_device(): fix error check for unsigned variable.
Date: Thu, 22 Nov 2012 23:40:26 +0100
Message-ID: <27097726.Soe6qubrSj@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1353544495-25277-1-git-send-email-tipecaml@gmail.com>
References: <1645783.2WuR77RKxS@vostro.rjw.lan> <1353544495-25277-1-git-send-email-tipecaml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 22, 2012 01:34:55 AM Cyril Roelandt wrote:
> The LEN variable is unsigned, therefore checking whether it is less than 0 is
> useless. Also drop the LEN variable, since the COUNT parameter can be used
> instead.

Applied (under a different subject).

Thanks,
Rafael


> Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
> ---
>  drivers/acpi/proc.c |   11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/acpi/proc.c b/drivers/acpi/proc.c
> index 27adb09..ef98796 100644
> --- a/drivers/acpi/proc.c
> +++ b/drivers/acpi/proc.c
> @@ -362,16 +362,13 @@ acpi_system_write_wakeup_device(struct file *file,
>  	struct list_head *node, *next;
>  	char strbuf[5];
>  	char str[5] = "";
> -	unsigned int len = count;
>  
> -	if (len > 4)
> -		len = 4;
> -	if (len < 0)
> -		return -EFAULT;
> +	if (count > 4)
> +		count = 4;
>  
> -	if (copy_from_user(strbuf, buffer, len))
> +	if (copy_from_user(strbuf, buffer, count))
>  		return -EFAULT;
> -	strbuf[len] = '\0';
> +	strbuf[count] = '\0';
>  	sscanf(strbuf, "%s", str);
>  
>  	mutex_lock(&acpi_device_lock);
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
