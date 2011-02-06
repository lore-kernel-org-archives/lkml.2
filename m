Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab1BFLQC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 06:16:02 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:33211 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab1BFLP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 06:15:59 -0500
From: Thomas Schlichter <thomas.schlichter@web.de>
To: Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 3/3] uvesafb: remove-ifdef-CONFIG_X86-around-ioremap
Date: Sun, 6 Feb 2011 12:14:56 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic-pae; KDE/4.5.5; i686; ; )
Cc: Michal Januszewski <spock@gentoo.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <201011271437.38126.thomas.schlichter@web.de> <20101130061051.GD17114@linux-sh.org> <201102061202.09503.thomas.schlichter@web.de>
In-Reply-To: <201102061202.09503.thomas.schlichter@web.de>
MIME-Version: 1.0
Message-Id: <201102061214.56729.thomas.schlichter@web.de>
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_wKoTNRL8bPvdXel"
X-Provags-ID: V01U2FsdGVkX1+rn4GilIssFF18ORSagKdeTLCalXMVt8/SSJXO
	3rl2YwjsRB8GgQdl89LHNZzeFUjCsfC6CCF2+C/GWTM4z1q7QS
	kNG142iT4PZwblBKpv7g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_wKoTNRL8bPvdXel
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit



--Boundary-00=_wKoTNRL8bPvdXel
Content-Type: text/x-patch;
  charset="iso-8859-15";
  name="0003-uvesafb-remove-ifdef-CONFIG_X86-around-ioremap.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="0003-uvesafb-remove-ifdef-CONFIG_X86-around-ioremap.patch"

>From d1e432f878746b699856160456f811affc3c42fe Mon Sep 17 00:00:00 2001
From: Thomas Schlichter <thomas.schlichter@web.de>
Date: Sun, 6 Feb 2011 11:45:08 +0100
Subject: [PATCH 3/3] uvesafb: remove ifdef CONFIG_X86 around ioremap in

Now that ioremap_cache() and ioremap_wc() are available on each architecture
we can remove the unneccessary ifdef in uvesafb.

Signed-off-by: Thomas Schlichter <thomas.schlichter@web.de>
---
 drivers/video/uvesafb.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index 2d6f799..ca15166 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -1567,7 +1567,6 @@ static void __devinit uvesafb_init_mtrr(struct fb_info *info)
 
 static void __devinit uvesafb_ioremap(struct fb_info *info)
 {
-#ifdef CONFIG_X86
 	switch (mtrr) {
 	case 1: /* uncachable */
 		info->screen_base = ioremap_nocache(info->fix.smem_start, info->fix.smem_len);
@@ -1583,9 +1582,6 @@ static void __devinit uvesafb_ioremap(struct fb_info *info)
 		info->screen_base = ioremap(info->fix.smem_start, info->fix.smem_len);
 		break;
 	}
-#else
-	info->screen_base = ioremap(info->fix.smem_start, info->fix.smem_len);
-#endif /* CONFIG_X86 */
 }
 
 static ssize_t uvesafb_show_vbe_ver(struct device *dev,
-- 
1.7.1


--Boundary-00=_wKoTNRL8bPvdXel--
