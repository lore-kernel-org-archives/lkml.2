Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab2BEWaK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:30:10 -0500
Received: from 1wt.eu ([62.212.114.60]:62181 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004Ab2BEWaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:30:06 -0500
Message-Id: <20120205220953.174999716@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:11:16 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
        Michal Marek <mmarek@suse.cz>, Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 87/91] kbuild: Disable -Wunused-but-set-variable for gcc 4.6.0
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit af0e5d565d2fffcd97d1e2d89669d627cc04e8b8 upstream.

Disable the new -Wunused-but-set-variable that was added in gcc 4.6.0
It produces more false positives than useful warnings.

This can still be enabled using W=1
[gregkh - No it can not for 2.6.32, but we don't care]

Signed-off-by: Dave Jones <davej@redhat.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Tested-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Makefile |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/Makefile
===================================================================
--- longterm-2.6.27.orig/Makefile	2012-02-05 22:34:32.306915729 +0100
+++ longterm-2.6.27/Makefile	2012-02-05 22:34:47.271916824 +0100
@@ -530,6 +530,9 @@
 # Arch Makefiles may override this setting
 KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
 
+# This warning generated too much noise in a regular build.
+KBUILD_CFLAGS += $(call cc-option, -Wno-unused-but-set-variable)
+
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
 else


