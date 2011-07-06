Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab1GFSEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:04:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441Ab1GFSEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:04:50 -0400
Date: Wed, 6 Jul 2011 15:03:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFCv3 01/17] [media] DocBook: Add a chapter to describe
 media errors
Message-ID: <20110706150350.2b8111bb@pedra>
In-Reply-To: <cover.1309974026.git.mchehab@redhat.com>
References: <cover.1309974026.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several errors reported by V4L that aren't described.
They can occur on almost all ioctl's. Instead of adding them
into each ioctl, create a new chapter.

For V4L, the new chapter will automatically be listed on all
places, as there's a macro used everywhere there.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 create mode 100644 Documentation/DocBook/media/v4l/gen-errors.xml

diff --git a/Documentation/DocBook/.gitignore b/Documentation/DocBook/.gitignore
index 25214a5..720f245 100644
--- a/Documentation/DocBook/.gitignore
+++ b/Documentation/DocBook/.gitignore
@@ -8,5 +8,7 @@
 *.dvi
 *.log
 *.out
+*.png
+*.gif
 media-indices.tmpl
 media-entities.tmpl
diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index 8cb27f3..6628b4b 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -100,23 +100,59 @@ STRUCTS = \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/v4l2-mediabus.h)
 
 ERRORS = \
+	E2BIG \
 	EACCES \
 	EAGAIN \
 	EBADF \
+	EBADFD \
+	EBADR \
+	EBADRQC \
 	EBUSY \
+	ECHILD \
+	ECONNRESET \
+	EDEADLK \
+	EDOM \
+	EEXIST \
 	EFAULT \
-	EIO \
+	EFBIG \
+	EILSEQ \
+	EINIT \
+	EINPROGRESS \
 	EINTR \
 	EINVAL \
+	EIO \
+	EMFILE \
 	ENFILE \
+	ENOBUFS \
+	ENODATA \
+	ENODEV \
+	ENOENT \
+	ENOIOCTLCMD \
 	ENOMEM \
 	ENOSPC \
+	ENOSR \
+	ENOSYS \
+	ENOTSUP \
+	ENOTSUPP \
 	ENOTTY \
 	ENXIO \
-	EMFILE \
+	EOPNOTSUPP \
+	EOVERFLOW \
 	EPERM \
-	ERANGE \
 	EPIPE \
+	EPROTO \
+	ERANGE \
+	EREMOTE \
+	EREMOTEIO \
+	ERESTART \
+	ERESTARTSYS \
+	ESHUTDOWN \
+	ESPIPE \
+	ETIME \
+	ETIMEDOUT \
+	EUSERS \
+	EWOULDBLOCK \
+	EXDEV \
 
 ESCAPE = \
 	-e "s/&/\\&amp;/g" \
diff --git a/Documentation/DocBook/media/v4l/gen-errors.xml b/Documentation/DocBook/media/v4l/gen-errors.xml
new file mode 100644
index 0000000..1efc688
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/gen-errors.xml
@@ -0,0 +1,17 @@
+<title>Generic Error Codes</title>
+
+<table frame="none" pgwide="1" id="gen-errors">
+  <title>Generic error codes</title>
+  <tgroup cols="2">
+    &cs-str;
+    <tbody valign="top">
+      <row>
+	<entry>EBUSY</entry>
+	<entry>The ioctl can't be handled because the device is busy. This is
+	       typically return while device is streaming, and an ioctl tried to
+	       change something that would affect the stream, or would require the
+	       usage of a hardware resource that was already allocated.</entry>
+      </row>
+    </tbody>
+  </tgroup>
+</table>
diff --git a/Documentation/DocBook/media_api.tmpl b/Documentation/DocBook/media_api.tmpl
index 88f2cc6..bdb06bc 100644
--- a/Documentation/DocBook/media_api.tmpl
+++ b/Documentation/DocBook/media_api.tmpl
@@ -8,7 +8,7 @@
 <!ENTITY ie                     "i.&nbsp;e.">
 <!ENTITY fd                     "File descriptor returned by <link linkend='func-open'><function>open()</function></link>.">
 <!ENTITY i2c                    "I<superscript>2</superscript>C">
-<!ENTITY return-value		"<title>Return Value</title><para>On success <returnvalue>0</returnvalue> is returned, on error <returnvalue>-1</returnvalue> and the <varname>errno</varname> variable is set appropriately:</para>">
+<!ENTITY return-value		"<title>Return Value</title><para>On success <returnvalue>0</returnvalue> is returned, on error <returnvalue>-1</returnvalue> and the <varname>errno</varname> variable is set appropriately. The generic error codes are described at the <link linkend='gen-errors'>Generic Error Codes</link> chapter.</para>">
 <!ENTITY manvol                 "<manvolnum>2</manvolnum>">
 
 <!-- Table templates: structs, structs w/union, defines. -->
@@ -110,6 +109,11 @@ Foundation. A copy of the license is included in the chapter entitled
 &sub-media-controller;
 </part>
 
+<chapter id="gen_errors">
+&sub-gen-errors;
+</chapter>
+
+
 &sub-fdl-appendix;
 
 </book>
-- 
1.7.1


