Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab1GFSFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:05:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554Ab1GFSFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:05:02 -0400
Date: Wed, 6 Jul 2011 15:03:53 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFCv3 05/17] [media] DocBook: Remove V4L generic error
 description for ioctl()
Message-ID: <20110706150353.36224550@pedra>
In-Reply-To: <cover.1309974026.git.mchehab@redhat.com>
References: <cover.1309974026.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V4L ioctl function descripton also has a generic error chapter.
Remove it, as it is now obsoleted by a general, multi-API generic
error descriptions.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/v4l/func-ioctl.xml b/Documentation/DocBook/media/v4l/func-ioctl.xml
index b60fd37..2de64be 100644
--- a/Documentation/DocBook/media/v4l/func-ioctl.xml
+++ b/Documentation/DocBook/media/v4l/func-ioctl.xml
@@ -64,75 +64,9 @@ their respective function and parameters are specified in <xref
   </refsect1>
 
   <refsect1>
-    <title>Return Value</title>
-
-    <para>On success the <function>ioctl()</function> function returns
-<returnvalue>0</returnvalue> and does not reset the
-<varname>errno</varname> variable. On failure
-<returnvalue>-1</returnvalue> is returned, when the ioctl takes an
-output or read/write parameter it remains unmodified, and the
-<varname>errno</varname> variable is set appropriately. See below for
-possible error codes. Generic errors like <errorcode>EBADF</errorcode>
-or <errorcode>EFAULT</errorcode> are not listed in the sections
-discussing individual ioctl requests.</para>
-    <para>Note ioctls may return undefined error codes. Since errors
-may have side effects such as a driver reset applications should
-abort on unexpected errors.</para>
-
-    <variablelist>
-      <varlistentry>
-	<term><errorcode>EBADF</errorcode></term>
-	<listitem>
-	  <para><parameter>fd</parameter> is not a valid open file
-descriptor.</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><errorcode>EBUSY</errorcode></term>
-	<listitem>
-	  <para>The property cannot be changed right now. Typically
-this error code is returned when I/O is in progress or the driver
-supports multiple opens and another process locked the property.</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><errorcode>EFAULT</errorcode></term>
-	<listitem>
-	  <para><parameter>argp</parameter> references an inaccessible
-memory area.</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><errorcode>ENOTTY</errorcode></term>
-	<listitem>
-	  <para><parameter>fd</parameter> is  not  associated  with  a
-character special device.</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><errorcode>EINVAL</errorcode></term>
-	<listitem>
-	  <para>The <parameter>request</parameter> or the data pointed
-to by <parameter>argp</parameter> is not valid. This is a very common
-error code, see the individual ioctl requests listed in <xref
-	      linkend="user-func" /> for actual causes.</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><errorcode>ENOMEM</errorcode></term>
-	<listitem>
-	  <para>Not enough physical or virtual memory was available to
-complete the request.</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><errorcode>ERANGE</errorcode></term>
-	<listitem>
-	  <para>The application attempted to set a control with the
-&VIDIOC-S-CTRL; ioctl to a value which is out of bounds.</para>
-	</listitem>
-      </varlistentry>
-    </variablelist>
+    &return-value;
+    <para>When an ioctl that takes an output or read/write parameter fails,
+    the parameter remains unmodified.</para>
   </refsect1>
 </refentry>
 
diff --git a/Documentation/DocBook/media/v4l/gen-errors.xml b/Documentation/DocBook/media/v4l/gen-errors.xml
index a7f73c9..2b50b63 100644
--- a/Documentation/DocBook/media/v4l/gen-errors.xml
+++ b/Documentation/DocBook/media/v4l/gen-errors.xml
@@ -31,7 +31,8 @@
       <row>
 	<entry>EINVAL or ENOTTY</entry>
 	<entry>The ioctl is not supported by the driver, actually meaning that
-	       the required functionality is not available.</entry>
+	       the required functionality is not available, or the file
+	       descriptor is not for a media device.</entry>
       </row>
       <row>
 	<entry>ENOMEM</entry>
@@ -46,3 +47,10 @@
     </tbody>
   </tgroup>
 </table>
+
+<para>Note 1: ioctls may return other error codes. Since errors may have side
+effects such as a driver reset, applications should abort on unexpected errors.
+</para>
+
+<para>Note 2: Request-specific error codes are listed in the individual
+requests descriptions.</para>
diff --git a/Documentation/DocBook/media/v4l/media-func-ioctl.xml b/Documentation/DocBook/media/v4l/media-func-ioctl.xml
index e0ee285..39478d0 100644
--- a/Documentation/DocBook/media/v4l/media-func-ioctl.xml
+++ b/Documentation/DocBook/media/v4l/media-func-ioctl.xml
@@ -64,6 +64,7 @@
 
   <refsect1>
     &return-value;
+
     <para>Request-specific error codes are listed in the
     individual requests descriptions.</para>
     <para>When an ioctl that takes an output or read/write parameter fails,
-- 
1.7.1


