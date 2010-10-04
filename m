Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab0JDJhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 05:37:47 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33126 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab0JDJhq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 05:37:46 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Mon, 04 Oct 2010 11:39:51 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] usb: gadget: file_storage: Fix error path
In-reply-to: <1286081717-2757-1-git-send-email-rahul.ruikar@gmail.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Christoph Hellwig <hch@lst.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rahul Ruikar <rahul.ruikar@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <op.vj1o4pqf7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.62 (Linux)
References: <1286081717-2757-1-git-send-email-rahul.ruikar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 03 Oct 2010 06:55:17 +0200, Rahul Ruikar <rahul.ruikar@gmail.com> wrote:
> call put_device() when device_register() fails.

Capital letter at the beginning of sentence please. ;)

>
> Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

(or even Reviewed? dunno if that makes sense for such a trivial patch.)

> ---
>  drivers/usb/gadget/file_storage.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
> index a857b7a..2c94318 100644
> --- a/drivers/usb/gadget/file_storage.c
> +++ b/drivers/usb/gadget/file_storage.c
> @@ -3413,6 +3413,7 @@ static int __ref fsg_bind(struct usb_gadget *gadget)
> 		if ((rc = device_register(&curlun->dev)) != 0) {
>  			INFO(fsg, "failed to register LUN%d: %d\n", i, rc);
> +			put_device(&curlun->dev);
>  			goto out;
>  		}
>  		if ((rc = device_create_file(&curlun->dev,

The same problem is with f_mass_storage.c.  I'd be nice if you'd resubmit your
patch with the below included as well:

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 44e5ffe..0b86174 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2764,6 +2764,7 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
  		rc = device_register(&curlun->dev);
  		if (rc) {
  			INFO(common, "failed to register LUN%d: %d\n", i, rc);
+			put_device(&curlun->dev);
  			common->nluns = i;
  			goto error_release;
  		}

Thanks.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
