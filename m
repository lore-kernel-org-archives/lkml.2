Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab1GFSE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:04:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755465Ab1GFSEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:04:54 -0400
Date: Wed, 6 Jul 2011 15:03:51 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFCv3 02/17] [media] DocBook: Use the generic ioctl error
 codes for all V4L ioctl's
Message-ID: <20110706150351.02e236ca@pedra>
In-Reply-To: <cover.1309974026.git.mchehab@redhat.com>
References: <cover.1309974026.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Be sure that all VIDIOC_* ioctl are using the return error macro, and
aren't specifying generic error codes internally.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/v4l/gen-errors.xml b/Documentation/DocBook/media/v4l/gen-errors.xml
index 1efc688..6ef476a 100644
--- a/Documentation/DocBook/media/v4l/gen-errors.xml
+++ b/Documentation/DocBook/media/v4l/gen-errors.xml
@@ -10,7 +10,24 @@
 	<entry>The ioctl can't be handled because the device is busy. This is
 	       typically return while device is streaming, and an ioctl tried to
 	       change something that would affect the stream, or would require the
-	       usage of a hardware resource that was already allocated.</entry>
+	       usage of a hardware resource that was already allocated. The ioctl
+	       must not be retried without performing another action to fix the
+	       problem first (typically: stop the stream before retrying).</entry>
+      </row>
+      <row>
+	<entry>EINVAL</entry>
+	<entry>The ioctl is not supported by the driver, actually meaning that
+	       the required functionality is not available.</entry>
+      </row>
+      <row>
+	<entry>ENOMEM</entry>
+	<entry>There's not enough memory to handle the desired operation.</entry>
+      </row>
+      <row>
+	<entry>ENOSPC</entry>
+	<entry>On USB devices, the stream ioctl's can return this error meaning
+	       that this request would overcommit the usb bandwidth reserved
+	       for periodic transfers (up to 80% of the USB bandwidth).</entry>
       </row>
     </tbody>
   </tgroup>
diff --git a/Documentation/DocBook/media/v4l/vidioc-cropcap.xml b/Documentation/DocBook/media/v4l/vidioc-cropcap.xml
index 816e90e..b4f2f25 100644
--- a/Documentation/DocBook/media/v4l/vidioc-cropcap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-cropcap.xml
@@ -156,19 +156,10 @@ on 22 Oct 2002 subject "Re:[V4L][patches!] Re:v4l2/kernel-2.5" -->
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
 	  <para>The &v4l2-cropcap; <structfield>type</structfield> is
-invalid or the ioctl is not supported. This is not permitted for
-video capture, output and overlay devices, which must support
-<constant>VIDIOC_CROPCAP</constant>.</para>
+invalid. This is not permitted for video capture, output and overlay devices,
+which must support <constant>VIDIOC_CROPCAP</constant>.</para>
 	</listitem>
       </varlistentry>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml
index 4a09e20..4ecd966 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml
@@ -258,18 +258,9 @@ could not identify it.</entry>
       <varlistentry>
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
-	  <para>The driver does not support this ioctl, or the
-<structfield>match_type</structfield> is invalid.</para>
+	  <para>The <structfield>match_type</structfield> is invalid.</para>
 	</listitem>
       </varlistentry>
      </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml b/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
index 980c7f3..a44aebc 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
@@ -247,15 +247,6 @@ register.</entry>
 
     <variablelist>
       <varlistentry>
-	<term><errorcode>EINVAL</errorcode></term>
-	<listitem>
-	  <para>The driver does not support this ioctl, or the kernel
-was not compiled with the <constant>CONFIG_VIDEO_ADV_DEBUG</constant>
-option, or the <structfield>match_type</structfield> is invalid, or the
-selected chip or register does not exist.</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
 	<term><errorcode>EPERM</errorcode></term>
 	<listitem>
 	  <para>Insufficient permissions. Root privileges are required
@@ -265,11 +256,3 @@ to execute these ioctls.</para>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
index b8c4f76..7769642 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
@@ -136,11 +136,7 @@
     </table>
 
   </refsect1>
+  <refsect1>
+    &return-value;
+  </refsect1>
 </refentry>
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml b/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
index b0dde94..af7f3f2 100644
--- a/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
@@ -180,8 +180,7 @@ Pictures</wordasword>, rather than immediately.</entry>
       <varlistentry>
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
-	  <para>The driver does not support this ioctl, or the
-<structfield>cmd</structfield> field is invalid.</para>
+	  <para>The <structfield>cmd</structfield> field is invalid.</para>
 	</listitem>
       </varlistentry>
       <varlistentry>
@@ -194,11 +193,3 @@ the encoder was not running.</para>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-frameintervals.xml b/Documentation/DocBook/media/v4l/vidioc-enum-frameintervals.xml
index 3c216e1..5fd72c4 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enum-frameintervals.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enum-frameintervals.xml
@@ -254,17 +254,6 @@ enumerated.</entry>
 
   <refsect1>
     &return-value;
-
-    <para>See the description section above for a list of return
-values that <varname>errno</varname> can have.</para>
   </refsect1>
 
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml b/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml
index 6afa454..f77a13f 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml
@@ -267,16 +267,5 @@ application should zero out all members except for the
 
   <refsect1>
     &return-value;
-
-    <para>See the description section above for a list of return
-values that <varname>errno</varname> can have.</para>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-enumaudio.xml b/Documentation/DocBook/media/v4l/vidioc-enumaudio.xml
index 9ae8f2d..ea816ab 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enumaudio.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enumaudio.xml
@@ -68,19 +68,9 @@ until the driver returns <errorcode>EINVAL</errorcode>.</para>
       <varlistentry>
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
-	  <para>The number of the audio input is out of bounds, or
-there are no audio inputs at all and this ioctl is not
-supported.</para>
+	  <para>The number of the audio input is out of bounds.</para>
 	</listitem>
       </varlistentry>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-enumaudioout.xml b/Documentation/DocBook/media/v4l/vidioc-enumaudioout.xml
index d3d7c0a..2e87ced 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enumaudioout.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enumaudioout.xml
@@ -71,19 +71,9 @@ signal to a sound card are not audio outputs in this sense.</para>
       <varlistentry>
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
-	  <para>The number of the audio output is out of bounds, or
-there are no audio outputs at all and this ioctl is not
-supported.</para>
+	  <para>The number of the audio output is out of bounds.</para>
 	</listitem>
       </varlistentry>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-audio.xml b/Documentation/DocBook/media/v4l/vidioc-g-audio.xml
index 65361a8..d7bb9b3 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-audio.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-audio.xml
@@ -164,25 +164,9 @@ tuner.</entry>
 	<listitem>
 	  <para>No audio inputs combine with the current video input,
 or the number of the selected audio input is out of bounds or it does
-not combine, or there are no audio inputs at all and the ioctl is not
-supported.</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><errorcode>EBUSY</errorcode></term>
-	<listitem>
-	  <para>I/O is in progress, the input cannot be
-switched.</para>
+not combine.</para>
 	</listitem>
       </varlistentry>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-audioout.xml b/Documentation/DocBook/media/v4l/vidioc-g-audioout.xml
index 3632730..200a270 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-audioout.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-audioout.xml
@@ -130,25 +130,9 @@ applications must set the array to zero.</entry>
 	<listitem>
 	  <para>No audio outputs combine with the current video
 output, or the number of the selected audio output is out of bounds or
-it does not combine, or there are no audio outputs at all and the
-ioctl is not supported.</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><errorcode>EBUSY</errorcode></term>
-	<listitem>
-	  <para>I/O is in progress, the output cannot be
-switched.</para>
+it does not combine.</para>
 	</listitem>
       </varlistentry>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-crop.xml b/Documentation/DocBook/media/v4l/vidioc-g-crop.xml
index d235b1d..01a5064 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-crop.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-crop.xml
@@ -122,22 +122,5 @@ for &v4l2-cropcap; <structfield>bounds</structfield> is used.</entry>
 
   <refsect1>
     &return-value;
-
-    <variablelist>
-      <varlistentry>
-	<term><errorcode>EINVAL</errorcode></term>
-	<listitem>
-	  <para>Cropping is not supported.</para>
-	</listitem>
-      </varlistentry>
-    </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml b/Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml
index d733721..7940c11 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml
@@ -97,14 +97,8 @@ If the preset is not supported, it returns an &EINVAL; </para>
 	</tbody>
       </tgroup>
     </table>
-
+  </refsect1>
+  <refsect1>
+    &return-value;
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
index d5ec6ab..4a8648a 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
@@ -212,12 +212,7 @@ bit 0 (V4L2_DV_VSYNC_POS_POL) is for vertical sync polarity and bit 1 (V4L2_DV_H
       </tgroup>
     </table>
   </refsect1>
+  <refsect1>
+    &return-value;
+  </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-enc-index.xml b/Documentation/DocBook/media/v4l/vidioc-g-enc-index.xml
index 9f242e4..2aef02c 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-enc-index.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-enc-index.xml
@@ -192,22 +192,5 @@ this mask to obtain the picture coding type.</entry>
 
   <refsect1>
     &return-value;
-
-    <variablelist>
-      <varlistentry>
-	<term><errorcode>EINVAL</errorcode></term>
-	<listitem>
-	  <para>The driver does not support this ioctl.</para>
-	</listitem>
-      </varlistentry>
-    </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml b/Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml
index e7dda48..0557182 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml
@@ -446,28 +446,11 @@ overlay.</para>
 	</listitem>
       </varlistentry>
       <varlistentry>
-	<term><errorcode>EBUSY</errorcode></term>
-	<listitem>
-	  <para>The framebuffer parameters cannot be changed at this
-time because overlay is already enabled, or capturing is enabled
-and the hardware cannot capture and overlay simultaneously.</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
-	  <para>The ioctl is not supported or the
-<constant>VIDIOC_S_FBUF</constant> parameters are unsuitable.</para>
+	  <para>The <constant>VIDIOC_S_FBUF</constant> parameters are unsuitable.</para>
 	</listitem>
       </varlistentry>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml b/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
index a4ae59b..17fbda1 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
@@ -184,29 +184,13 @@ capture and output devices.</entry>
 
     <variablelist>
       <varlistentry>
-	<term><errorcode>EBUSY</errorcode></term>
-	<listitem>
-	  <para>The data format cannot be changed at this
-time, for example because I/O is already in progress.</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
 	  <para>The &v4l2-format; <structfield>type</structfield>
-field is invalid, the requested buffer type not supported, or
-<constant>VIDIOC_TRY_FMT</constant> was called and is not
-supported with this buffer type.</para>
+field is invalid, the requested buffer type not supported, or the
+format is not supported with this buffer type.</para>
 	</listitem>
       </varlistentry>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-input.xml b/Documentation/DocBook/media/v4l/vidioc-g-input.xml
index ed076e9..08ae82f 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-input.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-input.xml
@@ -75,26 +75,9 @@ querying or negotiating any other parameters.</para>
       <varlistentry>
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
-	  <para>The number of the video input is out of bounds, or
-there are no video inputs at all and this ioctl is not
-supported.</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><errorcode>EBUSY</errorcode></term>
-	<listitem>
-	  <para>I/O is in progress, the input cannot be
-switched.</para>
+	  <para>The number of the video input is out of bounds.</para>
 	</listitem>
       </varlistentry>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-jpegcomp.xml b/Documentation/DocBook/media/v4l/vidioc-g-jpegcomp.xml
index 77394b2..01ea24b 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-jpegcomp.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-jpegcomp.xml
@@ -159,22 +159,5 @@ to add them.</para>
 
   <refsect1>
     &return-value;
-
-    <variablelist>
-      <varlistentry>
-	<term><errorcode>EINVAL</errorcode></term>
-	<listitem>
-	  <para>This ioctl is not supported.</para>
-	</listitem>
-      </varlistentry>
-    </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-output.xml b/Documentation/DocBook/media/v4l/vidioc-g-output.xml
index 3ea8c0e..fd45f1c 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-output.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-output.xml
@@ -76,25 +76,9 @@ negotiating any other parameters.</para>
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
 	  <para>The number of the video output is out of bounds, or
-there are no video outputs at all and this ioctl is not
-supported.</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><errorcode>EBUSY</errorcode></term>
-	<listitem>
-	  <para>I/O is in progress, the output cannot be
-switched.</para>
+there are no video outputs at all.</para>
 	</listitem>
       </varlistentry>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-parm.xml b/Documentation/DocBook/media/v4l/vidioc-g-parm.xml
index 392aa9e..19b1d85 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-parm.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-parm.xml
@@ -311,22 +311,5 @@ excessive motion blur. </para>
 
   <refsect1>
     &return-value;
-
-    <variablelist>
-      <varlistentry>
-	<term><errorcode>EINVAL</errorcode></term>
-	<listitem>
-	  <para>This ioctl is not supported.</para>
-	</listitem>
-      </varlistentry>
-    </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-priority.xml b/Documentation/DocBook/media/v4l/vidioc-g-priority.xml
index 5fb0019..8f5e3da 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-priority.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-priority.xml
@@ -120,8 +120,7 @@ recording.</entry>
       <varlistentry>
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
-	  <para>The requested priority value is invalid, or the
-driver does not support access priorities.</para>
+	  <para>The requested priority value is invalid.</para>
 	</listitem>
       </varlistentry>
       <varlistentry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml b/Documentation/DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml
index 10e721b..71741da 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml
@@ -246,19 +246,10 @@ line systems.</entry>
       <varlistentry>
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
-	  <para>The device does not support sliced VBI capturing or
-output, or the value in the <structfield>type</structfield> field is
+	  <para>The value in the <structfield>type</structfield> field is
 wrong.</para>
 	</listitem>
       </varlistentry>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-std.xml b/Documentation/DocBook/media/v4l/vidioc-g-std.xml
index 912f851..37996f2 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-std.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-std.xml
@@ -82,14 +82,7 @@ standards.</para>
       <varlistentry>
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
-	  <para>This ioctl is not supported, or the
-<constant>VIDIOC_S_STD</constant> parameter was unsuitable.</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><errorcode>EBUSY</errorcode></term>
-	<listitem>
-	  <para>The device is busy and therefore can not change the standard</para>
+	  <para>The <constant>VIDIOC_S_STD</constant> parameter was unsuitable.</para>
 	</listitem>
       </varlistentry>
     </variablelist>
diff --git a/Documentation/DocBook/media/v4l/vidioc-log-status.xml b/Documentation/DocBook/media/v4l/vidioc-log-status.xml
index 2634b7c..5ded7d3 100644
--- a/Documentation/DocBook/media/v4l/vidioc-log-status.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-log-status.xml
@@ -37,22 +37,5 @@ was introduced in Linux 2.6.15.</para>
 
   <refsect1>
     &return-value;
-
-    <variablelist>
-      <varlistentry>
-	<term><errorcode>EINVAL</errorcode></term>
-	<listitem>
-	  <para>The driver does not support this ioctl.</para>
-	</listitem>
-      </varlistentry>
-    </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-overlay.xml b/Documentation/DocBook/media/v4l/vidioc-overlay.xml
index 1036c58..250a7de 100644
--- a/Documentation/DocBook/media/v4l/vidioc-overlay.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-overlay.xml
@@ -65,19 +65,10 @@
       <varlistentry>
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
-	  <para>Video overlay is not supported, or the
-parameters have not been set up. See <xref
+	  <para>The overlay parameters have not been set up. See <xref
 linkend="overlay" /> for the necessary steps.</para>
 	</listitem>
       </varlistentry>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
index f2b11f8..9caa49a 100644
--- a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
@@ -158,15 +158,6 @@ or no buffers have been allocated yet, or the
 <structfield>userptr</structfield> or
 <structfield>length</structfield> are invalid.</para>
 	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><errorcode>ENOMEM</errorcode></term>
-	<listitem>
-	  <para>Not enough physical or virtual memory was available to
-enqueue a user pointer buffer.</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
 	<term><errorcode>EIO</errorcode></term>
 	<listitem>
 	  <para><constant>VIDIOC_DQBUF</constant> failed due to an
@@ -184,11 +175,3 @@ continue streaming.
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-query-dv-preset.xml b/Documentation/DocBook/media/v4l/vidioc-query-dv-preset.xml
index d272f7a..23b17f6 100644
--- a/Documentation/DocBook/media/v4l/vidioc-query-dv-preset.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-query-dv-preset.xml
@@ -61,27 +61,5 @@ returned.</para>
 
   <refsect1>
     &return-value;
-    <variablelist>
-      <varlistentry>
-	<term><errorcode>EINVAL</errorcode></term>
-	<listitem>
-	  <para>This ioctl is not supported.</para>
-	</listitem>
-    </varlistentry>
-      <varlistentry>
-	<term><errorcode>EBUSY</errorcode></term>
-	<listitem>
-	  <para>The device is busy and therefore can not sense the preset</para>
-	</listitem>
-      </varlistentry>
-    </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
index 7aa6973..e3664d6 100644
--- a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
@@ -283,24 +283,5 @@ linkend="mmap">streaming</link> I/O method.</entry>
 
   <refsect1>
     &return-value;
-
-    <variablelist>
-      <varlistentry>
-	<term><errorcode>EINVAL</errorcode></term>
-	<listitem>
-	  <para>The device is not compatible with this
-specification.</para>
-	</listitem>
-      </varlistentry>
-    </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
-
diff --git a/Documentation/DocBook/media/v4l/vidioc-querystd.xml b/Documentation/DocBook/media/v4l/vidioc-querystd.xml
index 1a9e603..4b79c7c 100644
--- a/Documentation/DocBook/media/v4l/vidioc-querystd.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-querystd.xml
@@ -62,28 +62,5 @@ current video input or output.</para>
 
   <refsect1>
     &return-value;
-
-    <variablelist>
-      <varlistentry>
-	<term><errorcode>EINVAL</errorcode></term>
-	<listitem>
-	  <para>This ioctl is not supported.</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><errorcode>EBUSY</errorcode></term>
-	<listitem>
-	  <para>The device is busy and therefore can not detect the standard</para>
-	</listitem>
-      </varlistentry>
-    </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml b/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
index 69800ae..7be4b1d 100644
--- a/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
@@ -122,14 +122,6 @@ higher. This array should be zeroed by applications.</entry>
 
     <variablelist>
       <varlistentry>
-	<term><errorcode>EBUSY</errorcode></term>
-	<listitem>
-	  <para>The driver supports multiple opens and I/O is already
-in progress, or reallocation of buffers was attempted although one or
-more are still mapped.</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
 	  <para>The buffer type (<structfield>type</structfield> field) or the
@@ -140,11 +132,3 @@ supported.</para>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-streamon.xml b/Documentation/DocBook/media/v4l/vidioc-streamon.xml
index 75ed39b..81cca45 100644
--- a/Documentation/DocBook/media/v4l/vidioc-streamon.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-streamon.xml
@@ -88,9 +88,9 @@ synchronize with other events.</para>
       <varlistentry>
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
-	  <para>Streaming I/O is not supported, the buffer
-<structfield>type</structfield> is not supported, or no buffers have
-been allocated (memory mapping) or enqueued (output) yet.</para>
+	  <para>The buffer<structfield>type</structfield> is not supported,
+	  or no buffers have been allocated (memory mapping) or enqueued
+	  (output) yet.</para>
 	</listitem>
       </varlistentry>
       <varlistentry>
@@ -105,11 +105,3 @@ been allocated (memory mapping) or enqueued (output) yet.</para>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-fmt.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-fmt.xml
index f367c57..a67cde6 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-g-fmt.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-fmt.xml
@@ -177,4 +177,7 @@
       </varlistentry>
     </variablelist>
   </refsect1>
+  <refsect1>
+    &return-value;
+  </refsect1>
 </refentry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
index 25471e8..69c0d8a 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
@@ -290,13 +290,8 @@
 	</tbody>
       </tgroup>
     </table>
-
+  </refsect1>
+  <refsect1>
+    &return-value;
   </refsect1>
 </refentry>
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
-- 
1.7.1


