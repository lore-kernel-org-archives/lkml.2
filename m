Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893Ab0HLLc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 07:32:27 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53111 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757448Ab0HLLcY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 07:32:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jtofsm/Vj3x8r+pUNCS4fVk+30GGOGgyke271yKYn3xxIIOikrWqpFDaSmV9XXI1SS
         YBXMuMBlsucJIo6LaihRse+zTohzWHGNn4Thn+t3EA5hM7p5Ka2863ppllBLlun+pTJC
         qaxO7tG4CBMYvInnFqVRFF3nfbeN4+w6b7ueI=
MIME-Version: 1.0
In-Reply-To: <1a8a7e76daf68acaeecf4334848703318355a3a2.1281365237.git.m.nazarewicz@samsung.com>
References: <cover.1281365237.git.m.nazarewicz@samsung.com>
	<49ebe5a39e05aa55a19d33a2141736d215873f86.1281365237.git.m.nazarewicz@samsung.com>
	<b4fe56570ecb77ec6acbab4502f7ad87b72885e1.1281365237.git.m.nazarewicz@samsung.com>
	<9219d2c4e7b60f2ad1455b6c702604e84ef90e1b.1281365237.git.m.nazarewicz@samsung.com>
	<fd2e70a236743436c0c2e88eb3b32e4564571e32.1281365237.git.m.nazarewicz@samsung.com>
	<e37b282da3898486df3fc33cbb1de5e1b6bc26c3.1281365237.git.m.nazarewicz@samsung.com>
	<dadbebba90720630077702d19240acca9fdb2182.1281365237.git.m.nazarewicz@samsung.com>
	<1a8a7e76daf68acaeecf4334848703318355a3a2.1281365237.git.m.nazarewicz@samsung.com>
Date: Thu, 12 Aug 2010 14:32:23 +0300
Message-ID: <AANLkTinyPBp4HtWuxM=kSbe6nL2WP65B3tq-nCyMKJov@mail.gmail.com>
Subject: Re: [PATCHv7 7/8] usb: gadget: storage: remove nofua file when unbinding
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        USB <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Denis Karpov <ext-denis.2.karpov@nokia.com>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 9, 2010 at 6:02 PM, Michal Nazarewicz
<m.nazarewicz@samsung.com> wrote:
> The dev_attr_nofua file was created during fsg_bind() but
> was never removed.  Made it a bit more symmetrical and added
> code to remove the file in fsg_unbind().
>
> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
> ---
>  drivers/usb/gadget/file_storage.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
> index a857b7a..ab77792 100644
> --- a/drivers/usb/gadget/file_storage.c
> +++ b/drivers/usb/gadget/file_storage.c
> @@ -3178,6 +3178,7 @@ static void /* __init_or_exit */ fsg_unbind(struct usb_gadget *gadget)
>        for (i = 0; i < fsg->nluns; ++i) {
>                curlun = &fsg->luns[i];
>                if (curlun->registered) {
> +                       device_remove_file(&curlun->dev, &dev_attr_nofua);
>                        device_remove_file(&curlun->dev, &dev_attr_ro);
>                        device_remove_file(&curlun->dev, &dev_attr_file);
>                        fsg_lun_close(curlun);
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Acked-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

-- 
With Best Regards,
Andy Shevchenko
