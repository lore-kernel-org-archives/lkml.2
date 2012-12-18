Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab2LRPGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 10:06:37 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44950 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab2LRPGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 10:06:36 -0500
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: linux-kernel@vger.kernel.org
Subject: Strange results of DIV_ROUND_CLOSEST
Date: Tue, 18 Dec 2012 16:03:41 +0100
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201212181603.42094.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

commit 263a523d18bca306016d75f5c8d5c57c37fe52fb changes the code of 
DIV_ROUND_CLOSEST in include/linux/kernel.h to fix a compile time warning.

But now feeding in a zero into this macro results into 4198403. Tested with 
gcc 4.4.3 and 4.7.2, on arch x86 and ARM.

I can reproduce this behaviour, when my ADC delivers a '0' value in the driver 
drivers/hwmon/s3c-hwmon.c in function s3c_hwmon_ch_show() with a current 
3.7.1 kernel. The value is correct again, when the ADC delivers at least 
a '1'.

Any ideas how to fix it correctly?

jbe
-- 
Pengutronix e.K.                              | Juergen Beisert             |
Linux Solutions for Science and Industry      | http://www.pengutronix.de/  |
