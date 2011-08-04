Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab1HDPxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 11:53:44 -0400
Received: from mxout1.netvision.net.il ([194.90.9.20]:40123 "EHLO
	mxout1.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab1HDPxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 11:53:42 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Aug 2011 11:53:42 EDT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <4E3ABDB7.1000300@billauer.co.il>
Date: Thu, 04 Aug 2011 18:41:43 +0300
From: Eli Billauer <eli@billauer.co.il>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] microblaze: Removed U-Boot image creation from simpleImage rule
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The simpleImage rule used to create a U-boot image as well, resulting in
a build error if the mkimage utility wasn't set up. A line in the Makefile
was removed, so "make simpleImage.(something)" now does what one should 
expect.
---
 arch/microblaze/boot/Makefile |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/boot/Makefile b/arch/microblaze/boot/Makefile
index 4c4e58e..2c8a2c9 100644
--- a/arch/microblaze/boot/Makefile
+++ b/arch/microblaze/boot/Makefile
@@ -44,7 +44,6 @@ quiet_cmd_uimage = UIMAGE  $@.ub
 $(obj)/simpleImage.%: vmlinux FORCE
     $(call if_changed,cp,.unstrip)
     $(call if_changed,objcopy)
-    $(call if_changed,uimage)
     $(call if_changed,strip)
     @echo 'Kernel: $@ is ready' ' (#'`cat .version`')'
 
-- 
1.7.2.2


-- 
Web: http://www.billauer.co.il

