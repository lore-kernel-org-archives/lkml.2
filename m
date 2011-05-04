Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab1EDO1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:27:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61627 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab1EDO1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:27:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=rH8IT/FDiSEMD1Wf97rc1xaMwfwo2JZtYl90LAGTLI1nXILaP4gUvwu4oGo4tjLsR4
         6oYaRukOTCbMxuTTwHRptIrvaaQ5Qvd0FapJX5IUHNn6SHUBwb5hfHq3bQZBDTRHXT7w
         j8pMdwmC71jHDEOjBdoLaCVtmpdLlyAlk4jSc=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Maxin John" <maxin.john@gmail.com>
Cc: gregkh@suse.de, stern@rowland.harvard.edu, m-sonasath@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        roger.quadros@nokia.com
Subject: Re: [PATCH] usb: gadget: f_mass_storage: Remove the LUN check which
 is always true
References: <BANLkTik9e5it5vTMxvFUnZGpoO8N0ida8Q@mail.gmail.com>
Date: Wed, 04 May 2011 16:27:39 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vuynsdh13l0zgt@mnazarewicz-glaptop>
In-Reply-To: <BANLkTik9e5it5vTMxvFUnZGpoO8N0ida8Q@mail.gmail.com>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 May 2011 16:16:05 +0200, Maxin John <maxin.john@gmail.com>  
wrote:
> Since comparing an unsigned int (common->lun)  greater than or equal
> to zero is always true, I think it is safe to remove this check.
> Please let me know your comments.
>
> Thanks to Coverity for pointing this out.
>
> Signed-off-by: Maxin B. John <maxin.john@gmail.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

file_storage.c has the same check, could you remove it as well.

> --- a/drivers/usb/gadget/f_mass_storage.c
> +++ b/drivers/usb/gadget/f_mass_storage.c
> @@ -1910,7 +1910,7 @@ static int check_command(struct fsg_common
> *common, int cmnd_size,
>                     common->lun, lun);
>
>         /* Check the LUN */
> -       if (common->lun >= 0 && common->lun < common->nluns) {
> +       if (common->lun < common->nluns) {
>                 curlun = &common->luns[common->lun];
>                 common->curlun = curlun;
>                 if (common->cmnd[0] != REQUEST_SENSE) {


-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
