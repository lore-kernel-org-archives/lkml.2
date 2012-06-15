Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab2FOTqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 15:46:36 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:52173 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757440Ab2FOTqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 15:46:35 -0400
Message-ID: <4FDB9109.7070001@xenotime.net>
Date: Fri, 15 Jun 2012 12:46:17 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Airlie <airlied@linux.ie>
Subject: [PATCH] vga_switcheroo.h: fix pci_dev warning
References: <1339320244-22792-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1339320244-22792-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix warnings on some architectures/configs (not on x86):

include/linux/vga_switcheroo.h:28:30: warning: 'struct pci_dev' declared inside parameter list [enabled by default]
include/linux/vga_switcheroo.h:28:30: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Takashi Iwai <tiwai@suse.de>
Cc:	David Airlie <airlied@linux.ie>
Reported-by:	Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/linux/vga_switcheroo.h |    2 ++
 1 file changed, 2 insertions(+)

--- lnx-35-rc2.orig/include/linux/vga_switcheroo.h
+++ lnx-35-rc2/include/linux/vga_switcheroo.h
@@ -9,6 +9,8 @@
 
 #include <linux/fb.h>
 
+struct pci_dev;
+
 enum vga_switcheroo_state {
 	VGA_SWITCHEROO_OFF,
 	VGA_SWITCHEROO_ON,
