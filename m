Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab1CXOm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 10:42:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58196 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925Ab1CXOm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 10:42:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:organization:message-id:in-reply-to
         :user-agent;
        b=oLXbTQJN60RSa7Vd7VJY9pDn/jccyQZPRKi7V6gTSxrw0rzJ6Umn7MWmbz6hL6orrg
         ZZ4Yh7CvKW8Z8tPgsh77jm2XaHaMc7fj6fZ/wIou4oZ+toEE7H3+2SDtClJNUHcooCeL
         96EQS0Ut2IZGbk5hGNjFLzCUpqxn6AfkRtjNE=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Greg Kroah-Hartman" <gregkh@suse.de>,
        "Sergey Senozhatsky" <sergey.senozhatsky@gmail.com>
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
        "Chris Wright" <chrisw@sous-sol.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: check device_create_file() return code in
 usb_create_sysfs_intf_files()
References: <20110324143116.GA8200@swordfish.minsk.epam.com>
Date: Thu, 24 Mar 2011 15:42:50 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Organization: Google
Message-ID: <op.vsuq5nez3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <20110324143116.GA8200@swordfish.minsk.epam.com>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011 15:31:16 +0100, Sergey Senozhatsky wrote:
> diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
> index 6781c36..5a02524 100644
> --- a/drivers/usb/core/sysfs.c
> +++ b/drivers/usb/core/sysfs.c
> @@ -856,8 +856,10 @@ int usb_create_sysfs_intf_files(struct  
> usb_interface *intf)
>  		alt->string = usb_cache_string(udev, alt->desc.iInterface);
>  	if (alt->string)
>  		retval = device_create_file(&intf->dev, &dev_attr_interface);
> -	intf->sysfs_files_created = 1;
> -	return 0;
> +	if (retval == 0)
> +		intf->sysfs_files_created = 1;
> +
> +	return retval;
>  }

retval may be uninitialised.  You need to zero it at the beginning of the
function (or somewhere).

> void usb_remove_sysfs_intf_files(struct usb_interface *intf)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
