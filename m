Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965145Ab2DKXtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:49:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58738 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933387Ab2DKXVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:21:48 -0400
Message-Id: <20120411231037.053933012@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:10:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Daniel Schwierzeck <daniel.schwierzeck@googlemail.com>,
        John Crispin <blogic@openwrt.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 09/59] mtd: mips: lantiq: reintroduce support for cmdline partitions
In-Reply-To: <20120411231213.GA13124@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Schwierzeck <daniel.schwierzeck@googlemail.com>

commit bf011f2ed53d587fdd8148c173c4f09ed77bdf1a upstream.

Since commit ca97dec2ab5c87e9fbdf7e882e1820004a3966fa the
command line parsing of MTD partitions does not work anymore.

Signed-off-by: Daniel Schwierzeck <daniel.schwierzeck@googlemail.com>
Signed-off-by: John Crispin <blogic@openwrt.org>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Acked-by: John Crispin <blogic@openwrt.org>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/maps/lantiq-flash.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mtd/maps/lantiq-flash.c
+++ b/drivers/mtd/maps/lantiq-flash.c
@@ -45,6 +45,7 @@ struct ltq_mtd {
 };
 
 static char ltq_map_name[] = "ltq_nor";
+static const char *ltq_probe_types[] __devinitconst = { "cmdlinepart", NULL };
 
 static map_word
 ltq_read16(struct map_info *map, unsigned long adr)
@@ -168,7 +169,7 @@ ltq_mtd_probe(struct platform_device *pd
 	cfi->addr_unlock1 ^= 1;
 	cfi->addr_unlock2 ^= 1;
 
-	err = mtd_device_parse_register(ltq_mtd->mtd, NULL, 0,
+	err = mtd_device_parse_register(ltq_mtd->mtd, ltq_probe_types, 0,
 			ltq_mtd_data->parts, ltq_mtd_data->nr_parts);
 	if (err) {
 		dev_err(&pdev->dev, "failed to add partitions\n");


