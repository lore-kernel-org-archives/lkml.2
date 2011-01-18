Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab1ARRXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 12:23:37 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:32877 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab1ARRXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 12:23:34 -0500
Date: Tue, 18 Jan 2011 09:21:51 -0800
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: gregkh@suse.de, chris.mason@oracle.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, matthew@wil.cx,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, ngupta@vflare.org,
        jeremy@goop.org, kurt.hackel@oracle.com, npiggin@kernel.dk,
        riel@redhat.com, konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        mel@csn.ul.ie, minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        sfr@canb.auug.org.au, wfg@mail.ustc.edu.cn, tytso@mit.edu,
        viro@ZenIV.linux.org.uk, hughd@google.com, hannes@cmpxchg.org
Subject: [PATCH V1 3/3] drivers/staging: kztmem: misc build/config
Message-ID: <20110118172151.GA20507@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH V1 3/3] drivers/staging: kztmem: misc build/config

Makefiles and Kconfigs to build kztmem in drivers/staging

There is a dependency on xvmalloc.* which in 2.6.37 resides
in drivers/staging/zram.  Should this move or disappear,
some Makefile/Kconfig changes will be required.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

---

Diffstat:
 drivers/staging/Kconfig                  |    2 ++
 drivers/staging/Makefile                 |    1 +
 drivers/staging/kztmem/Kconfig           |    8 ++++++++
 drivers/staging/kztmem/Makefile          |    1 +
 4 files changed, 12 insertions(+)

--- linux-2.6.37/drivers/staging/kztmem/Makefile	1969-12-31 17:00:00.000000000 -0700
+++ linux-2.6.37-kztmem/drivers/staging/kztmem/Makefile	2011-01-13 15:44:24.000000000 -0700
@@ -0,0 +1 @@
+obj-$(CONFIG_KZTMEM)	+=	kztmem.o tmem.o
--- linux-2.6.37/drivers/staging/kztmem/Kconfig	1969-12-31 17:00:00.000000000 -0700
+++ linux-2.6.37-kztmem/drivers/staging/kztmem/Kconfig	2011-01-13 15:44:24.000000000 -0700
@@ -0,0 +1,8 @@
+config KZTMEM
+	tristate "In-kernel transcendent memory using compression"
+	select XVMALLOC
+	select LZO_COMPRESS
+	select LZO_DECOMPRESS
+	default n
+	help
+	  In-kernel transcendent memory using compression
--- linux-2.6.37/drivers/staging/Makefile	2011-01-04 17:50:19.000000000 -0700
+++ linux-2.6.37-kztmem/drivers/staging/Makefile	2011-01-13 15:44:24.000000000 -0700
@@ -44,6 +44,7 @@ obj-$(CONFIG_VME_BUS)		+= vme/
 obj-$(CONFIG_MRST_RAR_HANDLER)	+= memrar/
 obj-$(CONFIG_IIO)		+= iio/
 obj-$(CONFIG_ZRAM)		+= zram/
+obj-$(CONFIG_KZTMEM)		+= kztmem/
 obj-$(CONFIG_WLAGS49_H2)	+= wlags49_h2/
 obj-$(CONFIG_WLAGS49_H25)	+= wlags49_h25/
 obj-$(CONFIG_BATMAN_ADV)	+= batman-adv/
--- linux-2.6.37/drivers/staging/Kconfig	2011-01-04 17:50:19.000000000 -0700
+++ linux-2.6.37-kztmem/drivers/staging/Kconfig	2011-01-13 15:44:24.000000000 -0700
@@ -123,6 +123,8 @@ source "drivers/staging/iio/Kconfig"
 
 source "drivers/staging/zram/Kconfig"
 
+source "drivers/staging/kztmem/Kconfig"
+
 source "drivers/staging/wlags49_h2/Kconfig"
 
 source "drivers/staging/wlags49_h25/Kconfig"
