Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab2F0A7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:59:24 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:12908 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2F0A7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:59:23 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-127.messagelabs.com!1340758762!6930477!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 19/36] staging: comedi: cb_pcidas: cleanup the boardinfo 3
Date: Tue, 26 Jun 2012 17:59:17 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261759.17435.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the ai_diff_chans variable. This option is not used in
the driver. If it is used later, the value can be easily found
by using ai_se_chans/2.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index f7090de..59b0f91 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -240,7 +240,6 @@ struct cb_pcidas_board {
 	const char *name;
 	unsigned short device_id;
 	int ai_se_chans;	/*  Inputs in single-ended mode */
-	int ai_diff_chans;	/*  Inputs in differential mode */
 	int ai_bits;		/*  analog input resolution */
 	int ai_speed;		/*  fastest conversion period in ns */
 	int ao_nchan;		/*  number of analog out channels */
@@ -258,7 +257,6 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 		.name		= "pci-das1602/16",
 		.device_id	= 0x1,
 		.ai_se_chans	= 16,
-		.ai_diff_chans	= 8,
 		.ai_bits	= 16,
 		.ai_speed	= 5000,
 		.ao_nchan	= 2,
@@ -273,7 +271,6 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 		.name		= "pci-das1200",
 		.device_id	= 0xF,
 		.ai_se_chans	= 16,
-		.ai_diff_chans	= 8,
 		.ai_bits	= 12,
 		.ai_speed	= 3200,
 		.ao_nchan	= 2,
@@ -284,7 +281,6 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 		.name		= "pci-das1602/12",
 		.device_id	= 0x10,
 		.ai_se_chans	= 16,
-		.ai_diff_chans	= 8,
 		.ai_bits	= 12,
 		.ai_speed	= 3200,
 		.ao_nchan	= 2,
@@ -298,7 +294,6 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 		.name		= "pci-das1200/jr",
 		.device_id	= 0x19,
 		.ai_se_chans	= 16,
-		.ai_diff_chans	= 8,
 		.ai_bits	= 12,
 		.ai_speed	= 3200,
 		.fifo_size	= 1024,
@@ -308,7 +303,6 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 		.name		= "pci-das1602/16/jr",
 		.device_id	= 0x1C,
 		.ai_se_chans	= 16,
-		.ai_diff_chans	= 8,
 		.ai_bits	= 16,
 		.ai_speed	= 5000,
 		.fifo_size	= 512,
@@ -320,7 +314,6 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 		.name		= "pci-das1000",
 		.device_id	= 0x4C,
 		.ai_se_chans	= 16,
-		.ai_diff_chans	= 8,
 		.ai_bits	= 12,
 		.ai_speed	= 4000,
 		.fifo_size	= 1024,
@@ -330,7 +323,6 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 		.name		= "pci-das1001",
 		.device_id	= 0x1a,
 		.ai_se_chans	= 16,
-		.ai_diff_chans	= 8,
 		.ai_bits	= 12,
 		.ai_speed	= 6800,
 		.ao_nchan	= 2,
@@ -341,7 +333,6 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 		.name		= "pci-das1002",
 		.device_id	= 0x1b,
 		.ai_se_chans	= 16,
-		.ai_diff_chans	= 8,
 		.ai_bits	= 12,
 		.ai_speed	= 6800,
 		.ao_nchan	= 2,
-- 
1.7.11

