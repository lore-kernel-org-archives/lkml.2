Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750Ab2BNRNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 12:13:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756793Ab2BNRNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 12:13:05 -0500
Message-ID: <4F3A95E9.9@redhat.com>
Date: Tue, 14 Feb 2012 18:12:09 +0100
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
CC: Jens Axboe <axboe@kernel.dk>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: [PATCH] cciss: add some older controllers to the kdump blacklist
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some other older controllers also do have problems to perform a kdump.
Adding controllers to this list means that the driver will signal
this non-ability via a resettable flag correctly. 
The unsupported list was created after a consultation with HP.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>


diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 2047978..e394f2c 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -585,6 +585,12 @@ static u32 unresettable_controller[] = {
 	0x40800E11, /* Smart Array 5i */
 	0x409C0E11, /* Smart Array 6400 */
 	0x409D0E11, /* Smart Array 6400 EM */
+	0x40700E11, /* Smart Array 5300 */
+	0x40820E11, /* Smart Array 532 */
+	0x40830E11, /* Smart Array 5312 */
+	0x409A0E11, /* Smart Array 641 */
+	0x409B0E11, /* Smart Array 642 */
+	0x40910E11, /* Smart Array 6i */
 };
 
 /* List of controllers which cannot even be soft reset */
@@ -592,6 +598,12 @@ static u32 soft_unresettable_controller[] = {
 	0x40800E11, /* Smart Array 5i */
 	0x409C0E11, /* Smart Array 6400 */
 	0x409D0E11, /* Smart Array 6400 EM */
+	0x40700E11, /* Smart Array 5300 */
+	0x40820E11, /* Smart Array 532 */
+	0x40830E11, /* Smart Array 5312 */
+	0x409A0E11, /* Smart Array 641 */
+	0x409B0E11, /* Smart Array 642 */
+	0x40910E11, /* Smart Array 6i */
 };
 
 static int ctlr_is_hard_resettable(u32 board_id)


