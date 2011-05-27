Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab1E0FyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 01:54:06 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:49201 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189Ab1E0FyF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 01:54:05 -0400
From: Xiangliang Yu <yuxiangl@marvell.com>
To: "thomas@fjellstrom.ca" <thomas@fjellstrom.ca>,
        "yxlraid@gmail.com" <yxlraid@gmail.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jacky Feng <jfeng@marvell.com>
Date: Thu, 26 May 2011 22:53:39 -0700
Subject: RE: [PATCH 1/9] [SCSI] mvsas: Add support for Non specific NCQ
 error interrupt
Thread-Topic: [PATCH 1/9] [SCSI] mvsas: Add support for Non specific NCQ
 error interrupt
Thread-Index: AcwcMOVW3JBptyECQECDxlxbJlaWcAAAHFkg
Message-ID: <F766E4F80769BD478052FB6533FA745D19FAD8493E@SC-VEXCH4.marvell.com>
References: <mvsas-ncq> <1306247210-5888-1-git-send-email-yxlraid@gamil.com>
 <201105262342.33985.thomas@fjellstrom.ca>
In-Reply-To: <201105262342.33985.thomas@fjellstrom.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> From: Xiangliang Yu <yuxiangl@marvell.com>
>> 
>> -- Add support for Non specific NCQ error interrupt.
>> 

>I apologize if this has been covered, but do these changes or the ones made a
>month ago fix the issues people have been having with the mvsas driver on 64xx
>based cards like my AOC-SASLP-MV8 (based on a MV64460/64461/64462 Rev B)?

>I have a relatively recent 2.6.38 kernel running the box with the mvsas
>controller (with 7 SATA drives). I've noticed it doesn't panic when plugging
>in a drive which is nice, but I don't have the courage to attempt a hot
>unplug. I am still getting a significant number of device reset and libata
>invalid sector 0 errors.

>Example of such errors:

>[394488.800081] >/build/buildd-linux-2.6_2.6.38-4-amd64-eEW_ml/linux-2.6-2.6.38/debian/build>/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1632:mvs_query_task:rc= 5
>[394491.008046] /build/buildd-linux-2.6_2.6.38-4-amd64-eEW_ml/linux-2.6-2.6.38/debian/build/>source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for >device[3]:rc= 0
>[394491.008070] ata12: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ >0xb/00/00
>[394491.008519] ata12.00: device reported invalid CHS sector 0
>[394491.008526] ata12: status=0x01 { Error }
>[394491.008532] ata12: error=0x04 { DriveStatusError }

>I get at least 10 of those a day. (it is better than it was)

It need libsas SATA NCQ error handler, and I have committed a patch. The patch is: http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=bb650a1bef73a8c1fd076fae4c4f0701cf3b5f25
Please wait it to apply to kernel, and try again. Thanks!
