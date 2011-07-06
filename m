Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab1GFSEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:04:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755264Ab1GFSEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:04:36 -0400
Date: Wed, 6 Jul 2011 15:04:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFCv3 14/17] [media] DocBook/dvb: Use generic descriptions
 for the frontend API
Message-ID: <20110706150401.0223251a@pedra>
In-Reply-To: <cover.1309974026.git.mchehab@redhat.com>
References: <cover.1309974026.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move generic stuff into gen-errors.xml, and remove them from
DVB API. While here, removes two bogus error codes that aren't
supported or used on Linux: EINTERNAL and ENOSIGNAL.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 33274bc..207e1a5 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -82,15 +82,6 @@ struct dtv_properties {
  </row></tbody></tgroup></informaltable>
 &return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row>
-  <entry align="char"><para>EINVAL</para></entry>
-  <entry align="char"><para>Invalid parameter(s) received or number of parameters out of the range.</para></entry>
- </row><row>
-  <entry align="char"><para>ENOMEM</para></entry>
-  <entry align="char"><para>Out of memory.</para></entry>
- </row><row>
-  <entry align="char"><para>EFAULT</para></entry>
-  <entry align="char"><para>Failure while copying data from/to userspace.</para></entry>
- </row><row>
   <entry align="char"><para>EOPNOTSUPP</para></entry>
   <entry align="char"><para>Property type not supported.</para></entry>
  </row></tbody></tgroup></informaltable>
@@ -139,15 +130,6 @@ struct dtv_properties {
  </row></tbody></tgroup></informaltable>
 &return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row>
-  <entry align="char"><para>EINVAL</para></entry>
-  <entry align="char"><para>Invalid parameter(s) received or number of parameters out of the range.</para></entry>
- </row><row>
-  <entry align="char"><para>ENOMEM</para></entry>
-  <entry align="char"><para>Out of memory.</para></entry>
- </row><row>
-  <entry align="char"><para>EFAULT</para></entry>
-  <entry align="char"><para>Failure while copying data from/to userspace.</para></entry>
- </row><row>
   <entry align="char"><para>EOPNOTSUPP</para></entry>
   <entry align="char"><para>Property type not supported.</para></entry>
  </row></tbody></tgroup></informaltable>
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index c5a5cb4..61407ea 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -575,7 +575,7 @@ typedef enum fe_hierarchy {
 <para>File descriptor returned by a previous call to open().</para>
 </entry>
  </row></tbody></tgroup></informaltable>
-&return-value-dvb;
+<para>RETURN VALUE</para>
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
 <para>EBADF</para>
@@ -692,37 +692,8 @@ typedef enum fe_hierarchy {
 <para>The bit error rate is stored into *ber.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
+
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EFAULT</para>
-</entry><entry
- align="char">
-<para>ber points to invalid address.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>ENOSIGNAL</para>
-</entry><entry
- align="char">
-<para>There is no signal, thus no meaningful bit error rate. Also
- returned if the front-end is not turned on.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>ENOSYS</para>
-</entry><entry
- align="char">
-<para>Function not available for this device.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 </section>
 
 <section id="FE_READ_SNR">
@@ -770,36 +741,6 @@ typedef enum fe_hierarchy {
  </row></tbody></tgroup></informaltable>
 
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EFAULT</para>
-</entry><entry
- align="char">
-<para>snr points to invalid address.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>ENOSIGNAL</para>
-</entry><entry
- align="char">
-<para>There is no signal, thus no meaningful signal strength
- value. Also returned if front-end is not turned on.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>ENOSYS</para>
-</entry><entry
- align="char">
-<para>Function not available for this device.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 </section>
 
 <section id="FE_READ_SIGNAL_STRENGTH">
@@ -846,37 +787,8 @@ typedef enum fe_hierarchy {
 <para>The signal strength value is stored into *strength.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
+
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EFAULT</para>
-</entry><entry
- align="char">
-<para>status points to invalid address.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>ENOSIGNAL</para>
-</entry><entry
- align="char">
-<para>There is no signal, thus no meaningful signal strength
- value. Also returned if front-end is not turned on.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>ENOSYS</para>
-</entry><entry
- align="char">
-<para>Function not available for this device.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 </section>
 
 <section id="FE_READ_UNCORRECTED_BLOCKS">
@@ -930,29 +842,8 @@ typedef enum fe_hierarchy {
  so far.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
+
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EFAULT</para>
-</entry><entry
- align="char">
-<para>ublocks points to invalid address.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>ENOSYS</para>
-</entry><entry
- align="char">
-<para>Function not available for this device.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 </section>
 
 <section id="FE_SET_FRONTEND">
@@ -1005,23 +896,10 @@ typedef enum fe_hierarchy {
 <para>Points to parameters for tuning operation.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
+
 &return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EFAULT</para>
-</entry><entry
- align="char">
-<para>p points to invalid address.</para>
-</entry>
- </row><row><entry
- align="char">
 <para>EINVAL</para>
 </entry><entry
  align="char">
@@ -1078,23 +956,8 @@ typedef enum fe_hierarchy {
  </row></tbody></tgroup></informaltable>
 
 &return-value-dvb;
-
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EFAULT</para>
-</entry><entry
- align="char">
-<para>p points to invalid address.</para>
-</entry>
- </row><row><entry
- align="char">
 <para>EINVAL</para>
 </entry><entry
  align="char">
@@ -1181,20 +1044,6 @@ typedef enum fe_hierarchy {
 &return-value-dvb;
 <informaltable><tgroup cols="2"><tbody><row><entry
  align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EFAULT</para>
-</entry><entry
- align="char">
-<para>ev points to invalid address.</para>
-</entry>
- </row><row><entry
- align="char">
 <para>EWOULDBLOCK</para>
 </entry><entry
  align="char">
@@ -1206,11 +1055,6 @@ typedef enum fe_hierarchy {
 <para>EOVERFLOW</para>
 </entry><entry
  align="char">
-</entry>
- </row><row><entry
- align="char">
-</entry><entry
- align="char">
 <para>Overflow in event queue - one or more events were lost.</para>
 </entry>
 </row></tbody></tgroup></informaltable>
@@ -1264,21 +1108,6 @@ typedef enum fe_hierarchy {
 </entry>
  </row></tbody></tgroup></informaltable>
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid open file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EFAULT</para>
-</entry><entry
- align="char">
-<para>info points to invalid address.</para>
-</entry>
-</row></tbody></tgroup></informaltable>
 </section>
 
 <section id="FE_DISEQC_RESET_OVERLOAD">
@@ -1322,28 +1151,6 @@ typedef enum fe_hierarchy {
  </row></tbody></tgroup></informaltable>
 
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EPERM</para>
-</entry><entry
- align="char">
-<para>Permission denied (needs read/write access).</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINTERNAL</para>
-</entry><entry
- align="char">
-<para>Internal error in the device driver.</para>
-</entry>
-</row></tbody></tgroup></informaltable>
 </section>
 
 <section id="FE_DISEQC_SEND_MASTER_CMD">
@@ -1394,43 +1201,6 @@ typedef enum fe_hierarchy {
  </row></tbody></tgroup></informaltable>
 
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EFAULT</para>
-</entry><entry
- align="char">
-<para>Seq points to an invalid address.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINVAL</para>
-</entry><entry
- align="char">
-<para>The data structure referred to by seq is invalid in some
- way.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EPERM</para>
-</entry><entry
- align="char">
-<para>Permission denied (needs read/write access).</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINTERNAL</para>
-</entry><entry
- align="char">
-<para>Internal error in the device driver.</para>
-</entry>
-</row></tbody></tgroup></informaltable>
 </section>
 
 <section id="FE_DISEQC_RECV_SLAVE_REPLY">
@@ -1481,43 +1251,6 @@ typedef enum fe_hierarchy {
 </entry>
  </row></tbody></tgroup></informaltable>
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EFAULT</para>
-</entry><entry
- align="char">
-<para>Seq points to an invalid address.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINVAL</para>
-</entry><entry
- align="char">
-<para>The data structure referred to by seq is invalid in some
- way.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EPERM</para>
-</entry><entry
- align="char">
-<para>Permission denied (needs read/write access).</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINTERNAL</para>
-</entry><entry
- align="char">
-<para>Internal error in the device driver.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 </section>
 
 <section id="FE_DISEQC_SEND_BURST">
@@ -1566,43 +1299,6 @@ typedef enum fe_hierarchy {
  </row></tbody></tgroup></informaltable>
 
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EBADF</para>
-</entry><entry
- align="char">
-<para>fd is not a valid file descriptor.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EFAULT</para>
-</entry><entry
- align="char">
-<para>Seq points to an invalid address.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINVAL</para>
-</entry><entry
- align="char">
-<para>The data structure referred to by seq is invalid in some
- way.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EPERM</para>
-</entry><entry
- align="char">
-<para>Permission denied (needs read/write access).</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINTERNAL</para>
-</entry><entry
- align="char">
-<para>Internal error in the device driver.</para>
-</entry>
-</row></tbody></tgroup></informaltable>
 </section>
 
 <section id="FE_SET_TONE">
@@ -1649,42 +1345,6 @@ typedef enum fe_hierarchy {
 </entry>
  </row></tbody></tgroup></informaltable>
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>ENODEV</para>
-</entry><entry
- align="char">
-<para>Device driver not loaded/available.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EBUSY</para>
-</entry><entry
- align="char">
-<para>Device or resource busy.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINVAL</para>
-</entry><entry
- align="char">
-<para>Invalid argument.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EPERM</para>
-</entry><entry
- align="char">
-<para>File not opened with read permissions.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINTERNAL</para>
-</entry><entry
- align="char">
-<para>Internal error in the device driver.</para>
-</entry>
-</row></tbody></tgroup></informaltable>
 </section>
 
 <section id="FE_SET_VOLTAGE">
@@ -1733,42 +1393,6 @@ typedef enum fe_hierarchy {
  </row></tbody></tgroup></informaltable>
 
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>ENODEV</para>
-</entry><entry
- align="char">
-<para>Device driver not loaded/available.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EBUSY</para>
-</entry><entry
- align="char">
-<para>Device or resource busy.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINVAL</para>
-</entry><entry
- align="char">
-<para>Invalid argument.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EPERM</para>
-</entry><entry
- align="char">
-<para>File not opened with read permissions.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINTERNAL</para>
-</entry><entry
- align="char">
-<para>Internal error in the device driver.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 </section>
 
 <section id="FE_ENABLE_HIGH_LNB_VOLTAGE">
@@ -1818,42 +1442,6 @@ typedef enum fe_hierarchy {
  </row></tbody></tgroup></informaltable>
 
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>ENODEV</para>
-</entry><entry
- align="char">
-<para>Device driver not loaded/available.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EBUSY</para>
-</entry><entry
- align="char">
-<para>Device or resource busy.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINVAL</para>
-</entry><entry
- align="char">
-<para>Invalid argument.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EPERM</para>
-</entry><entry
- align="char">
-<para>File not opened with read permissions.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EINTERNAL</para>
-</entry><entry
- align="char">
-<para>Internal error in the device driver.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 </section>
 
 <section id="FE_SET_FRONTEND_TUNE_MODE">
@@ -1886,10 +1474,6 @@ FE_TUNE_MODE_ONESHOT When set, this flag will disable any zigzagging or other "n
  </row></tbody></tgroup></informaltable>
 
 &return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row>
-<entry align="char"><para>EINVAL</para></entry>
-<entry align="char"><para>Invalid argument.</para></entry>
- </row></tbody></tgroup></informaltable>
 </section>
 
 <section id="FE_DISHNETWORK_SEND_LEGACY_CMD">
@@ -1924,11 +1508,6 @@ sends the specified raw cmd to the dish via DISEqC.
  </row></tbody></tgroup></informaltable>
 
 &return-value-dvb;
-<informaltable><tgroup cols="1"><tbody><row>
-<entry align="char">
-	<para>There are no errors in use for this call</para>
-</entry>
-</row></tbody></tgroup></informaltable>
 </section>
 
 </section>
diff --git a/Documentation/DocBook/media/v4l/gen-errors.xml b/Documentation/DocBook/media/v4l/gen-errors.xml
index 3e6ddd9..dedcc90 100644
--- a/Documentation/DocBook/media/v4l/gen-errors.xml
+++ b/Documentation/DocBook/media/v4l/gen-errors.xml
@@ -8,7 +8,7 @@
 	<!-- Keep it ordered alphabetically -->
       <row>
 	<entry>EBADF</entry>
-	<entry><parameter>fd</parameter> is not a valid open file descriptor.</entry>
+	<entry>The file descriptor is not a valid.</entry>
       </row>
       <row>
 	<entry>EBUSY</entry>
@@ -21,18 +21,20 @@
       </row>
       <row>
 	<entry>EFAULT</entry>
-	<entry><parameter>fd</parameter> is not a valid open file descriptor.</entry>
+	<entry>There was a failure while copying data from/to userspace.</entry>
       </row>
       <row>
 	<entry>EINVAL</entry>
-	<entry>One or more of the ioctl parameters are invalid. This is a widely
-	       error code. see the individual ioctl requests for actual causes.</entry>
+	<entry>One or more of the ioctl parameters are invalid or out of the
+	       allowed range. This is a widely error code. See the individual
+	       ioctl requests for specific causes.</entry>
       </row>
       <row>
 	<entry>EINVAL or ENOTTY</entry>
 	<entry>The ioctl is not supported by the driver, actually meaning that
 	       the required functionality is not available, or the file
-	       descriptor is not for a media device.</entry>
+	       descriptor is not for a media device. The usage of EINVAL is
+	       deprecated and will be fixed on a latter patch.</entry>
       </row>
       <row>
         <entry>ENODEV</entry>
@@ -49,6 +51,17 @@
 	       for periodic transfers (up to 80% of the USB bandwidth).</entry>
       </row>
       <row>
+	<entry>ENOSYS or EOPNOTSUPP</entry>
+	<entry>Function not available for this device (dvb API only. Will likely
+	       be replaced anytime soon by ENOTTY).</entry>
+      </row>
+      <row>
+	<entry>EPERM</entry>
+	<entry>Permission denied. Can be returned if the device needs write
+		permission, or some special capabilities is needed
+		(e. g. root)</entry>
+      </row>
+      <row>
 	<entry>EWOULDBLOCK</entry>
 	<entry>Operation would block. Used when the ioctl would need to wait
 	       for an event, but the device was opened in non-blocking mode.</entry>
-- 
1.7.1


