Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab0HAKIJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 06:08:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50106 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613Ab0HAKIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 06:08:04 -0400
Message-ID: <4C55472E.6000307@ru.mvista.com>
Date: Sun, 01 Aug 2010 14:06:38 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Kulikov Vasiliy <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Tony Lindgren <tony@atomide.com>,
        Cory Maccarrone <darkstar6262@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] usb: omap_udc: check return value of proc_create()
References: <1280597965-8525-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1280597965-8525-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Kulikov Vasiliy wrote:

> proc_create() may fail, if so return -ENOMEM.

> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
[...]
> diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_udc.c
> index f81e4f0..1083216 100644
> --- a/drivers/usb/gadget/omap_udc.c
> +++ b/drivers/usb/gadget/omap_udc.c
> @@ -2544,9 +2544,9 @@ static const struct file_operations proc_ops = {
>  	.release	= single_release,
>  };
>  
> -static void create_proc_file(void)
> +static int create_proc_file(void)
>  {
> -	proc_create(proc_filename, 0, NULL, &proc_ops);
> +	return (proc_create(proc_filename, 0, NULL, &proc_ops) == NULL);

    Parens not needed around the *return* expression.

WBR, Sergei
