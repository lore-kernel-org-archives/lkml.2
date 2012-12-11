Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab2LKXMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 18:12:33 -0500
Received: from www.linutronix.de ([62.245.132.108]:44885 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab2LKXMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 18:12:31 -0500
From: Benedikt Spranger <b.spranger@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: hjk@hansjkoch.de, gregkh@linuxfoundation.org,
        Alexander.Frank@eberspaecher.com,
        Benedikt Spranger <b.spranger@linutronix.de>
Subject: [PATCH 1/2] uio: add warning to documentation
Date: Wed, 12 Dec 2012 00:12:01 +0100
Message-Id: <1355267523-19724-2-git-send-email-b.spranger@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355267523-19724-1-git-send-email-b.spranger@linutronix.de>
References: <1355267523-19724-1-git-send-email-b.spranger@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation has no clear statement to the POSIX 1003.1 mmap()
feature, wich allows open(), mmap(), close() while the mmaped pointer is valid.
The release() hook inveigled driver programmer to activate owermanagement
functuonality in the release hook. This may harm.

Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
---
 Documentation/DocBook/uio-howto.tmpl |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
index ac3d001..59a886d 100644
--- a/Documentation/DocBook/uio-howto.tmpl
+++ b/Documentation/DocBook/uio-howto.tmpl
@@ -499,8 +499,13 @@ device is actually used.
 <listitem><para>
 <varname>int (*release)(struct uio_info *info, struct inode *inode)
 </varname>: Optional. If you define your own
-<function>open()</function>, you will probably also want a custom
+<function>release()</function>, you will probably also want a custom
 <function>release()</function> function.
+</para><para>CAVE: The release hook may be processed, even if a mmap is aktive.
+Disabling clocks or other powermanagement functionality may cause a system
+crash, hangup or other unwanted sideeffects.
+</para><para><emphasis>The mmap() function shall add an extra reference to the file associated with the file descriptor fildes which is not removed by a subsequent close() on that file descriptor. This reference shall be removed when there are no more mappings to the file.</emphasis></para><para>
+<link xlink:href="http://pubs.opengroup.org/onlinepubs/009695399/functions/mmap.html">IEEE Std 1003.1, 2004 Edition, mmap()</link>
 </para></listitem>
 
 <listitem><para>
-- 
1.7.10.4

