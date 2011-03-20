Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab1CTWFC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 18:05:02 -0400
Received: from smtp.seznam.cz ([77.75.76.43]:33923 "EHLO smtp.seznam.cz"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751186Ab1CTWFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 18:05:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=email.cz;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:Content-Type:X-Smtpd:X-Seznam-User:X-Session:X-Country:X-Virus-Info:X-Seznam-SPF:X-Seznam-DomainKeys;
	b=XqiVxlr5dwZ14EizX2aXf6qDSHxPE3tVIxCne49sTGyGBl8xQoc00PkiD6I0iZWJA
	oTUz7KY1MoBxDgC5p3nLmibaEQLMIbgOHPSv0uPGRLRXVJaKTJZ5KH1YweBRlVLQHPE
	eh6TUUeQAuypLLt4mqOcrVpWa4DqwHN4o5Tbxu0=
Message-ID: <4D867A0C.7050809@email.cz>
Date: Sun, 20 Mar 2011 23:05:00 +0100 
From: =?UTF-8?B?TWlyZWsgU2x1Z2XFiA==?= <thunder.m@email.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; cs-CZ; rv:1.9.1.16) Gecko/20101227 Iceape/2.0.11 
MIME-Version: 1.0 
To: linux-dvb@linuxtv.org
CC: linux-kernel@vger.kernel.org
Subject: PATCH: Leadtek DTVb1800H require longer delay for tuner reset 
Content-Type: multipart/mixed;  boundary="------------040909000204060505020902" 
X-Smtpd: 1.2.14@16206 
X-Seznam-User: thunder.m@email.cz 
X-Session: 1265 
X-Country: CZ 
X-Virus-Info: clean
X-Seznam-SPF: neutral
X-Seznam-DomainKeys: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040909000204060505020902
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

	I am using alot of tuners Leadtek DTV1800H under Linux, minimum 5 
devices per one PC with kernel 2.6.37.4. I discovered bug which I can se 
very often but not always. When device tuner is reseted there is not 
enough time to do all needed stuff and sometimes (randomly) kernel show 
this message:

[  821.369647] cx88[0]/1: IRQ loop detected, disabling interrupts

Patch is again very simple, we need to adjust time in reset function 
after cx_clear and cx_set calls from 50 to 75 us. I tested this patch on 
4 PC with similar problems and all are without this issue.

M. Slugen

--------------040909000204060505020902
Content-Type: text/x-patch;
 name="kernel_cx88_reset.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="kernel_cx88_reset.diff"

diff -Naur linux-2.6.37.4.old//drivers/media/video/cx88/cx88-cards.c linux-2.6.37.4/drivers/media/video/cx88/cx88-cards.c
--- linux-2.6.37.4.old//drivers/media/video/cx88/cx88-cards.c	2011-03-20 21:30:52.000000000 +0100
+++ linux-2.6.37.4/drivers/media/video/cx88/cx88-cards.c	2011-03-20 22:25:54.710228001 +0100
@@ -3019,9 +3019,9 @@
 		cx_set(MO_GP1_IO, 0x1010);
 		mdelay(50);
 		cx_clear(MO_GP1_IO, 0x10);
-		mdelay(50);
+		mdelay(75);
 		cx_set(MO_GP1_IO, 0x10);
-		mdelay(50);
+		mdelay(75);
 		return 0;
 	}
 	return -EINVAL;

--------------040909000204060505020902--
