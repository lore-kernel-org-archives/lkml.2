Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab0EXTbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 15:31:36 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47416 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab0EXTbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 15:31:35 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 24 May 2010 21:31:23 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: schedule for removal
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net
In-Reply-To: <201005232348.o4NNm5kK024726@turbo.physics.adelaide.edu.au>
Message-ID: <tkrat.188ec405b9253375@s5r6.in-berlin.de>
References: <4BF93F10.5070903@s5r6.in-berlin.de> from "Stefan Richter" at May
 23, 2010 04:43:28 PM
 <201005232348.o4NNm5kK024726@turbo.physics.adelaide.edu.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All application domains that are supported by the old ieee1394 driver
stack are supported by the newer firewire driver stack too.  (FireWire
audio came last, in 2.6.32.)  There is now good and extensive experience
with the newer stack from deployment in Fedora since F7 as well as by
enthusiast users of other distributions.  The new drivers have
consequently been recommended as the default ones since 2.6.33, in order
to fix some severe usability problems of FireWire on Linux due to
limitations of the old stack.  It is now high time to announce when the
obsolete drivers will be removed.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Removal in 2.6.36 should be OK too, but one of the Linux FireWire audio
driver (ffado) developers recommended 2.6.37 since the current
generation of pro-audio oriented distributions still ships the old
drivers as default.

 Documentation/feature-removal-schedule.txt |   10 ++++++++++
 drivers/ieee1394/Kconfig                   |    4 ++--
 2 files changed, 12 insertions(+), 2 deletions(-)

Index: b/Documentation/feature-removal-schedule.txt
===================================================================
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -612,3 +612,13 @@ Why:	The vtx device nodes have been supe
 	provided by the vtx API, then that functionality should be build
 	around the sliced VBI API instead.
 Who:	Hans Verkuil <hverkuil@xs4all.nl>
+
+----------------------------
+
+What:	old ieee1394 subsystem (CONFIG_IEEE1394)
+When:	2.6.37
+Files:	drivers/ieee1394/ except init_ohci1394_dma.c
+Why:	superseded by drivers/firewire/ (CONFIG_FIREWIRE) which offers more
+	features, better performance, and better security, all with smaller
+	and more modern code base
+Who:	Stefan Richter <stefanr@s5r6.in-berlin.de>
Index: b/drivers/ieee1394/Kconfig
===================================================================
--- a/drivers/ieee1394/Kconfig
+++ b/drivers/ieee1394/Kconfig
@@ -1,5 +1,5 @@
 config IEEE1394
-	tristate "Legacy alternative FireWire driver stack"
+	tristate "Legacy alternative FireWire drivers (Obsolete, deprecated)"
 	depends on PCI || BROKEN
 	help
 	  IEEE 1394 describes a high performance serial bus, which is also
@@ -164,7 +164,7 @@ config IEEE1394_VIDEO1394
 	  further information on how to switch to the new FireWire drivers.
 
 config IEEE1394_DV1394
-	tristate "dv1394 userspace interface (deprecated)"
+	tristate "dv1394 userspace interface"
 	depends on IEEE1394 && IEEE1394_OHCI1394
 	help
 	  The dv1394 driver is unsupported and may be removed from Linux in a

-- 
Stefan Richter
-=====-==-=- -=-= ==---
http://arcgraph.de/sr/

