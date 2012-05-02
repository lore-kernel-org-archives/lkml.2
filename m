Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab2EBVmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 17:42:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58840 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab2EBVmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 17:42:37 -0400
From: <manjunatha_halli@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Manjunatha Halli <x0130808@ti.com>
Subject: [PATCH V3 4/5] [Documentation] Media: Update docs for V4L2 FM new features
Date: Wed, 2 May 2012 16:42:30 -0500
Message-ID: <1335994951-15842-5-git-send-email-manjunatha_halli@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1335994951-15842-1-git-send-email-manjunatha_halli@ti.com>
References: <1335994951-15842-1-git-send-email-manjunatha_halli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunatha Halli <x0130808@ti.com>

The list of new features -
	1) New control class for FM RX
	2) New FM RX CID's - De-Emphasis filter mode and RDS AF switch
	3) New FM TX CID - RDS Alternate frequency set.

Signed-off-by: Manjunatha Halli <x0130808@ti.com>
---
 Documentation/DocBook/media/v4l/compat.xml         |    3 +
 Documentation/DocBook/media/v4l/controls.xml       |   78 ++++++++++++++++++++
 Documentation/DocBook/media/v4l/dev-rds.xml        |    5 +-
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    7 ++
 .../DocBook/media/v4l/vidioc-s-hw-freq-seek.xml    |    7 ++-
 5 files changed, 97 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index bce97c5..df1f345 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2311,6 +2311,9 @@ more information.</para>
 	  <para>Added FM Modulator (FM TX) Extended Control Class: <constant>V4L2_CTRL_CLASS_FM_TX</constant> and their Control IDs.</para>
 	</listitem>
 	<listitem>
+	<para>Added FM Receiver (FM RX) Extended Control Class: <constant>V4L2_CTRL_CLASS_FM_RX</constant> and their Control IDs.</para>
+	</listitem>
+	<listitem>
 	  <para>Added Remote Controller chapter, describing the default Remote Controller mapping for media devices.</para>
 	</listitem>
       </orderedlist>
diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index b84f25e..b6e4db2 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3018,6 +3018,12 @@ to find receivers which can scroll strings sized as 32 x N or 64 x N characters.
 with steps of 32 or 64 characters. The result is it must always contain a string with size multiple of 32 or 64. </entry>
 	  </row>
 	  <row>
+	  <entry spanname="id"><constant>V4L2_CID_RDS_TX_AF_FREQ</constant>&nbsp;</entry>
+	  <entry>integer</entry>
+	  </row>
+	  <row><entry spanname="descr">Sets the RDS Alternate Frequency value which allows a receiver to re-tune to a different frequency providing the same station when the first signal becomes too weak (e.g., when moving out of range). </entry>
+	  </row>
+	  <row>
 	    <entry spanname="id"><constant>V4L2_CID_AUDIO_LIMITER_ENABLED</constant>&nbsp;</entry>
 	    <entry>boolean</entry>
 	  </row>
@@ -3146,6 +3152,78 @@ manually or automatically if set to zero. Unit, range and step are driver-specif
 <xref linkend="en50067" /> document, from CENELEC.</para>
     </section>
 
+    <section id="fm-rx-controls">
+      <title>FM Receiver Control Reference</title>
+
+      <para>The FM Receiver (FM_RX) class includes controls for common features of
+FM Reception capable devices. Currently this class includes parameter for Alternate
+frequency.</para>
+
+      <table pgwide="1" frame="none" id="fm-rx-control-id">
+      <title>FM_RX Control IDs</title>
+
+      <tgroup cols="4">
+        <colspec colname="c1" colwidth="1*" />
+        <colspec colname="c2" colwidth="6*" />
+        <colspec colname="c3" colwidth="2*" />
+        <colspec colname="c4" colwidth="6*" />
+        <spanspec namest="c1" nameend="c2" spanname="id" />
+        <spanspec namest="c2" nameend="c4" spanname="descr" />
+        <thead>
+          <row>
+            <entry spanname="id" align="left">ID</entry>
+            <entry align="left">Type</entry>
+          </row><row rowsep="1"><entry spanname="descr" align="left">Description</entry>
+          </row>
+        </thead>
+        <tbody valign="top">
+          <row><entry></entry></row>
+          <row>
+            <entry spanname="id"><constant>V4L2_CID_FM_RX_CLASS</constant>&nbsp;</entry>
+            <entry>class</entry>
+          </row><row><entry spanname="descr">The FM_RX class
+descriptor. Calling &VIDIOC-QUERYCTRL; for this control will return a
+description of this control class.</entry>
+          </row>
+          <row>
+            <entry spanname="id"><constant>V4L2_CID_RDS_AF_SWITCH</constant>&nbsp;</entry>
+            <entry>boolean</entry>
+          </row>
+          <row><entry spanname="descr">Enable/Disable's FM RX RDS Alternate frequency feature. When enabled driver will decode the RDS AF field and tries to switch to this AF frequency once current frequency RSSI level goes below threshold. Value of G_FREQUENCY is unchanged since both original frequency and AF frequency share the same PI code.</entry>
+          </row>
+          <row>
+	    <entry spanname="id"><constant>V4L2_CID_TUNE_DEEMPHASIS</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row id="v4l2-deemphasis"><entry spanname="descr">Configures the de-emphasis value for reception.
+A pre-emphasis filter is applied to the broadcast to accentuate the high audio frequencies.
+Depending on the region, a time constant of either 50 or 75 useconds is used. The enum&nbsp;v4l2_preemphasis
+defines possible values for pre-emphasis. Here they are:</entry>
+	</row><row>
+	<entrytbl spanname="descr" cols="2">
+		  <tbody valign="top">
+		    <row>
+		      <entry><constant>V4L2_PREEMPHASIS_DISABLED</constant>&nbsp;</entry>
+		      <entry>No de-emphasis is applied.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_PREEMPHASIS_50_uS</constant>&nbsp;</entry>
+		      <entry>A de-emphasis of 50 uS is used.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_PREEMPHASIS_75_uS</constant>&nbsp;</entry>
+		      <entry>A de-emphasis of 75 uS is used.</entry>
+		    </row>
+		  </tbody>
+		</entrytbl>
+
+	  </row>
+          <row><entry></entry></row>
+        </tbody>
+      </tgroup>
+      </table>
+
+      </section>
     <section id="flash-controls">
       <title>Flash Control Reference</title>
 
diff --git a/Documentation/DocBook/media/v4l/dev-rds.xml b/Documentation/DocBook/media/v4l/dev-rds.xml
index 38883a4..8188161 100644
--- a/Documentation/DocBook/media/v4l/dev-rds.xml
+++ b/Documentation/DocBook/media/v4l/dev-rds.xml
@@ -55,8 +55,9 @@ If the driver only passes RDS blocks without interpreting the data
 the <constant>V4L2_TUNER_CAP_RDS_BLOCK_IO</constant> flag has to be set. If the
 tuner is capable of handling RDS entities like program identification codes and radio
 text, the flag <constant>V4L2_TUNER_CAP_RDS_CONTROLS</constant> should be set,
-see <link linkend="writing-rds-data">Writing RDS data</link> and
-<link linkend="fm-tx-controls">FM Transmitter Control Reference</link>.</para>
+see <link linkend="writing-rds-data">Writing RDS data</link>,
+<link linkend="fm-tx-controls">FM Transmitter Control Reference</link>
+<link linkend="fm-rx-controls">FM Receiver Control Reference</link>.</para>
   </section>
 
   <section  id="reading-rds-data">
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
index b17a7aa..2a8b44e 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
@@ -258,6 +258,13 @@ These controls are described in <xref
 These controls are described in <xref
 		linkend="fm-tx-controls" />.</entry>
 	  </row>
+          <row>
+            <entry><constant>V4L2_CTRL_CLASS_FM_RX</constant></entry>
+             <entry>0x9c0000</entry>
+             <entry>The class containing FM Receiver (FM RX) controls.
+These controls are described in <xref
+                 linkend="fm-rx-controls" />.</entry>
+           </row>
 	  <row>
 	    <entry><constant>V4L2_CTRL_CLASS_FLASH</constant></entry>
 	    <entry>0x9c0000</entry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml b/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
index 18b1a82..c244da9 100644
--- a/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
@@ -95,7 +95,12 @@ field and the &v4l2-tuner; <structfield>index</structfield> field.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-	    <entry><structfield>reserved</structfield>[7]</entry>
+	    <entry><structfield>fm_band</structfield></entry>
+	    <entry>If zero search whole band (from OIRT till Weather if chip supports) else search in a mentioned bands(1=Europe/US, 2=Japan, 3=Russian and 4=Weather band)</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[6]</entry>
 	    <entry>Reserved for future extensions. Applications
 	    must set the array to zero.</entry>
 	  </row>
-- 
1.7.4.1

