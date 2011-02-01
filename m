Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab1BAMxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 07:53:37 -0500
Received: from smtp204.alice.it ([82.57.200.100]:44229 "EHLO smtp204.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab1BAMxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 07:53:35 -0500
X-Greylist: delayed 3944 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Feb 2011 07:53:35 EST
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>, openkinect@googlegroups.com,
        Steven Toth <stoth@kernellabs.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Xiaolin Zhang <xiaolin.zhang@intel.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] Add a 10 bpp packed greyscale format.
Date: Tue,  1 Feb 2011 13:52:52 +0100
Message-Id: <1296564773-15245-1-git-send-email-ospite@studenti.unina.it>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1295038598-8548-1-git-send-email-ospite@studenti.unina.it>
References: <1295038598-8548-1-git-send-email-ospite@studenti.unina.it>
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+ ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a 10 bits per pixel greyscale format in a packed array representation,
naming it Y10P. Such pixel format is supplied for instance by the Kinect
sensor device.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---

Hi,

Changes since v1:
 * Fixed a trailing space, I forgot to run ./scripts/checkpatch.pl on v1

I also added maintainers from ./scripts/get_maintainer.pl to CC, this should
increase the chance for the patch to be noticed.

Please comment on that, so I can send the final version if needed and start
adding support for the format to libv4l.

Thanks,
   Antonio Ospite
   http://ao2.it

 Documentation/DocBook/media-entities.tmpl |    1 +
 Documentation/DocBook/v4l/pixfmt-y10p.xml |   43 +++++++++++++++++++++++++++++
 Documentation/DocBook/v4l/pixfmt.xml      |    1 +
 Documentation/DocBook/v4l/videodev2.h.xml |    1 +
 include/linux/videodev2.h                 |    1 +
 5 files changed, 47 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/pixfmt-y10p.xml

diff --git a/Documentation/DocBook/media-entities.tmpl b/Documentation/DocBook/media-entities.tmpl
index be34dcb..2b18de5 100644
--- a/Documentation/DocBook/media-entities.tmpl
+++ b/Documentation/DocBook/media-entities.tmpl
@@ -253,6 +253,7 @@
 <!ENTITY sub-srggb10 SYSTEM "v4l/pixfmt-srggb10.xml">
 <!ENTITY sub-srggb8 SYSTEM "v4l/pixfmt-srggb8.xml">
 <!ENTITY sub-y10 SYSTEM "v4l/pixfmt-y10.xml">
+<!ENTITY sub-y10p SYSTEM "v4l/pixfmt-y10p.xml">
 <!ENTITY sub-pixfmt SYSTEM "v4l/pixfmt.xml">
 <!ENTITY sub-cropcap SYSTEM "v4l/vidioc-cropcap.xml">
 <!ENTITY sub-dbg-g-register SYSTEM "v4l/vidioc-dbg-g-register.xml">
diff --git a/Documentation/DocBook/v4l/pixfmt-y10p.xml b/Documentation/DocBook/v4l/pixfmt-y10p.xml
new file mode 100644
index 0000000..5323ffe
--- /dev/null
+++ b/Documentation/DocBook/v4l/pixfmt-y10p.xml
@@ -0,0 +1,43 @@
+<refentry id="V4L2-PIX-FMT-Y10P">
+  <refmeta>
+    <refentrytitle>V4L2_PIX_FMT_Y10P ('Y10P')</refentrytitle>
+    &manvol;
+  </refmeta>
+  <refnamediv>
+    <refname><constant>V4L2_PIX_FMT_Y10P</constant></refname>
+    <refpurpose>Grey-scale image as a packed array</refpurpose>
+  </refnamediv>
+  <refsect1>
+    <title>Description</title>
+
+    <para>This is a packed grey-scale image format with a depth of 10 bits per
+      pixel. Pixels are stored in a packed array of 10bit bits per pixel, with
+      no padding between them and with the most significant bits coming first
+      from the left.</para>
+
+    <example>
+      <title><constant>V4L2_PIX_FMT_Y10P</constant> 4 pixel data stream taking 5 bytes</title>
+
+      <formalpara>
+	<title>Packed representation</title>
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
index d7c4671..3682701 100644
--- a/Documentation/DocBook/v4l/pixfmt.xml
+++ b/Documentation/DocBook/v4l/pixfmt.xml
@@ -592,6 +592,7 @@ information.</para>
     &sub-packed-yuv;
     &sub-grey;
     &sub-y10;
+    &sub-y10p;
     &sub-y16;
     &sub-yuyv;
     &sub-uyvy;
diff --git a/Documentation/DocBook/v4l/videodev2.h.xml b/Documentation/DocBook/v4l/videodev2.h.xml
index 325b23b..eb39f6b 100644
--- a/Documentation/DocBook/v4l/videodev2.h.xml
+++ b/Documentation/DocBook/v4l/videodev2.h.xml
@@ -289,6 +289,7 @@ struct <link linkend="v4l2-pix-format">v4l2_pix_format</link> {
 #define <link linkend="V4L2-PIX-FMT-Y4">V4L2_PIX_FMT_Y4</link>      v4l2_fourcc('Y', '0', '4', ' ') /*  4  Greyscale     */
 #define <link linkend="V4L2-PIX-FMT-Y6">V4L2_PIX_FMT_Y6</link>      v4l2_fourcc('Y', '0', '6', ' ') /*  6  Greyscale     */
 #define <link linkend="V4L2-PIX-FMT-Y10">V4L2_PIX_FMT_Y10</link>     v4l2_fourcc('Y', '1', '0', ' ') /* 10  Greyscale     */
+#define <link linkend="V4L2-PIX-FMT-Y10P">V4L2_PIX_FMT_Y10P</link>    v4l2_fourcc('Y', '1', '0', 'P') /* 10  Greyscale as a packed array */
 #define <link linkend="V4L2-PIX-FMT-Y16">V4L2_PIX_FMT_Y16</link>     v4l2_fourcc('Y', '1', '6', ' ') /* 16  Greyscale     */
 
 /* Palette formats */
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 5f6f470..7682581 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -288,6 +288,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_Y4      v4l2_fourcc('Y', '0', '4', ' ') /*  4  Greyscale     */
 #define V4L2_PIX_FMT_Y6      v4l2_fourcc('Y', '0', '6', ' ') /*  6  Greyscale     */
 #define V4L2_PIX_FMT_Y10     v4l2_fourcc('Y', '1', '0', ' ') /* 10  Greyscale     */
+#define V4L2_PIX_FMT_Y10P    v4l2_fourcc('Y', '1', '0', 'P') /* 10  Greyscale as a packed array */
 #define V4L2_PIX_FMT_Y16     v4l2_fourcc('Y', '1', '6', ' ') /* 16  Greyscale     */
 
 /* Palette formats */
-- 
1.7.2.3

