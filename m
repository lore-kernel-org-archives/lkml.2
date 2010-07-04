Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab0GDK1z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 06:27:55 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36346 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756858Ab0GDK1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 06:27:53 -0400
Message-ID: <4C3061E9.8060103@ru.mvista.com>
Date: Sun, 04 Jul 2010 14:26:49 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
CC: linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: gadget: storage_common: comments updated
References: <35e07b59ee0738c2019d2b81958890a472941a0e.1277902597.git.m.nazarewicz@samsung.com>
In-Reply-To: <35e07b59ee0738c2019d2b81958890a472941a0e.1277902597.git.m.nazarewicz@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Michal Nazarewicz wrote:

> Updated comment to describe why printing macros are needed even
> thought they are copied form the composite.h.  Also, made multiline
> comments follow the coding standard.

> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>

[...]

> diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
> index 04c462f..557b119 100644
> --- a/drivers/usb/gadget/storage_common.c
> +++ b/drivers/usb/gadget/storage_common.c
> @@ -84,14 +84,23 @@
>  #define LWARN(lun, fmt, args...)  dev_warn(&(lun)->dev, fmt, ## args)
>  #define LINFO(lun, fmt, args...)  dev_info(&(lun)->dev, fmt, ## args)
>  
> -/* Keep those macros in sync with thos in
> - * include/linux/ubs/composite.h or else GCC will complain.  If they
> +/*
> + * Keep those macros in sync with thos in

    s/thos/those/ while at, please.

> + * include/linux/usb/composite.h or else GCC will complain.  If they
>   * are identical (the same names of arguments, white spaces in the
>   * same places) GCC will allow redefinition otherwise (even if some
> - * white space is removed or added) warning will be issued.  No
> - * checking if those symbols is defined is performed because warning
> - * is desired when those macros were defined by someone else to mean
> - * something else. */
> + * white space is removed or added) warning will be issued.
> + *
> + * Those macros are needed here because File Storage Gadget does not
> + * include the composite.h header.  For composite gadgets those macros
> + * are redundant since composite.h is included any way.
> + *
> + * No checking if those symbols is defined is performed because
                                    ^^ are

> @@ -313,9 +322,12 @@ struct fsg_buffhd {
>  	enum fsg_buffer_state		state;
>  	struct fsg_buffhd		*next;
>  
> -	/* The NetChip 2280 is faster, and handles some protocol faults
> -	 * better, if we don't submit any short bulk-out read requests.
> -	 * So we will record the intended request length here. */
> +	/*
> +	 * The NetChip 2280 is faster, and handles some protocol
> +	 * faults better, if we don't submit any short bulk-out read
> +	 * requests.  So we will record the intended request length
> +	 * here.

    Hm, why reformat the paragraph?

WBR, Sergei
