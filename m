Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab1CXO7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 10:59:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48856 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab1CXO7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 10:59:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:organization:message-id:in-reply-to
         :user-agent;
        b=d+d0dwDXQyu3IMuXAuPgfm0JL05phQchpRtqv4tVBVFkErBofeSrpe5lUKASeh9vUz
         LPnlneiaXjQVKrOFQjh6bfZ7BJq5lh5SPnh0Mq9SNbjZxtx5QD5hNdAaw90oVS5rs4ft
         fPSE+rSxjYe+dYP9a0M6UXJv//88ZVsX4vZ5Q=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Sergey Senozhatsky" <sergey.senozhatsky@gmail.com>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Chris Wright" <chrisw@sous-sol.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: check device_create_file() return code in
 usb_create_sysfs_intf_files()
References: <20110324143116.GA8200@swordfish.minsk.epam.com>
 <op.vsuq5nez3l0zgt@mnazarewicz-glaptop>
 <20110324145606.GB8200@swordfish.minsk.epam.com>
Date: Thu, 24 Mar 2011 15:58:54 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Organization: Google
Message-ID: <op.vsurwgro3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <20110324145606.GB8200@swordfish.minsk.epam.com>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011 15:56:06 +0100, Sergey Senozhatsky wrote:
> diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
> index 6781c36..d03c630 100644
> --- a/drivers/usb/core/sysfs.c
> +++ b/drivers/usb/core/sysfs.c
> @@ -846,7 +846,7 @@ int usb_create_sysfs_intf_files(struct usb_interface  
> *intf)
>  {
>  	struct usb_device *udev = interface_to_usbdev(intf);
>  	struct usb_host_interface *alt = intf->cur_altsetting;
> -	int retval;
> +	int retval = -1;

That should be 0 or some other meaningful value. A literal -1 is definitely
not a good choice.  This is just for future since Alan has explained this
patch is not needed.

> 	if (intf->sysfs_files_created || intf->unregistering)
>  		return 0;

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
