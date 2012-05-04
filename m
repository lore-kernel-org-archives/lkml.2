Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab2EDUqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:46:34 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:61380 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469Ab2EDUqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:46:31 -0400
Message-Id: <20120504204228.639743899@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [ 50/75] x86, boot: Restrict CFLAGS for hostprogs
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <matt.fleming@intel.com>

commit d40f833630a1299fd377408dc8d8fac370d621b0 upstream.

Currently tools/build has access to all the kernel headers in
$(srctree). This is unnecessary and could potentially allow
tools/build to erroneously include kernel headers when it should only
be including userspace-exported headers.

Unfortunately, mkcpustr still needs access to some of the asm kernel
headers, so explicitly special case that hostprog.

Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1330436245-24875-5-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/boot/Makefile |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -37,8 +37,9 @@ setup-y		+= video-bios.o
 targets		+= $(setup-y)
 hostprogs-y	:= mkcpustr tools/build
 
-HOST_EXTRACFLAGS += $(LINUXINCLUDE)
-
+HOSTCFLAGS_mkcpustr.o := -I$(srctree)/arch/$(SRCARCH)/include
+HOST_EXTRACFLAGS += -I$(objtree)/include -I$(srctree)/tools/include \
+                   -include $(srctree)/include/linux/kconfig.h
 $(obj)/cpu.o: $(obj)/cpustr.h
 
 quiet_cmd_cpustr = CPUSTR  $@


