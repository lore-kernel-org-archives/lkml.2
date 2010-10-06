Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759940Ab0JFVTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 17:19:25 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:43807 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754752Ab0JFVTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 17:19:24 -0400
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: "Yang, Bo" <Bo.Yang@lsi.com>, James Bottomley <James.Bottomley@suse.de>,
        bo yang <boyang1288@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "akpm@osdl.org" <akpm@osdl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Austria, Winston" <Winston.Austria@lsi.com>,
        "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>,
        "Patro, Sumant" <Sumant.Patro@lsi.com>,
        "Maharana, Parag" <Parag.Maharana@lsi.com>
Date: Wed, 6 Oct 2010 15:19:14 -0600
Subject: RE: PATCH 1/5] scsi: megaraid_sas - Add Online Controller Reset to
 MegaRAID SAS driver
Thread-Topic: PATCH 1/5] scsi: megaraid_sas - Add Online Controller Reset to
 MegaRAID SAS driver
Thread-Index: ActVALyQv5F9Hsw+QwGwA6RBwdnuIwAGLIKAAYG/BfACnr2y0A==
Message-ID: <4B6A08C587958942AA3002690DD4F8C30100F547AD@cosmail02.lsi.com>
References: <AANLkTineJ0dFcqi5v1h75EYgpBOSqvHsSSTi=VJWsjM0@mail.gmail.com>
 <1284573984.8296.83.camel@mulgrave.site>  
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o96LJkQS026614

James,

Do you get the chances to look at and apply our megaraid sas patches (5 patches) to upstream?  The patches I submitted is the version 4.31.  We have more patches need to submit after those patches accepted to upstream.

Thanks,

Bo Yang

From: Yang, Bo 
Sent: Thursday, September 23, 2010 9:20 AM
To: Yang, Bo; 'James Bottomley'; 'bo yang'
Cc: Austria, Winston; Daftardar, Jayant; Patro, Sumant; Maharana, Parag
Subject: RE: PATCH 1/5] scsi: megaraid_sas - Add Online Controller Reset to MegaRAID SAS driver

James,

Just let you know I submitted our megaraid_sas patches (I tested and applied fine) to upgrade the driver version to 4.31.  Those patches already accepted by rhel and sles.  Our customers are also asking us when they can be accepted by upstream.  Can you give us the hand? 

Thanks,

Bo Yang

-----Original Message-----
From: Yang, Bo 
Sent: Wednesday, September 15, 2010 5:05 PM
To: 'James Bottomley'; bo yang
Cc: linux-scsi@vger.kernel.org; akpm@osdl.org; linux-kernel@vger.kernel.org
Subject: RE: PATCH 1/5] scsi: megaraid_sas - Add Online Controller Reset to MegaRAID SAS driver

James,

I used gmail to send the patches.  Looks like gmail broken those lines.  I am fixing it.

Regards,

Bo Yang



-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@suse.de] 
Sent: Wednesday, September 15, 2010 2:06 PM
To: bo yang
Cc: linux-scsi@vger.kernel.org; akpm@osdl.org; linux-kernel@vger.kernel.org; Yang, Bo
Subject: Re: PATCH 1/5] scsi: megaraid_sas - Add Online Controller Reset to MegaRAID SAS driver

On Tue, 2010-09-07 at 13:08 -0400, bo yang wrote:
> Re-Submit:

This still doesn't apply:

> To add the OCR support, driver need to do:
> 		a). reset the controller chips -- Xscale and Gen2 which
> 		will change the function calls and add the reset function
> 		related to this two chips.
> 		
> 		b). during the reset, driver will store the pending cmds
> 		which not returned by FW to driver's pending queue.  Driver
> 		will re-issue those pending cmds again to FW after the OCR
> 		finished.
> 		
> 		c). In driver's timeout routine, driver will report to
> 		OS as reset. Also driver's queue routine will block the
> 		cmds until the OCR finished.
> 		
> 		d). in Driver's ISR routine, if driver get the FW state as
> 		state change, FW in Failure status and FW support online controller
> 		reset (OCR), driver will start to do the controller reset.
> 		
> 		e). In driver's IOCTL routine, the application cmds will wait for the
> 		OCR to finish, then issue the cmds to FW.
> 
> Signed-off-by Bo Yang<bo.yang@lsi.com>
> 
> ---
>  Documentation/scsi/ChangeLog.megaraid_sas |   33 +
>  drivers/scsi/megaraid/megaraid_sas.c      |  761 +++++++++++++++++++++++++++---
>  drivers/scsi/megaraid/megaraid_sas.h      |   88 +++
>  3 files changed, 823 insertions(+), 59 deletions(-)
> diff -rupN old/Documentation/scsi/ChangeLog.megaraid_sas
> new/Documentation/scsi/ChangeLog.megaraid_sas
> --- old/Documentation/scsi/ChangeLog.megaraid_sas	2010-09-06
> 03:13:15.000000000 -0400
> +++ new/Documentation/scsi/ChangeLog.megaraid_sas	2010-09-06
> 04:48:10.000000000 -0400

This set of lines is still broken

> @@ -1,3 +1,36 @@
> +1 Release Date:	Thur.  May 03, 2010 09:12:45 PST 2009 -
> +			(emaild-id:megaraidlinux@lsi.com)
> +			Bo Yang
> +
> +2 Current Version : 00.00.04.17.1-rc1
> +3 Older Version   : 00.00.04.17.1-rc1
> +
> +1.	Add the Online Controller Reset (OCR) to the Driver.
> +	OCR is the new feature for megaraid_sas driver which
> +	will allow the fw to do the chip reset which will not
> +	affact the OS behavious.
> +
> +	To add the OCR support, driver need to do:
> +		a). reset the controller chips -- Xscale and Gen2 which
> +		will change the function calls and add the reset function
> +		related to this two chips.
> +		
> +		b). during the reset, driver will store the pending cmds
> +		which not returned by FW to driver's pending queue.  Driver
> +		will re-issue those pending cmds again to FW after the OCR
> +		finished.
> +		
> +		c). In driver's timeout routine, driver will report to
> +		OS as reset. Also driver's queue routine will block the
> +		cmds until the OCR finished.
> +		
> +		d). in Driver's ISR routine, if driver get the FW state as
> +		state change, FW in Failure status and FW support online controller
> +		reset (OCR), driver will start to do the controller reset.
> +		
> +		e). In driver's IOCTL routine, the application cmds will wait for the
> +		OCR to finish, then issue the cmds to FW.
> +		
>  1 Release Date    : Thur.  Oct 29, 2009 09:12:45 PST 2009 -
>  			(emaild-id:megaraidlinux@lsi.com)
>  			Bo Yang
> diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c
> new/drivers/scsi/megaraid/megaraid_sas.c
> --- old/drivers/scsi/megaraid/megaraid_sas.c	2010-09-06 03:13:15.000000000 -0400
> +++ new/drivers/scsi/megaraid/megaraid_sas.c	2010-09-06 03:17:11.000000000 -0400
> @@ -104,8 +104,14 @@ static u32 megasas_dbg_lvl;
>  spinlock_t poll_aen_lock;
> 
>  static void
> -megasas_complete_cmd(struct megasas_instance *instance, struct
> megasas_cmd *cmd,

As is this.

You can check this yourself: just try to apply the patch you get back
from the mailing list.

James


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
