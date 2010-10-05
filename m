Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab0JETSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 15:18:10 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54997 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab0JETSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 15:18:08 -0400
Message-ID: <4CAB79C4.3030208@ru.mvista.com>
Date: Tue, 05 Oct 2010 23:17:24 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Rahul Ruikar <rahul.ruikar@gmail.com>
CC: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: langwell_udc: Fix error path
References: <1286302800-2715-1-git-send-email-rahul.ruikar@gmail.com>
In-Reply-To: <1286302800-2715-1-git-send-email-rahul.ruikar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Rahul Ruikar wrote:

> Fix for following cases
> - Call device_unregister() only when device_register() is success.

    s/is success/succeeds/

> - Call put_device() when device_register() fails.
> - Call device_remove_file() only when device_create_file() is success.

    s/is success/succeeds/

> Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>

[...]

> diff --git a/drivers/usb/gadget/langwell_udc.h b/drivers/usb/gadget/langwell_udc.h
> index 9719934..b212a70 100644
> --- a/drivers/usb/gadget/langwell_udc.h
> +++ b/drivers/usb/gadget/langwell_udc.h
> @@ -199,7 +199,9 @@ struct langwell_udc {
>  				vbus_active:1,
>  				suspended:1,
>  				stopped:1,
> -				lpm:1;	/* LPM capability */
> +				lpm:1,	/* LPM capability */
> +				reg_status:1,
> +				file_create:1;

    I'd rather have called this 'file_created'.

>  
>  	/* pci state used to access those endpoints */
>  	struct pci_dev		*pdev;

WBR, Sergei
