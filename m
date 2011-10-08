Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab1JHL1F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 07:27:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55301 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab1JHL1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 07:27:03 -0400
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Serieal console on Samsung S3C6410 ARM11 CPU (Was [ANNOUNCE] 3.0.6-rt17)
Date: Sat, 8 Oct 2011 13:26:58 +0200
User-Agent: KMail/1.9.10
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
References: <alpine.LFD.2.02.1110070046270.3240@ionos>
In-Reply-To: <alpine.LFD.2.02.1110070046270.3240@ionos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201110081326.58731.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> I'm pleased to announce the 3.0.6-rt17 release.

I have no idea where to search, but when I'm using the 3.0.6-rt17 on my
Samsung S3C6410 ARM based system, the UART (serial console) does not work as 
expected. Typing only one char at a time is okay. Typing two chars 
immediately makes the system using 100 % CPU load and takes about 2 seconds 
to respond. It seems the interrupt handling is broken in the UART driver, but 
I don't know how to fix it.

This with a simple cursor up (one char to get the last command) and a small 
pause to the next "ENTER" char:

root@mini6410:~ cat /proc/interrupts | grep 18:
 18:    5739107  s3c-uart  s3c6400-uart

Same again:

root@mini6410:~ cat /proc/interrupts | grep 18:
 18:    5739113  s3c-uart  s3c6400-uart

6 interrupts seems reasonable.

Now with cursor up and SPACE immediately, then a pause for ENTER:

root@mini6410:~ cat /proc/interrupts | grep 18:
 18:    5923815  s3c-uart  s3c6400-uart

184702 interrupts looks strange.

jbe

-- 
Pengutronix e.K.                              | Juergen Beisert             |
Linux Solutions for Science and Industry      | http://www.pengutronix.de/  |
