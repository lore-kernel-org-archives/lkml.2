Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275Ab1CSX0Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 19:26:24 -0400
Received: from smtp.seznam.cz ([77.75.76.43]:39535 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab1CSX0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 19:26:21 -0400
X-Greylist: delayed 821 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Mar 2011 19:26:21 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=email.cz;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:Content-Type:X-Smtpd:X-Seznam-User:X-Session:X-Country:X-Virus-Info:X-Seznam-SPF:X-Seznam-DomainKeys;
	b=Mp9/6MjZAYWyFMDjVDTYs+wtqVj929GPaPzdMSmsQuP2uxnG0V/fcO8+selIR1xjD
	v/1DytgcbHMPq8H9XpGitOza1fLiSEco/u/OXbixhmwOeduddivTeJ93ejbPqd7avA1
	LqRil9TqgS/n60D2UMyM9omKbqegBzqSX4GuHnU=
Message-ID: <4D853861.7010206@email.cz>
Date: Sun, 20 Mar 2011 00:12:33 +0100 
From: =?UTF-8?B?TWlyZWsgU2x1Z2XFiA==?= <thunder.m@email.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; cs-CZ; rv:1.9.1.16) Gecko/20101227 Iceape/2.0.11 
MIME-Version: 1.0 
To: linux-dvb@linuxtv.org
CC: linux-kernel@vger.kernel.org
Subject: Patch for broken radio in XC2k and XC3k tuners 
Content-Type: multipart/mixed;  boundary="------------020609000506040405000006" 
X-Smtpd: 1.2.14@16206 
X-Seznam-User: thunder.m@email.cz 
X-Session: 19034 
X-Country: CZ 
X-Virus-Info: clean
X-Seznam-SPF: neutral
X-Seznam-DomainKeys: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020609000506040405000006
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi, I am very supprised that no one complains about broken radio support 
on devices with XC2k and XC3k tuner, it is broken since commit:

V4L/DVB: tuner-xc2028: fix tuning logic to solve a regression in Australia

from date 19.3.2010

BUG is present in current kernel stable version 2.6.38 and also olders 
like 2.6.37, fix is very trivial.

I tested this fix with Leadtek DTV1800H radio and it works great, before 
this fix I can listen so much of noise on tuned frequency (so something 
wrong with tuning).

Feel free to modify this patch :)

M. Slugen

--------------020609000506040405000006
Content-Type: text/x-patch;
 name="kernel_xc2000_radio.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="kernel_xc2000_radio.diff"

--- linux-2.6.37.2.old/drivers/media/common/tuners/tuner-xc2028.c	2011-03-19 23:25:28.000000000 +0100
+++ linux-2.6.37.2/drivers/media/common/tuners/tuner-xc2028.c	2011-03-19 23:26:13.458252000 +0100
@@ -937,6 +937,8 @@
 		rc = send_seq(priv, {0x00, 0x00});
 
 		/* Analog modes require offset = 0 */
+	} else if (new_mode == T_RADIO) {
+		/* nop */
 	} else {
 		/*
 		 * Digital modes require an offset to adjust to the

--------------020609000506040405000006--
