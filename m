Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab0IMNag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 09:30:36 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:44945 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753903Ab0IMNae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 09:30:34 -0400
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: "Yang, Bo" <Bo.Yang@lsi.com>, James Bottomley <James.Bottomley@suse.de>,
        bo yang <boyang1288@gmail.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "akpm@osdl.org" <akpm@osdl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>,
        "Austria, Winston" <Winston.Austria@lsi.com>
Date: Mon, 13 Sep 2010 07:20:10 -0600
Subject: RE: [PATCH 1/5] scsi: megaraid_sas - Add Online Controller Reset to
 MegaRAID SAS driver
Thread-Topic: [PATCH 1/5] scsi: megaraid_sas - Add Online Controller Reset
 to MegaRAID SAS driver
Thread-Index: ActNJMv9FbPAvOJTSaaA3BWfoXrvtQBfvm8AAALt1mAAZTiY4ADAb4VA
Message-ID: <4B6A08C587958942AA3002690DD4F8C3DC0D5280@cosmail02.lsi.com>
References: <AANLkTiktJycDkXu+FHQanTNe-djvvTe9V=9KfSkLcXZd@mail.gmail.com>
 <1283709850.15944.1277.camel@mulgrave.site>   
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o8DDUniC008406

James,

Did you be able to successfully apply the patches?  I am idling if you feel more changes needed.

Regards,

Bo Yang

-----Original Message-----
From: Yang, Bo 
Sent: Thursday, September 09, 2010 1:29 PM
To: Yang, Bo; 'James Bottomley'; 'bo yang'
Cc: 'linux-scsi@vger.kernel.org'; 'akpm@osdl.org'; 'linux-kernel@vger.kernel.org'; Daftardar, Jayant
Subject: RE: [PATCH 1/5] scsi: megaraid_sas - Add Online Controller Reset to MegaRAID SAS driver

James,

Do you have any feedback for the patches?

Thanks,

Bo Yang

-----Original Message-----
From: Yang, Bo 
Sent: Tuesday, September 07, 2010 1:12 PM
To: Yang, Bo; 'James Bottomley'; 'bo yang'
Cc: 'linux-scsi@vger.kernel.org'; 'akpm@osdl.org'; 'linux-kernel@vger.kernel.org'; Daftardar, Jayant
Subject: RE: [PATCH 1/5] scsi: megaraid_sas - Add Online Controller Reset to MegaRAID SAS driver

James,

Those were corrected and submitted.  

Thanks,

Bo Yang

-----Original Message-----
From: Yang, Bo 
Sent: Tuesday, September 07, 2010 11:54 AM
To: 'James Bottomley'; bo yang
Cc: linux-scsi@vger.kernel.org; akpm@osdl.org; linux-kernel@vger.kernel.org; Daftardar, Jayant
Subject: RE: [PATCH 1/5] scsi: megaraid_sas - Add Online Controller Reset to MegaRAID SAS driver

Thanks James,

The e-mail broken lines of the description.  I am changing the description to avoid re-submit all the patches(5 of them).

Also 

>  megasas_complete_cmd(struct megasas_instance *instance, struct
> megasas_cmd *cmd,
>  		     u8 alt_status);

Not patch line(already in the src, but more than 80 chars).

Regards,

Bo Yang    

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@suse.de] 
Sent: Sunday, September 05, 2010 2:04 PM
To: bo yang
Cc: Yang, Bo; linux-scsi@vger.kernel.org; akpm@osdl.org; linux-kernel@vger.kernel.org; Daftardar, Jayant
Subject: Re: [PATCH 1/5] scsi: megaraid_sas - Add Online Controller Reset to MegaRAID SAS driver

On Wed, 2010-08-11 at 16:45 -0400, bo yang wrote:
> To add the Online Controller Reset  (OCR) support, driver need to do:
> 		a). reset the controller chips -- Xscale and Gen2 which will change
> the function calls and add the reset function
> 		related to this two chips.
> 		
> 		b). during the reset, driver will store the pending cmds which not
> returned by FW to driver's pending queue.  Driver
> 		will re-issue those pending cmds again to FW after the OCR finished.
> 		
> 		c). In driver's timeout routine, driver will report to OS as reset.
> Also driver's queue routine will block the
> 		cmds until the OCR finished.
> 		
> 		d). in Driver's ISR routine, if driver get the FW state as state
> change, FW in Failure status and FW support online controller
> 		reset (OCR), driver will start to do the controller reset.
> 		
> 		e). In driver's IOCTL routine, the application cmds will wait for
> the OCR to finish, then issue the cmds to FW.
> 
> Signed-off-by Bo Yang<bo.yang@lsi.com>

This patch is full of line breaks which prevent application, like this
one:

> diff -rupN old/Documentation/scsi/ChangeLog.megaraid_sas
> new/Documentation/scsi/ChangeLog.megaraid_sas
> --- old/Documentation/scsi/ChangeLog.megaraid_sas	2010-08-10
> 04:58:36.000000000 -0400
> +++ new/Documentation/scsi/ChangeLog.megaraid_sas	2010-08-10
> 04:56:30.000000000 -0400
> @@ -1,3 +1,36 @@
> +1 Release Date    : Thur.  May 03, 2010 09:12:45 PST 2009 -
> +			(emaild-id:megaraidlinux@lsi.com)
> +			Bo Yang
[snip]

and this one
> diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c
> new/drivers/scsi/megaraid/megaraid_sas.c
> --- old/drivers/scsi/megaraid/megaraid_sas.c	2010-08-10 04:55:41.000000000 -0400
> +++ new/drivers/scsi/megaraid/megaraid_sas.c	2010-08-10 04:56:30.000000000 -0400
> @@ -107,6 +107,12 @@ static void
>  megasas_complete_cmd(struct megasas_instance *instance, struct
> megasas_cmd *cmd,
>  		     u8 alt_status);

Since not every long line is broken, this looks like some type of cut
and paste error ... anyway, could you fix it up, please?

Thanks,

James


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
