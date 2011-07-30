Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361Ab1G3IXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 04:23:18 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60335 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab1G3IXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 04:23:10 -0400
Date: Sat, 30 Jul 2011 11:19:58 +0300
From: Dan Carpenter <error27@gmail.com>
To: bojan prtvar <prtvar.b@gmail.com>
Cc: =?iso-8859-1?Q?Jean-Fran=E7ois?= Dagenais 
	<jeff.dagenais@gmail.com>,
        Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: [patch v2] w1: fix for loop in w1_f29_remove_slave()
Message-ID: <20110730081958.GA5575@shale.localdomain>
References: <20110727095557.GL3824@shale.localdomain>
 <9C2475AA-829E-4BB8-A3D2-2444803A33D3@gmail.com>
 <CAOmT4fS1OqQb5KOOeFnGHt1tnYGBRutVrAZ4cXB6n=hou5fn8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOmT4fS1OqQb5KOOeFnGHt1tnYGBRutVrAZ4cXB6n=hou5fn8w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The for loop was looking for i <= 0 instead of i >= 0 so this
function never did anything.  Also we started with i =
NB_SYSFS_BIN_FILES instead of "NB_SYSFS_BIN_FILES - 1" which is an
off by one bug.

Reported-by: Bojan Prtvar <prtvar.b@gmail.com>
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
v2:  fix >= vs <=

diff --git a/drivers/w1/slaves/w1_ds2408.c b/drivers/w1/slaves/w1_ds2408.c
index c377818..7c8cdb8 100644
--- a/drivers/w1/slaves/w1_ds2408.c
+++ b/drivers/w1/slaves/w1_ds2408.c
@@ -373,7 +373,7 @@ static int w1_f29_add_slave(struct w1_slave *sl)
 static void w1_f29_remove_slave(struct w1_slave *sl)
 {
 	int i;
-	for (i = NB_SYSFS_BIN_FILES; i <= 0; --i)
+	for (i = NB_SYSFS_BIN_FILES - 1; i >= 0; --i)
 		sysfs_remove_bin_file(&sl->dev.kobj,
 			&(w1_f29_sysfs_bin_files[i]));
 }
