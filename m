Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab1CVW7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 18:59:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35705 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab1CVW7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 18:59:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=s3ULQxGnHfjr2fJq5307T8G6oxunEhbf64tg5LeOLDXK8g5X7Bmpzvj9fyFCX/oPwk
         ghCFDZXVsalPuMSsFHb6joV9IEMUndeOggsliaUnYrC1gBaaD6JPAVDyHnJC5uLnB3rQ
         0aBEvbgyPTU9UirDY61hnwdsJnDinJf6Zu6gs=
Date: Wed, 23 Mar 2011 01:59:24 +0300
From: Dan Carpenter <error27@gmail.com>
To: Ralf Thielow <ralf.thielow@googlemail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        egooon@gmail.com
Subject: Re: [PATCH] staging: keucr: smscsi: fixed coding style issues
Message-ID: <20110322225924.GS2008@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Ralf Thielow <ralf.thielow@googlemail.com>, gregkh@suse.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	egooon@gmail.com
References: <1300828889-8273-1-git-send-email-ralf.thielow@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300828889-8273-1-git-send-email-ralf.thielow@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 10:21:29PM +0100, Ralf Thielow wrote:
> Fixed coding style issues.

This patch description is not very good.

> diff --git a/drivers/staging/keucr/smscsi.c b/drivers/staging/keucr/smscsi.c
> index 6211686..821a162 100644
> --- a/drivers/staging/keucr/smscsi.c
> +++ b/drivers/staging/keucr/smscsi.c
> @@ -9,76 +9,78 @@
>  #include "usb.h"
>  #include "scsiglue.h"
>  #include "transport.h"
> -//#include "smcommon.h"
> +/* #include "smcommon.h" */

Just delete this comment.

>  #include "smil.h"
>  
> -int SM_SCSI_Test_Unit_Ready (struct us_data *us, struct scsi_cmnd *srb);
> -int SM_SCSI_Inquiry         (struct us_data *us, struct scsi_cmnd *srb);
> -int SM_SCSI_Mode_Sense      (struct us_data *us, struct scsi_cmnd *srb);
> -int SM_SCSI_Start_Stop      (struct us_data *us, struct scsi_cmnd *srb);
> -int SM_SCSI_Read_Capacity   (struct us_data *us, struct scsi_cmnd *srb);
> -int SM_SCSI_Read            (struct us_data *us, struct scsi_cmnd *srb);
> -int SM_SCSI_Write           (struct us_data *us, struct scsi_cmnd *srb);
> -
> -extern struct SSFDCTYPE     Ssfdc;
> -extern struct ADDRESS       Media;
> -extern PBYTE                SMHostAddr;
> -extern DWORD                ErrXDCode;

Why move these to a seperate header file?  That should have been
explained in the changelog.  You forgot to include the header file.
Also you didn't compile this crap...  :/

> -
> -//----- SM_SCSIIrp() --------------------------------------------------
> +/* ----- SM_SCSIIrp() -------------------------------------------------- */

There are a lot of comments here that should just be deleted.  For
example this one is worthless.  If it were in kernel doc format then
it would be worthwhile, but as it is, you may as well just delete it.

All the commented out debug code should just be deleted as well.  Maybe
send 2 patches.  The first just deletes things and the second fixes up
style issues.

>  int SM_SCSIIrp(struct us_data *us, struct scsi_cmnd *srb)
>  {
>  	int    result;
>  
>  	us->SrbStatus = SS_SUCCESS;
> -	switch (srb->cmnd[0])
> -	{
> -		case TEST_UNIT_READY :  result = SM_SCSI_Test_Unit_Ready (us, srb);  break; //0x00
> -		case INQUIRY         :  result = SM_SCSI_Inquiry         (us, srb);  break; //0x12
> -		case MODE_SENSE      :  result = SM_SCSI_Mode_Sense      (us, srb);  break; //0x1A
> -		case READ_CAPACITY   :  result = SM_SCSI_Read_Capacity   (us, srb);  break; //0x25
> -		case READ_10         :  result = SM_SCSI_Read            (us, srb);  break; //0x28
> -		case WRITE_10        :  result = SM_SCSI_Write           (us, srb);  break; //0x2A

If you want you could just leave this as is.  It's readable.
checkpatch.pl is there to serve you and not the other way
around.

> -
> -		default:
> -			us->SrbStatus = SS_ILLEGAL_REQUEST;
> -			result = USB_STOR_TRANSPORT_FAILED;
> -			break;
> +	switch (srb->cmnd[0]) {
> +	case TEST_UNIT_READY:
> +		result = SM_SCSI_Test_Unit_Ready(us, srb);
> +		break; /* 0x00 */
                       ^^^^^^^^^^

This should have been on the same line as TEST_UNIT_READY.  But actually
it's a worthless comment.  Delete if you want.  Or leave it as it was as
I said before.

> -//----- SM_SCSI_Test_Unit_Ready() --------------------------------------------------
> +/* ----- SM_SCSI_Test_Unit_Ready() ----------------------------------------- */
>  int SM_SCSI_Test_Unit_Ready(struct us_data *us, struct scsi_cmnd *srb)
>  {
> -	//printk("SM_SCSI_Test_Unit_Ready\n");
> +	/* printk("SM_SCSI_Test_Unit_Ready\n"); */

This is what I mean by debug code that should just be deleted.

> @@ -98,49 +100,52 @@ int SM_SCSI_Read_Capacity(struct us_data *us, struct scsi_cmnd *srb)
>  	WORD    bl_len;
>  	BYTE    buf[8];
>  
> -	printk("SM_SCSI_Read_Capacity\n");
> +	printk(KERN_INFO, "SM_SCSI_Read_Capacity\n");

Use KERN_DEBUG or pr_debug().  In the end, we'll have to delete these
before it gets moved out of staging.  There was a similar issue in a 
different change you made.

These are behavior changes and behavior changes should always be
mentioned in the changelod.

>  
>  	bl_len = 0x200;
>  	bl_num = Ssfdc.MaxLogBlocks * Ssfdc.MaxSectors * Ssfdc.MaxZones - 1;
> -	//printk("MaxLogBlocks = %x\n", Ssfdc.MaxLogBlocks);
> -	//printk("MaxSectors   = %x\n", Ssfdc.MaxSectors);
> -	//printk("MaxZones     = %x\n", Ssfdc.MaxZones);
> -	//printk("bl_num       = %x\n", bl_num);
> +	/* printk("MaxLogBlocks = %x\n", Ssfdc.MaxLogBlocks);
> +	printk("MaxSectors   = %x\n", Ssfdc.MaxSectors);
> +	printk("MaxZones     = %x\n", Ssfdc.MaxZones);
> +	printk("bl_num       = %x\n", bl_num); */

This is not the right way to do multi-line comments.  Read CodingStyle.
>  
>  	us->bl_num = bl_num;
> -	printk("bl_len = %x\n", bl_len);
> -	printk("bl_num = %x\n", bl_num);
> -
> -	//srb->request_bufflen = 8;
> -	buf[0] = (bl_num>>24) & 0xff;
> -	buf[1] = (bl_num>>16) & 0xff;
> -	buf[2] = (bl_num>> 8) & 0xff;
> -	buf[3] = (bl_num>> 0) & 0xff;
> -	buf[4] = (bl_len>>24) & 0xff;
> -	buf[5] = (bl_len>>16) & 0xff;
> -	buf[6] = (bl_len>> 8) & 0xff;
> -	buf[7] = (bl_len>> 0) & 0xff;
> -	
> +	printk(KERN_INFO, "bl_len = %x\n", bl_len);
> +	printk(KERN_INFO, "bl_num = %x\n", bl_num);

DEBUG.

Etc.

regards,
dan carpenter
