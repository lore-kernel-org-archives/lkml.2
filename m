Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab1DGPqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 11:46:10 -0400
Received: from smtp209.alice.it ([82.57.200.105]:34192 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab1DGPqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 11:46:08 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
        Steven Toth <stoth@kernellabs.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Drew Fisher <drew.m.fisher@gmail.com>,
        OpenKinect <openkinect@googlegroups.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Add Y10B, a 10 bpp bit-packed greyscale format.
Date: Thu,  7 Apr 2011 17:45:51 +0200
Message-Id: <1302191152-7218-2-git-send-email-ospite@studenti.unina.it>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302191152-7218-1-git-send-email-ospite@studenti.unina.it>
References: <1302191152-7218-1-git-send-email-ospite@studenti.unina.it>
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+ ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a 10 bits per pixel greyscale format in a bit-packed array representation,
naming it Y10B. Such pixel format is supplied for instance by the Kinect
sensor device.

Cc: Steven Toth <stoth@kernellabs.com>
Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 Documentation/DocBook/media-entities.tmpl |    1 +
 Documentation/DocBook/v4l/pixfmt-y10b.xml |   43 +++++++++++++++++++++++++++++
 Documentation/DocBook/v4l/pixfmt.xml      |    1 +
 Documentation/DocBook/v4l/videodev2.h.xml |    3 ++
 include/linux/videodev2.h                 |    3 ++
 5 files changed, 51 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/pixfmt-y10b.xml

diff --git a/Documentation/DocBook/media-entities.tmpl b/Documentation/DocBook/media-entities.tmpl
index 5d259c6..2dead20 100644
--- a/Documentation/DocBook/media-entities.tmpl
+++ b/Documentation/DocBook/media-entities.tmpl
@@ -294,6 +294,7 @@
 <!ENTITY sub-srggb10 SYSTEM "v4l/pixfmt-srggb10.xml">
 <!ENTITY sub-srggb8 SYSTEM "v4l/pixfmt-srggb8.xml">
 <!ENTITY sub-y10 SYSTEM "v4l/pixfmt-y10.xml">
+<!ENTITY sub-y10b SYSTEM "v4l/pixfmt-y10b.xml">
 <!ENTITY sub-pixfmt SYSTEM "v4l/pixfmt.xml">
 <!ENTITY sub-cropcap SYSTEM "v4l/vidioc-cropcap.xml">
 <!ENTITY sub-dbg-g-register SYSTEM "v4l/vidioc-dbg-g-register.xml">
diff --git a/Documentation/DocBook/v4l/pixfmt-y10b.xml b/Documentation/DocBook/v4l/pixfmt-y10b.xml
new file mode 100644
index 0000000..adb0ad8
--- /dev/null
+++ b/Documentation/DocBook/v4l/pixfmt-y10b.xml
@@ -0,0 +1,43 @@
+<refentry id="V4L2-PIX-FMT-Y10BPACK">
+  <refmeta>
+    <refentrytitle>V4L2_PIX_FMT_Y10BPACK ('Y10B')</refentrytitle>
+    &manvol;
+  </refmeta>
+  <refnamediv>
+    <refname><constant>V4L2_PIX_FMT_Y10BPACK</constant></refname>
+    <refpurpose>Grey-scale image as a bit-packed array</refpurpose>
+  </refnamediv>
+  <refsect1>
+    <title>Description</title>
+
+    <para>This is a packed grey-scale image format with a depth of 10 bits per
+      pixel. Pixels are stored in a bit-packed array of 10bit bits per pixel,
+      with no padding between them and with the most significant bits coming
+      first from the left.</para>
+
+    <example>
+      <title><constant>V4L2_PIX_FMT_Y10BPACK</constant> 4 pixel data stream taking 5 bytes</title>
+
+      <formalpara>
+	<title>Bit-packed representation</title>
+	<para>pixels cross the byte boundary and have a ratio of 5 bytes for each 4
+          pixels.
+	  <informaltable frame="all">
+	    <tgroup cols="5" align="center">
+	      <colspec align="left" colwidth="2*" />
+	      <tbody valign="top">
+		<row>
+		  <entry>Y'<subscript>00[9:2]</subscript></entry>
+		  <entry>Y'<subscript>00[1:0]</subscript>Y'<subscript>01[9:4]</subscript></entry>
+		  <entry>Y'<subscript>01[3:0]</subscript>Y'<subscript>02[9:6]</subscript></entry>
+		  <entry>Y'<subscript>02[5:0]</subscript>Y'<subscript>03[9:8]</subscript></entry>
+		  <entry>Y'<subscript>03[7:0]</subscript></entry>
+		</row>
+	      </tbody>
+	    </tgroup>
+	  </informaltable>
+	</para>
+      </formalpara>
+    </example>
+  </refsect1>
+</refentry>
diff --git a/Documentation/DocBook/v4l/pixfmt.xml b/Documentation/DocBook/v4l/pixfmt.xml
index c6fdcbb..2e824a3 100644
--- a/Documentation/DocBook/v4l/pixfmt.xml
+++ b/Documentation/DocBook/v4l/pixfmt.xml
@@ -696,6 +696,7 @@ information.</para>
     &sub-packed-yuv;
     &sub-grey;
     &sub-y10;
+    &sub-y10b;
     &sub-y16;
     &sub-yuyv;
     &sub-uyvy;
diff --git a/Documentation/DocBook/v4l/videodev2.h.xml b/Documentation/DocBook/v4l/videodev2.h.xml
index 2b796a2..937acf5 100644
--- a/Documentation/DocBook/v4l/videodev2.h.xml
+++ b/Documentation/DocBook/v4l/videodev2.h.xml
@@ -311,6 +311,9 @@ struct <link linkend="v4l2-pix-format">v4l2_pix_format</link> {
 #define <link linkend="V4L2-PIX-FMT-Y10">V4L2_PIX_FMT_Y10</link>     v4l2_fourcc('Y', '1', '0', ' ') /* 10  Greyscale     */
 #define <link linkend="V4L2-PIX-FMT-Y16">V4L2_PIX_FMT_Y16</link>     v4l2_fourcc('Y', '1', '6', ' ') /* 16  Greyscale     */
 
+/* Grey bit-packed formats */
+#define <link linkend="V4L2-PIX-FMT-Y10BPACK">V4L2_PIX_FMT_Y10BPACK</link>    v4l2_fourcc('Y', '1', '0', 'B') /* 10  Greyscale bit-packed */
+
 /* Palette formats */
 #define <link linkend="V4L2-PIX-FMT-PAL8">V4L2_PIX_FMT_PAL8</link>    v4l2_fourcc('P', 'A', 'L', '8') /*  8  8-bit palette */
 
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index aa6c393..38575ae 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -310,6 +310,9 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_Y10     v4l2_fourcc('Y', '1', '0', ' ') /* 10  Greyscale     */
 #define V4L2_PIX_FMT_Y16     v4l2_fourcc('Y', '1', '6', ' ') /* 16  Greyscale     */
 
+/* Grey bit-packed formats */
+#define V4L2_PIX_FMT_Y10BPACK    v4l2_fourcc('Y', '1', '0', 'B') /* 10  Greyscale bit-packed */
+
 /* Palette formats */
 #define V4L2_PIX_FMT_PAL8    v4l2_fourcc('P', 'A', 'L', '8') /*  8  8-bit palette */
 
-- 
1.7.4.1

