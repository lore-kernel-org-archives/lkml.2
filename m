Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab1KZRbf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 12:31:35 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:63342 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab1KZRbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 12:31:33 -0500
Date: Sat, 26 Nov 2011 18:31:25 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-iio@vger.kernel.org, greg@kroah.com, linux-kernel@vger.kernel.org
Cc: federico.vaga@gmail.com, dcobas@cern.ch, siglesia@cern.ch,
        manohar.vanga@cern.ch
Subject: [RFC PATCH 7/7] zio: insert in Kbuild so it is actually compiled
Message-ID: <df84565f623e464aa8419c4d2003701dafef9ea8.1322328076.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1322328073.git.rubini@gnudd.com>
In-Reply-To: <cover.1322328073.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
---
 drivers/Kconfig     |    2 ++
 drivers/Makefile    |    1 +
 drivers/zio/Kconfig |   12 ++++++++++++
 3 files changed, 15 insertions(+), 0 deletions(-)
 create mode 100644 drivers/zio/Kconfig

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 5289508..ef7bf06 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -118,6 +118,8 @@ source "drivers/vlynq/Kconfig"
 
 source "drivers/virtio/Kconfig"
 
+source "drivers/zio/Kconfig"
+
 source "drivers/xen/Kconfig"
 
 source "drivers/staging/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index 91077ac..96da622 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -118,6 +118,7 @@ obj-$(CONFIG_SSB)		+= ssb/
 obj-$(CONFIG_BCMA)		+= bcma/
 obj-$(CONFIG_VHOST_NET)		+= vhost/
 obj-$(CONFIG_VLYNQ)		+= vlynq/
+obj-$(CONFIG_ZIO)		+= zio/
 obj-$(CONFIG_STAGING)		+= staging/
 obj-y				+= platform/
 obj-y				+= ieee802154/
diff --git a/drivers/zio/Kconfig b/drivers/zio/Kconfig
new file mode 100644
index 0000000..774a185
--- /dev/null
+++ b/drivers/zio/Kconfig
@@ -0,0 +1,12 @@
+
+config ZIO
+	tristate "The ZIO framework for high-bandwidth I/O"
+	help
+	  This is a new proposed framework for input/output, whose
+	  main use case is multi-megabyte per second I/O on several
+	  channels, with hardware timestamping and offline elaboration.
+
+	  Currently, all drivers (and triggers, and buffers) are compiled,
+	  with no Kconfig selection at a finer resolution.
+
+	  See www.ohwr.org/projects/zio for docs, slides, repo and list.
-- 
1.7.7.2
