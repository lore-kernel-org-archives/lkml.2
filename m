Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab1CZTdG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 15:33:06 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34808 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab1CZTdE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 15:33:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sxkR9BpEbAZTg2p8ANpMu6KFw/f0MjY8roGuGSiQgE9IKK5y1+M4FKFg0Xd5LV1UgG
         26cRgontkXJhZKwoOgoHkp3UmYDj6f/R/77SWwb04wysq7hqPqQpF9CwTdUDi+SjJN2w
         P0hRJPqau2lMjJuMdW8NQ5ltbvHNQLuKNbPAg=
MIME-Version: 1.0
In-Reply-To: <1301167611.17567.12.camel@Joe-Laptop>
References: <1301156180-12192-1-git-send-email-ralf.thielow@googlemail.com>
	<1301156180-12192-2-git-send-email-ralf.thielow@googlemail.com>
	<1301165486.17567.7.camel@Joe-Laptop>
	<AANLkTi=dOCmcJ9MA03gtsK5oc4N4FH2thuhMjmv7_T6z@mail.gmail.com>
	<1301167611.17567.12.camel@Joe-Laptop>
Date: Sat, 26 Mar 2011 20:33:02 +0100
Message-ID: <AANLkTim86tYiuEfDV5MumNHr_7BOtN0G7zGPDokVd=Tj@mail.gmail.com>
Subject: Re: [PATCH 2/4] staging: keucr: smscsi: Includes missing KERN_
 facility level to printk().
From: Ralf Thielow <ralf.thielow@googlemail.com>
To: Joe Perches <joe@perches.com>
Cc: devel@driverdev.osuosl.org, gregkh@suse.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ooops, i thougth i can trust "make M=***".

Thanks!

2011/3/26 Joe Perches <joe@perches.com>:
> On Sat, 2011-03-26 at 20:11 +0100, Ralf Thielow wrote:
>> Of course, the whole staging directory with "make clean
>> M=drivers/staging && make M=drivers/staging".
>> You're right. The "printk" function accept these but it's wrong.
>
> Then you didn't really compile test it.
> I suggest you check your compilation commands.
>
> For instance:
>
> diff --git a/drivers/staging/keucr/smscsi.c b/drivers/staging/keucr/smscsi.c
> index 6211686..dd3cf95 100644
> --- a/drivers/staging/keucr/smscsi.c
> +++ b/drivers/staging/keucr/smscsi.c
> @@ -98,7 +98,7 @@ int SM_SCSI_Read_Capacity(struct us_data *us, struct scsi_cmnd *srb)
>        WORD    bl_len;
>        BYTE    buf[8];
>
> -       printk("SM_SCSI_Read_Capacity\n");
> +       printk(KERN_DEBUG, "SM_SCSI_Read_Capacity\n");
>
>        bl_len = 0x200;
>        bl_num = Ssfdc.MaxLogBlocks * Ssfdc.MaxSectors * Ssfdc.MaxZones - 1;
>
> $ make drivers/staging/keucr/smscsi.o
>  CHK     include/linux/version.h
>  CHK     include/generated/utsrelease.h
>  CALL    scripts/checksyscalls.sh
>  CC      drivers/staging/keucr/smscsi.o
> drivers/staging/keucr/smscsi.c: In function ‘SM_SCSI_Read_Capacity’:
> drivers/staging/keucr/smscsi.c:101:2: warning: too many arguments for format
>
>
>
