Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab2IJF67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 01:58:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38360 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718Ab2IJF65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 01:58:57 -0400
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
Subject: [PATCH v5] media: v4l2-ctrls: add control for dpcm predictor
Date: Mon, 10 Sep 2012 11:27:55 +0530
Message-ID: <1347256675-13391-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

add V4L2_CID_DPCM_PREDICTOR control of type menu, which
determines the dpcm predictor. The predictor can be either
simple or advanced.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Rob Landley <rob@landley.net>
---
This patches has one checkpatch warning for line over
80 characters altough it can be avoided I have kept it
for consistency.

Changes for v5:
1: Changed the control's name to 'Simple' and  'Advanced'
   as pointed by Sakari.
2: Changed the description of DPCM. Thanks to Sakari for
   providing the description.

Changes for v4:
1: Aligned the description to fit appropriately in the
   para tag, pointed by Sylwester.

Changes for v3:
1: Added better explanation for DPCM, pointed by Hans.

Changes for v2:
1: Added documentaion in controls.xml pointed by Sylwester.
2: Chnaged V4L2_DPCM_PREDICTOR_ADVANCE to V4L2_DPCM_PREDICTOR_ADVANCED
   pointed by Sakari.

 Documentation/DocBook/media/v4l/controls.xml |   39 +++++++++++++++++++++++++-
 drivers/media/v4l2-core/v4l2-ctrls.c         |    9 ++++++
 include/linux/videodev2.h                    |    5 +++
 3 files changed, 52 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 93b9c68..2c1599f 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -4267,7 +4267,44 @@ interface and may change in the future.</para>
 	    pixels / second.
 	    </entry>
 	  </row>
-	  <row><entry></entry></row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_DPCM_PREDICTOR</constant></entry>
+	    <entry>menu</entry>
+	  </row>
+	  <row id="v4l2-dpcm-predictor">
+	    <entry spanname="descr"> Differential pulse-code modulation (DPCM) compression can
+	    be used to compress the samples into fewer bits than they would otherwise require.
+	    This is done by calculating the difference between consecutive samples and outputting
+	    the difference which in average is much smaller than the values of the samples
+	    themselves since there is generally lots of correlation between adjacent pixels. In
+	    decompression the original samples are reconstructed. The process isn't lossless as
+	    the encoded sample size in bits is less than the original.
+
+	    <para>Formats using DPCM compression include <xref linkend="pixfmt-srggb10dpcm8" />.</para>
+
+	    <para>This control is used to select the predictor used to encode the samples.</para>
+
+	    <para>The main difference between the simple and the advanced predictors is image quality,
+	    with advanced predictor supposed to produce better quality images as a result. Simple
+	    predictor can be used e.g. for testing purposes. For more information about DPCM see <ulink
+	    url="http://en.wikipedia.org/wiki/Differential_pulse-code_modulation">Wikipedia</ulink>.</para>
+	    </entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+	        <row>
+	         <entry><constant>V4L2_DPCM_PREDICTOR_SIMPLE</constant></entry>
+	          <entry>Predictor type is simple</entry>
+	        </row>
+	        <row>
+	          <entry><constant>V4L2_DPCM_PREDICTOR_ADVANCED</constant></entry>
+	          <entry>Predictor type is advanced</entry>
+	        </row>
+	      </tbody>
+	    </entrytbl>
+	  </row>
+	<row><entry></entry></row>
 	</tbody>
       </tgroup>
       </table>
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index b6a2ee7..8f2f40b 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -425,6 +425,11 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Gray",
 		NULL,
 	};
+	static const char * const dpcm_predictor[] = {
+		"Simple",
+		"Advanced",
+		NULL,
+	};
 
 	switch (id) {
 	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
@@ -502,6 +507,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return mpeg4_profile;
 	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
 		return jpeg_chroma_subsampling;
+	case V4L2_CID_DPCM_PREDICTOR:
+		return dpcm_predictor;
 
 	default:
 		return NULL;
@@ -732,6 +739,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_IMAGE_PROC_CLASS:		return "Image Processing Controls";
 	case V4L2_CID_LINK_FREQ:		return "Link Frequency";
 	case V4L2_CID_PIXEL_RATE:		return "Pixel Rate";
+	case V4L2_CID_DPCM_PREDICTOR:		return "DPCM Predictor";
 
 	default:
 		return NULL;
@@ -832,6 +840,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_ISO_SENSITIVITY_AUTO:
 	case V4L2_CID_EXPOSURE_METERING:
 	case V4L2_CID_SCENE_MODE:
+	case V4L2_CID_DPCM_PREDICTOR:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_LINK_FREQ:
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 6d6dfa7..ca9fb78 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -2000,6 +2000,11 @@ enum v4l2_jpeg_chroma_subsampling {
 
 #define V4L2_CID_LINK_FREQ			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 1)
 #define V4L2_CID_PIXEL_RATE			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 2)
+#define V4L2_CID_DPCM_PREDICTOR			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 3)
+enum v4l2_dpcm_predictor {
+	V4L2_DPCM_PREDICTOR_SIMPLE	= 0,
+	V4L2_DPCM_PREDICTOR_ADVANCED	= 1,
+};
 
 /*
  *	T U N I N G
-- 
1.7.0.4

