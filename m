Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab1E0Fml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 01:42:41 -0400
Received: from mail.tomasu.net ([64.85.170.232]:36707 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab1E0Fmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 01:42:40 -0400
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: yxlraid@gmail.com
Subject: Re: [PATCH 1/9] [SCSI] mvsas: Add support for Non specific NCQ error interrupt
Date: Thu, 26 May 2011 23:42:33 -0600
User-Agent: KMail/1.13.7 (Linux/2.6.39-1-amd64; KDE/4.6.2; x86_64; ; )
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        yuxiangl@marvell.com, jfeng@marvell.com
References: <mvsas-ncq> <1306247210-5888-1-git-send-email-yxlraid@gamil.com>
In-Reply-To: <1306247210-5888-1-git-send-email-yxlraid@gamil.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105262342.33985.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 24, 2011, yxlraid@gmail.com wrote:
> From: Xiangliang Yu <yuxiangl@marvell.com>
> 
> -- Add support for Non specific NCQ error interrupt.
> 

I apologize if this has been covered, but do these changes or the ones made a
month ago fix the issues people have been having with the mvsas driver on 64xx
based cards like my AOC-SASLP-MV8 (based on a MV64460/64461/64462 Rev B)?

I have a relatively recent 2.6.38 kernel running the box with the mvsas
controller (with 7 SATA drives). I've noticed it doesn't panic when plugging
in a drive which is nice, but I don't have the courage to attempt a hot
unplug. I am still getting a significant number of device reset and libata
invalid sector 0 errors.

Example of such errors:

[394488.800081] /build/buildd-linux-2.6_2.6.38-4-amd64-eEW_ml/linux-2.6-2.6.38/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1632:mvs_query_task:rc= 5
[394491.008046] /build/buildd-linux-2.6_2.6.38-4-amd64-eEW_ml/linux-2.6-2.6.38/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[3]:rc= 0
[394491.008070] ata12: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
[394491.008519] ata12.00: device reported invalid CHS sector 0
[394491.008526] ata12: status=0x01 { Error }
[394491.008532] ata12: error=0x04 { DriveStatusError }

I get at least 10 of those a day. (it is better than it was)

Thanks.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
