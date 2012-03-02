Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab2CBOPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 09:15:20 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35117 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114Ab2CBOPT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 09:15:19 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mnazarewicz@gmail.com designates 10.14.119.136 as permitted sender) smtp.mail=mnazarewicz@gmail.com; dkim=pass header.i=mnazarewicz@gmail.com
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Felipe Balbi" <balbi@ti.com>, linux-usb@vger.kernel.org,
        "Thomas Faber" <thfabba@gmx.de>
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadgetfs: return number of bytes on ep0 read request
References: <4F5087CE.50304@gmx.de>
Date: Fri, 02 Mar 2012 15:15:15 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.wajq7pvf3l0zgt@mpn-glaptop>
In-Reply-To: <4F5087CE.50304@gmx.de>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Mar 2012 09:41:50 +0100, Thomas Faber <thfabba@gmx.de> wrote:
> A read from GadgetFS endpoint 0 during the data stage of a control
> request would always return 0 on success (as returned by
> wait_event_interruptible) despite having written data into the user
> buffer.
> This patch makes it correctly set the return value to the number of
> bytes read.
>
> Signed-off-by: Thomas Faber <thfabba@gmx.de>

Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: stable@vger.kernel.org

> ---
>  drivers/usb/gadget/inode.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
> index ae04266..4f18a0e 100644
> --- a/drivers/usb/gadget/inode.c
> +++ b/drivers/usb/gadget/inode.c
> @@ -1043,6 +1043,8 @@ ep0_read (struct file *fd, char __user *buf, size_t len, loff_t *ptr)
>  // FIXME don't call this with the spinlock held ...
>  				if (copy_to_user (buf, dev->req->buf, len))
>  					retval = -EFAULT;
> +				else
> +					retval = len;
>  				clean_req (dev->gadget->ep0, dev->req);
>  				/* NOTE userspace can't yet choose to stall */
>  			}


-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
