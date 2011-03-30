Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933588Ab1C3VIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:08:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:58345 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933528Ab1C3VHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411277936"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: geert@linux-m68k.org, mchehab@redhat.com, ak@linux.intel.com,
        dannf@debian.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [132/275] radio-aimslab.c needs #include <linux/delay.h>
Message-Id: <20110330210612.AF2253E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 2400982a2e8a8e4e95f0a0e1517bbe63cc88038f upstream.

Commit e3c92215198cb6aa00ad38db2780faa6b72e0a3f ("[media] radio-aimslab.c: Fix
gcc 4.5+ bug") removed the include, but introduced new callers of msleep():

| drivers/media/radio/radio-aimslab.c: In function ‘rt_decvol’:
| drivers/media/radio/radio-aimslab.c:76: error: implicit declaration of function ‘msleep’

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: dann frazier <dannf@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/radio/radio-aimslab.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/drivers/media/radio/radio-aimslab.c
===================================================================
--- linux-2.6.35.y.orig/drivers/media/radio/radio-aimslab.c	2011-03-29 23:02:59.066324061 -0700
+++ linux-2.6.35.y/drivers/media/radio/radio-aimslab.c	2011-03-29 23:03:01.025273936 -0700
@@ -31,6 +31,7 @@
 #include <linux/module.h>	/* Modules 			*/
 #include <linux/init.h>		/* Initdata			*/
 #include <linux/ioport.h>	/* request_region		*/
+#include <linux/delay.h>	/* msleep			*/
 #include <linux/videodev2.h>	/* kernel radio structs		*/
 #include <linux/version.h>	/* for KERNEL_VERSION MACRO	*/
 #include <linux/io.h>		/* outb, outb_p			*/
