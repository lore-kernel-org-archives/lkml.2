Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab2ITODI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:03:08 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44648 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab2ITODG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:03:06 -0400
MIME-Version: 1.0
Date: Thu, 20 Sep 2012 16:03:05 +0200
Message-ID: <CAHODtZT6UP4BCHuugpSr6q2=KoTDiGuW_hG_fqjWG7cXcTE35A@mail.gmail.com>
Subject: [PATCH] [MTD] slram: Invalid checking of absolute end address
From: Jiri Engelthaler <engycz@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed parsing end absolute address
Signed-off-by: Jiri Engelthaler <engycz@gmail.com>
---
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
