Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab0FUPfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 11:35:44 -0400
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:52454 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932756Ab0FUPfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 11:35:43 -0400
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: James Bottomley <James.Bottomley@suse.de>
CC: Yinghai Lu <yinghai@kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 21 Jun 2010 09:35:31 -0600
Subject: RE: [PATCH 1/12] scsi: megaraid_sas - Online Controller Reset - I:
 Enable Online Controller Reset Bit in register related functions
Thread-Topic: [PATCH 1/12] scsi: megaraid_sas - Online Controller Reset - I:
 Enable Online Controller Reset Bit in register related functions
Thread-Index: AcsQugUgIYpmrjuMSDS98Q9uUzoT2QAnKKmw
Message-ID: <4B6A08C587958942AA3002690DD4F8C3D09276BD@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
	 <AANLkTikM_rCfKKUd9vokhBi_YWg5qIPRKsnfiQiluFwl@mail.gmail.com>
	 <1277046060.5242.18.camel@mulgrave.site>
	 <4B6A08C587958942AA3002690DD4F8C3D09275CC@cosmail02.lsi.com>
	 <1277063250.5242.25.camel@mulgrave.site>
	 <4B6A08C587958942AA3002690DD4F8C3D09275CE@cosmail02.lsi.com>
 <1277066924.5242.41.camel@mulgrave.site>
In-Reply-To: <1277066924.5242.41.camel@mulgrave.site>
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
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o5LFZwim029205

James,

Attached is the changelog for OCR. 

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
Documentation/scsi/ChangeLog.megaraid_sas |   33 ++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff -rupN old/Documentation/scsi/ChangeLog.megaraid_sas new/Documentation/scsi/ChangeLog.megaraid_sas
--- old/Documentation/scsi/ChangeLog.megaraid_sas	2010-06-20 03:41:31.000000000 -0400
+++ new/Documentation/scsi/ChangeLog.megaraid_sas	2010-06-20 03:55:42.000000000 -0400
@@ -1,3 +1,36 @@
+1 Release Date    : Thur.  May 03, 2010 09:12:45 PST 2009 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Bo Yang
+
+2 Current Version : 00.00.04.17.1-rc1
+3 Older Version   : 00.00.04.17.1-rc1
+
+1.	Add the Online Controller Reset (OCR) to the Driver.
+	OCR is the new feature for megaraid_sas driver which
+	will allow the fw to do the chip reset which will not
+	affact the OS behavious.
+
+	To add the OCR support, driver need to do: 
+		a). reset the controller chips -- Xscale and Gen2 which
+		will change the function calls and add the reset function
+		related to this two chips.
+		
+		b). during the reset, driver will store the pending cmds
+		which not returned by FW to driver's pending queue.  Driver
+		will re-issue those pending cmds again to FW after the OCR
+		finished.
+		
+		c). In driver's timeout routine, driver will report to
+		OS as reset. Also driver's queue routine will block the
+		cmds until the OCR finished.
+		
+		d). in Driver's ISR routine, if driver get the FW state as
+		state change, FW in Failure status and FW support online controller
+		reset (OCR), driver will start to do the controller reset.
+		
+		e). In driver's IOCTL routine, the application cmds will wait for the
+		OCR to finish, then issue the cmds to FW.
+		 
 1 Release Date    : Thur.  Oct 29, 2009 09:12:45 PST 2009 -
 			(emaild-id:megaraidlinux@lsi.com)
 			Bo Yang


-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@suse.de] 
Sent: Sunday, June 20, 2010 4:49 PM
To: Yang, Bo
Cc: Yinghai Lu; linux-scsi@vger.kernel.org; akpm@osdl.org; linux-kernel@vger.kernel.org
Subject: RE: [PATCH 1/12] scsi: megaraid_sas - Online Controller Reset - I: Enable Online Controller Reset Bit in register related functions

On Sun, 2010-06-20 at 14:19 -0600, Yang, Bo wrote:
> Yes.  

OK, can you give me the single changelog for this one commit, then,
please?

Thanks,

James


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
