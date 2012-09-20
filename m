Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab2ITNsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 09:48:08 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59644 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2ITNsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 09:48:05 -0400
MIME-Version: 1.0
Date: Thu, 20 Sep 2012 15:48:04 +0200
Message-ID: <CAHODtZTFP=KJh1VmBvCcYLWD=M41vBnf_nyoEbvHKW1UzYx8dQ@mail.gmail.com>
Subject: Fix bug in end absolute address in drivers/mtd/devices/slram.c
From: Jiri Engelthaler <engycz@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
  I found a bug in parsing end absolute address in
drivers/mtd/devices/slram.c. There is checking for startaddress <
endaddress and endaddress subtracted by startaddress before check. The
bug is there from commit 3afd522de8d8ec446efe957b86e4f63e3dd8ce9d Mon,
19 Jan 2009 01:24:21 +0000

Here is the patch

Signed-off-by: Jiri Engelthaler <engycz@gmail.com>

--- linux-3.2.28/drivers/mtd/devices/slram.c	2012-08-19 19:15:38.000000000 +0200
+++ linux-3.2.28.mod/drivers/mtd/devices/slram.c	2012-09-19
18:29:28.012740703 +0200
@@ -266,7 +266,7 @@ static int parse_cmdline(char *devname,

 	if (*(szlength) != '+') {
 		devlength = simple_strtoul(szlength, &buffer, 0);
-		devlength = handle_unit(devlength, buffer) - devstart;
+		devlength = handle_unit(devlength, buffer);
 		if (devlength < devstart)
 			goto err_out;
