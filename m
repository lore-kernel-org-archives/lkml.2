Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab1BGEPm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 23:15:42 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:39570 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab1BGEPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 23:15:41 -0500
Date: Sun, 6 Feb 2011 19:27:09 -0800
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: gregkh@suse.de, chris.mason@oracle.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, matthew@wil.cx,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, ngupta@vflare.org,
        jeremy@goop.org, kurt.hackel@oracle.com, npiggin@kernel.dk,
        riel@redhat.com, konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        mel@csn.ul.ie, minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        sfr@canb.auug.org.au, wfg@mail.ustc.edu.cn, tytso@mit.edu,
        viro@ZenIV.linux.org.uk, hughd@google.com, hannes@cmpxchg.org
Subject: [PATCH V2 3/3] drivers/staging: zcache: misc build/config
Message-ID: <20110207032709.GA27475@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D4F71AB.004E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH V2 3/3] drivers/staging: zcache: misc build/config

Makefiles and Kconfigs to build zcache in drivers/staging

There is a dependency on xvmalloc.* which in 2.6.37 resides
in drivers/staging/zram.  Should this move or disappear,
some Makefile/Kconfig changes will be required.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Nitin Gupta <ngupta@vflare.org>

---

Diffstat:
 drivers/staging/Kconfig                  |    2 ++
 drivers/staging/Makefile                 |    1 +
 drivers/staging/zcache/Kconfig           |   13 +++++++++++++
 drivers/staging/zcache/Makefile          |    1 +
 4 files changed, 17 insertions(+)

--- linux-2.6.37/drivers/staging/zcache/Makefile	1969-12-31 17:00:00.000000000 -0700
+++ linux-2.6.37-zcache/drivers/staging/zcache/Makefile	2011-02-05 15:47:15.000000000 -0700
@@ -0,0 +1 @@
+obj-$(CONFIG_ZCACHE)	+=	zcache.o tmem.o
--- linux-2.6.37/drivers/staging/zcache/Kconfig	1969-12-31 17:00:00.000000000 -0700
+++ linux-2.6.37-zcache/drivers/staging/zcache/Kconfig	2011-02-05 15:54:10.000000000 -0700
@@ -0,0 +1,13 @@
+config ZCACHE
+	tristate "Dynamic compression of swap pages and clean pagecache pages"
+	depends on CLEANCACHE || FRONTSWAP
+	select XVMALLOC
+	select LZO_COMPRESS
+	select LZO_DECOMPRESS
+	default n
+	help
+	  Zcache doubles RAM efficiency while providing a significant
+	  performance boosts on many workloads.  Zcache uses lzo1x
+	  compression and an in-kernel implementation of transcendent
+	  memory to store clean page cache pages and swap in RAM,
+	  providing a noticeable reduction in disk I/O.
--- linux-2.6.37/drivers/staging/Makefile	2011-01-04 17:50:19.000000000 -0700
+++ linux-2.6.37-zcache/drivers/staging/Makefile	2011-02-05 15:46:16.000000000 -0700
@@ -44,6 +44,7 @@ obj-$(CONFIG_VME_BUS)		+= vme/
 obj-$(CONFIG_MRST_RAR_HANDLER)	+= memrar/
 obj-$(CONFIG_IIO)		+= iio/
 obj-$(CONFIG_ZRAM)		+= zram/
+obj-$(CONFIG_ZCACHE)		+= zcache/
 obj-$(CONFIG_WLAGS49_H2)	+= wlags49_h2/
 obj-$(CONFIG_WLAGS49_H25)	+= wlags49_h25/
 obj-$(CONFIG_BATMAN_ADV)	+= batman-adv/
--- linux-2.6.37/drivers/staging/Kconfig	2011-01-04 17:50:19.000000000 -0700
+++ linux-2.6.37-zcache/drivers/staging/Kconfig	2011-02-05 15:46:48.000000000 -0700
@@ -123,6 +123,8 @@ source "drivers/staging/iio/Kconfig"
 
 source "drivers/staging/zram/Kconfig"
 
+source "drivers/staging/zcache/Kconfig"
+
 source "drivers/staging/wlags49_h2/Kconfig"
 
 source "drivers/staging/wlags49_h25/Kconfig"
