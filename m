Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194Ab2IGInS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 04:43:18 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60739 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760089Ab2IGInN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 04:43:13 -0400
From: Prabhakar Lad <prabhakar.lad@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-doc@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Landley <rob@landley.net>
Subject: [PATCH v2] media: v4l2-ctrls: add control for test pattern
Date: Fri, 7 Sep 2012 14:11:49 +0530
Message-ID: <1347007309-6913-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

add V4L2_CID_TEST_PATTERN of type menu, which determines
the internal test pattern selected by the device.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Rob Landley <rob@landley.net>
---
This patches has one checkpatch warning for line over
80 characters altough it can be avoided I have kept it
for consistency.

Changes for v2:
1: Included display devices in the description for test pattern
   as pointed by Hans.
2: In the menu replaced 'Test Pattern Disabled' by 'Disabled' as
   pointed by Sylwester.
3: Removed the test patterns from menu as the are hardware specific
   as pointed by Sakari.

 Documentation/DocBook/media/v4l/controls.xml |   20 ++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c         |    8 ++++++++
 include/linux/videodev2.h                    |    4 ++++
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index ad873ea..173934e 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -4311,6 +4311,26 @@ interface and may change in the future.</para>
 	      </tbody>
 	    </entrytbl>
 	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_TEST_PATTERN</constant></entry>
+	    <entry>menu</entry>
+	  </row>
+	  <row id="v4l2-test-pattern">
+	    <entry spanname="descr"> The Capture/Display/Sensors have the capability
+	    to generate internal test patterns and this are hardware specific. This
+	    test patterns are used to test a device is properly working and can generate
+	    the desired waveforms that it supports.</entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+	        <row>
+	         <entry><constant>V4L2_TEST_PATTERN_DISABLED</constant></entry>
+	          <entry>Test pattern generation is disabled</entry>
+	        </row>
+	      </tbody>
+	    </entrytbl>
+	  </row>
 	<row><entry></entry></row>
 	</tbody>
       </tgroup>
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 8f2f40b..d731422 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -430,6 +430,10 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Advanced",
 		NULL,
 	};
+	static const char * const test_pattern[] = {
+		"Disabled",
+		NULL,
+	};
 
 	switch (id) {
 	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
@@ -509,6 +513,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return jpeg_chroma_subsampling;
 	case V4L2_CID_DPCM_PREDICTOR:
 		return dpcm_predictor;
+	case V4L2_CID_TEST_PATTERN:
+		return test_pattern;
 
 	default:
 		return NULL;
@@ -740,6 +746,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_LINK_FREQ:		return "Link Frequency";
 	case V4L2_CID_PIXEL_RATE:		return "Pixel Rate";
 	case V4L2_CID_DPCM_PREDICTOR:		return "DPCM Predictor";
+	case V4L2_CID_TEST_PATTERN:		return "Test Pattern";
 
 	default:
 		return NULL;
@@ -841,6 +848,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_EXPOSURE_METERING:
 	case V4L2_CID_SCENE_MODE:
 	case V4L2_CID_DPCM_PREDICTOR:
+	case V4L2_CID_TEST_PATTERN:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_LINK_FREQ:
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index ca9fb78..6a2d499 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -2005,6 +2005,10 @@ enum v4l2_dpcm_predictor {
 	V4L2_DPCM_PREDICTOR_SIMPLE	= 0,
 	V4L2_DPCM_PREDICTOR_ADVANCED	= 1,
 };
+#define V4L2_CID_TEST_PATTERN			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 4)
+enum v4l2_test_pattern {
+	V4L2_TEST_PATTERN_DISABLED		= 0,
+};
 
 /*
  *	T U N I N G
-- 
1.7.0.4

