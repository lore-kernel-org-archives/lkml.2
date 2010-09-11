Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab0IKW5p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 18:57:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:21882 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab0IKW5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 18:57:44 -0400
Date: Sat, 11 Sep 2010 15:55:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] docbook: skip files with no docs since they generate scary
 warnings
Message-Id: <20100911155526.92760a0a.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix docbook templates that reference files that do not
contain the expected kernel-doc notation.

Fixes these warnings:

Warning(arch/x86/include/asm/unaligned.h): no structured comments found
Warning(lib/vsprintf.c): no structured comments found

These cause errors in the generated html output, like below,
so drop these lines.

Name
lnx-2636-rc3//arch/x86/include/asm/unaligned.h - Document generation inconsistency
Oops
Warning
The template for this document tried to insert the structured comment from the file lnx-2636-rc3//arch/x86/include/asm/unaligned.h at this point, but none was found. This dummy section is inserted to allow generation to continue.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/device-drivers.tmpl |    1 -
 Documentation/DocBook/kernel-api.tmpl     |    1 -
 2 files changed, 2 deletions(-)

--- lnx-2636-rc3.orig/Documentation/DocBook/device-drivers.tmpl
+++ lnx-2636-rc3/Documentation/DocBook/device-drivers.tmpl
@@ -46,7 +46,6 @@
 
      <sect1><title>Atomic and pointer manipulation</title>
 !Iarch/x86/include/asm/atomic.h
-!Iarch/x86/include/asm/unaligned.h
      </sect1>
 
      <sect1><title>Delaying, scheduling, and timer routines</title>
--- lnx-2636-rc3.orig/Documentation/DocBook/kernel-api.tmpl
+++ lnx-2636-rc3/Documentation/DocBook/kernel-api.tmpl
@@ -57,7 +57,6 @@
      </para>
 
      <sect1><title>String Conversions</title>
-!Ilib/vsprintf.c
 !Elib/vsprintf.c
      </sect1>
      <sect1><title>String Manipulation</title>
