Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab1FZQJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 12:09:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280Ab1FZQHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 12:07:43 -0400
Date: Sun, 26 Jun 2011 13:06:18 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/14] [media] DocBook/v4l: Document the new system-wide
 version behavior
Message-ID: <20110626130618.5933926c@pedra>
In-Reply-To: <cover.1309103285.git.mchehab@redhat.com>
References: <cover.1309103285.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/v4l/common.xml b/Documentation/DocBook/media/v4l/common.xml
index 9028721..a86f7a0 100644
--- a/Documentation/DocBook/media/v4l/common.xml
+++ b/Documentation/DocBook/media/v4l/common.xml
@@ -236,7 +236,15 @@ important parts of the API.</para>
     <para>The &VIDIOC-QUERYCAP; ioctl is available to check if the kernel
 device is compatible with this specification, and to query the <link
 linkend="devices">functions</link> and <link linkend="io">I/O
-methods</link> supported by the device. Other features can be queried
+methods</link> supported by the device.</para>
+
+    <para>Starting with kernel version 3.1, VIDIOC-QUERYCAP will return the
+V4L2 API version used by the driver, with generally matches the Kernel version.
+There's no need of using &VIDIOC-QUERYCAP; to check if an specific ioctl is
+supported, the V4L2 core now returns ENOIOCTLCMD if a driver doesn't provide
+support for an ioctl.</para>
+
+    <para>Other features can be queried
 by calling the respective ioctl, for example &VIDIOC-ENUMINPUT;
 to learn about the number, types and names of video connectors on the
 device. Although abstraction is a major objective of this API, the
diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
index f29f1b8..7aa6973 100644
--- a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
@@ -67,9 +67,8 @@ driver is not compatible with this specification the ioctl returns an
 	    <entry><para>Name of the driver, a unique NUL-terminated
 ASCII string. For example: "bttv". Driver specific applications can
 use this information to verify the driver identity. It is also useful
-to work around known bugs, or to identify drivers in error reports.
-The driver version is stored in the <structfield>version</structfield>
-field.</para><para>Storing strings in fixed sized arrays is bad
+to work around known bugs, or to identify drivers in error reports.</para>
+<para>Storing strings in fixed sized arrays is bad
 practice but unavoidable here. Drivers and applications should take
 precautions to never read or write beyond the end of the array and to
 make sure the strings are properly NUL-terminated.</para></entry>
@@ -100,9 +99,13 @@ empty string (<structfield>bus_info</structfield>[0] = 0).<!-- XXX pci_dev->slot
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>version</structfield></entry>
-	    <entry><para>Version number of the driver. Together with
-the <structfield>driver</structfield> field this identifies a
-particular driver. The version number is formatted using the
+	    <entry><para>Version number of the driver.</para>
+<para>Starting on kernel 3.1, the version reported is provided per
+V4L2 subsystem, following the same Kernel numberation scheme. However, it
+should not always return the same version as the kernel, if, for example,
+an stable or distribution-modified kernel uses the V4L2 stack from a
+newer kernel.</para>
+<para>The version number is formatted using the
 <constant>KERNEL_VERSION()</constant> macro:</para></entry>
 	  </row>
 	  <row>
-- 
1.7.1

