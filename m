Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab2JAOFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 10:05:32 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:51030 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab2JAOFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 10:05:30 -0400
From: Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        VGER <linux-kernel@vger.kernel.org>, LDOC <linux-doc@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, Rob Landley <rob@landley.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC] media: v4l2-ctrl: Add digital gain controls
Date: Mon,  1 Oct 2012 19:33:39 +0530
Message-Id: <1349100219-7599-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

add support for per color component digital gain controls
and also their corresponding offset.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Hans de Goede hdegoede@redhat.com
Cc: Chris MacGregor chris@cybermato.com
Cc: Rob Landley <rob@landley.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 Documentation/DocBook/media/v4l/controls.xml |   54 ++++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c         |   11 +++++
 include/linux/v4l2-controls.h                |   11 +++++
 3 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index a84a08c..9bf54f3 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -4277,6 +4277,60 @@ interface and may change in the future.</para>
 	    specific test patterns can be used to test if a device is working
 	    properly.</entry>
 	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_GAIN_RED</constant></entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_GAIN_GREEN_RED</constant></entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_GAIN_GREEN_BLUE</constant></entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_GAIN_BLUE</constant></entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_GAIN_GREEN</constant></entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr"> Some capture/sensor devices have
+	    the capability to set per color component digital gain values.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_GAIN_OFFSET</constant></entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_BLUE_OFFSET</constant></entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_RED_OFFSET</constant></entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_GREEN_OFFSET</constant></entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_GREEN_RED_OFFSET</constant></entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_GREEN_BLUE_OFFSET</constant></entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr"> Some capture/sensor devices have the
+	    capability to set per color component digital gain offset values.
+	    V4L2_CID_GAIN_OFFSET is the global gain offset and the rest are per
+	    color component gain offsets.</entry>
+	  </row>
 	  <row><entry></entry></row>
 	</tbody>
       </tgroup>
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 93cd0a4..02cc1d2 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -750,6 +750,17 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_LINK_FREQ:		return "Link Frequency";
 	case V4L2_CID_PIXEL_RATE:		return "Pixel Rate";
 	case V4L2_CID_TEST_PATTERN:		return "Test Pattern";
+	case V4L2_CID_GAIN_RED:			return "Digital Gain Red";
+	case V4L2_CID_GAIN_GREEN_RED:		return "Digital Gain Green Red";
+	case V4L2_CID_GAIN_GREEN_BLUE:		return "Digital Gain Green Blue";
+	case V4L2_CID_GAIN_BLUE:		return "Digital Gain Blue";
+	case V4L2_CID_GAIN_GREEN:		return "Digital Gain Green";
+	case V4L2_CID_GAIN_OFFSET:		return "Digital Gain Offset";
+	case V4L2_CID_BLUE_OFFSET:		return "Digital Gain Blue Offset";
+	case V4L2_CID_RED_OFFSET:		return "Digital Gain Red Offset";
+	case V4L2_CID_GREEN_OFFSET:		return "Digital Gain Green Offset";
+	case V4L2_CID_GREEN_RED_OFFSET:		return "Digital Gain Green Red Offset";
+	case V4L2_CID_GREEN_BLUE_OFFSET:	return "Digital Gain Green Blue Offset";
 
 	/* DV controls */
 	case V4L2_CID_DV_CLASS:			return "Digital Video Controls";
diff --git a/include/linux/v4l2-controls.h b/include/linux/v4l2-controls.h
index e1b3680..087596d 100644
--- a/include/linux/v4l2-controls.h
+++ b/include/linux/v4l2-controls.h
@@ -758,5 +758,16 @@ enum v4l2_jpeg_chroma_subsampling {
 #define V4L2_CID_LINK_FREQ			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 1)
 #define V4L2_CID_PIXEL_RATE			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 2)
 #define V4L2_CID_TEST_PATTERN			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 3)
+#define V4L2_CID_GAIN_RED			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 4)
+#define V4L2_CID_GAIN_GREEN_RED			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 5)
+#define V4L2_CID_GAIN_GREEN_BLUE		(V4L2_CID_IMAGE_PROC_CLASS_BASE + 6)
+#define V4L2_CID_GAIN_BLUE			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 7)
+#define V4L2_CID_GAIN_GREEN			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 8)
+#define V4L2_CID_GAIN_OFFSET			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 9)
+#define V4L2_CID_BLUE_OFFSET			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 10)
+#define V4L2_CID_RED_OFFSET			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 11)
+#define V4L2_CID_GREEN_OFFSET			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 12)
+#define V4L2_CID_GREEN_RED_OFFSET		(V4L2_CID_IMAGE_PROC_CLASS_BASE + 13)
+#define V4L2_CID_GREEN_BLUE_OFFSET		(V4L2_CID_IMAGE_PROC_CLASS_BASE + 14)
 
 #endif
-- 
1.7.4.1

