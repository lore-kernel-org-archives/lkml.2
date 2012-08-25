Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab2HYUhF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 16:37:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56399 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab2HYUhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 16:37:02 -0400
MIME-Version: 1.0
Date: Sat, 25 Aug 2012 16:37:01 -0400
Message-ID: <CAGh4K3+7+4E0rt1Lwu-z1n-XrDtaiE4Vk82S0a98GVo4VnDA7Q@mail.gmail.com>
Subject: [PATCH]:dir.c patch
From: Christopher Sacchi <chris.sacchi@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a non-style issue dir.c-patch, and as far as I can see from
the lines of code, the compilation errors weren't about what I put in.
This patch fixes a "break" statement inside an "if" statement, as
obviously not correct.
Here's the patch for the kernel version v3.6.0rc3:

--
Signed-off-by: Christopher P. Sacchi <chris.sacchi@gmail.com>
--- dir.c	2012-08-25 15:47:24.260443900 -0400
+++ dir.c	2012-08-25 16:02:05.458845600 -0400
@@ -580,7 +580,6 @@ static int ext4_dx_readdir(struct file *
 				return ret;
 			if (ret == 0) {
 				filp->f_pos = ext4_get_htree_eof(filp);
-				break;
 			}
 			info->curr_node = rb_first(&info->root);
 		}

--

-- 
Christopher
