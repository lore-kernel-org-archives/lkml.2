Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab1EDPmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:42:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65437 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab1EDPmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:42:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=IYbWL6duAinaIN3M7yyCIb9cLTldLbuJ7i2M3LlBBNNlxGwfz+ihaCMcQQ1mXAlgUn
         p8VUeIyjvw7e8tAPgRQhuF4buqzP2898LiWSb2shhbG/SKhRTQ9ysAJajKBrVvSLREXF
         mfzJCB/WAzvmiz9zmM7gvzR+Qza2GTeyR4SXk=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Maxin John" <maxin.john@gmail.com>
Cc: gregkh@suse.de, stern@rowland.harvard.edu, m-sonasath@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        roger.quadros@nokia.com
Subject: Re: [PATCH] usb: gadget: f_mass_storage: Remove the LUN check which
 is always true
References: <BANLkTik9e5it5vTMxvFUnZGpoO8N0ida8Q@mail.gmail.com>
 <op.vuynsdh13l0zgt@mnazarewicz-glaptop>
 <BANLkTinxvtMUcFz9T7L1iq9pFUx8ocQnRQ@mail.gmail.com>
Date: Wed, 04 May 2011 17:41:49 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vuyq7zet3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <BANLkTinxvtMUcFz9T7L1iq9pFUx8ocQnRQ@mail.gmail.com>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 May 2011 17:04:03 +0200, Maxin John <maxin.john@gmail.com>  
wrote:

> Hi Michal,
>
>> Acked-by: Michal Nazarewicz <mina86@mina86.com>
>
> Thank you very much for reviewing the patch.
>
>> file_storage.c has the same check, could you remove it as well.
>
> Please find the patch for "file_storage.c" below. Should I merge these
> two patches and re-submit as a single one?

I would merge them together.

> Signed-off-by: Maxin B. John <maxin.john@gmail.com>
> ---
> diff --git a/drivers/usb/gadget/file_storage.c
> b/drivers/usb/gadget/file_storage.c
> index a6eacb5..a9c5177 100644
> --- a/drivers/usb/gadget/file_storage.c
> +++ b/drivers/usb/gadget/file_storage.c
> @@ -2314,7 +2314,7 @@ static int check_command(struct fsg_dev *fsg,
> int cmnd_size,
>                 fsg->lun = lun;         // Use LUN from the command
>
>         /* Check the LUN */
> -       if (fsg->lun >= 0 && fsg->lun < fsg->nluns) {
> +       if (fsg->lun < fsg->nluns) {
>                 fsg->curlun = curlun = &fsg->luns[fsg->lun];
>                 if (fsg->cmnd[0] != REQUEST_SENSE) {
>                         curlun->sense_data = SS_NO_SENSE;


-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
