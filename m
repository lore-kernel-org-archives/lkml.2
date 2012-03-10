Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab2CJI7t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 03:59:49 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:44778 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab2CJI7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 03:59:48 -0500
Date: Sat, 10 Mar 2012 11:59:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: Jovi Zhang <bookjovi@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] vt: NULL dereference in vt_do_kdsk_ioctl()
Message-ID: <20120310085923.GD4647@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090201.4F5B17F6.0021,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We forgot to set the "key_map" variable here, so it's still NULL.  This
was introduced recently in 079c9534a9 "vt:tackle kbd_table".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index 70d0593..86dd1e3 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -1863,6 +1863,7 @@ int vt_do_kdsk_ioctl(int cmd, struct kbentry __user *user_kbe, int perm,
 				return -EPERM;
 			}
 			key_maps[s] = new_map;
+			key_map = new_map;
 			key_map[0] = U(K_ALLOCATED);
 			for (j = 1; j < NR_KEYS; j++)
 				key_map[j] = U(K_HOLE);
