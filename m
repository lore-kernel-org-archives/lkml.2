Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab0LCXwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 18:52:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52962 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493Ab0LCXwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 18:52:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the acpi tree
Date: Sat, 4 Dec 2010 00:51:23 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <20101202112239.c7d05518.sfr@canb.auug.org.au>
In-Reply-To: <20101202112239.c7d05518.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201012040051.23769.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 02, 2010, Stephen Rothwell wrote:
> Hi Len,
> 
> After merging the acpi tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> In file included from drivers/video/output.c:25:
> include/linux/video_output.h: In function 'video_output_register':
> include/linux/video_output.h:49: error: implicit declaration of function 'ERR_PTR'
> include/linux/video_output.h:49: warning: return makes pointer from integer without a cast
> In file included from drivers/video/output.c:27:
> include/linux/err.h: At top level:
> include/linux/err.h:22: error: conflicting types for 'ERR_PTR'
> include/linux/video_output.h:49: note: previous implicit declaration of 'ERR_PTR' was here
> drivers/video/output.c:84: error: redefinition of 'video_output_register'
> include/linux/video_output.h:44: note: previous definition of 'video_output_register' was here
> drivers/video/output.c:114: error: redefinition of 'video_output_unregister'
> include/linux/video_output.h:51: note: previous definition of 'video_output_unregister' was here
> 
> Caused by commit 16d21716c8849c3283d1b9e590e6fe8d1966f4b7 ("ACPI: video:
> fix build for VIDEO_OUTPUT_CONTROL=n").  See Rule 1 in
> Documentation/SubmitChecklist.
> 
> I have used the version of the acpi tree from next-20101201 for today.

Something like this will help, perhaps:

---
 include/linux/video_output.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/include/linux/video_output.h
===================================================================
--- linux-2.6.orig/include/linux/video_output.h
+++ linux-2.6/include/linux/video_output.h
@@ -23,6 +23,7 @@
 #ifndef _LINUX_VIDEO_OUTPUT_H
 #define _LINUX_VIDEO_OUTPUT_H
 #include <linux/device.h>
+#include <linux/err.h>
 struct output_device;
 struct output_properties {
 	int (*set_state)(struct output_device *);
