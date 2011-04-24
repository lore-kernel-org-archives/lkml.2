Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695Ab1DXVLn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 17:11:43 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:48315 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756668Ab1DXVLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 17:11:41 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB491D8.6040600@verizon.net>
Date: Sun, 24 Apr 2011 17:10:48 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <uclinux-dist-devel@blackfin.uclinux.org>, <vapier@gentoo.org>
Subject: [PATCH] arch: blackfin: use cc-cross-prefix to set CROSS_COMPILE
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the blackfin Makefile to use cc-cross-prefix
to only set CROSS_COMPILE if bfin-uclinux-gcc exists.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 arch/blackfin/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/Makefile b/arch/blackfin/Makefile
index 46f42b2..3f47d26 100644
--- a/arch/blackfin/Makefile
+++ b/arch/blackfin/Makefile
@@ -7,7 +7,7 @@
 #

 ifeq ($(CROSS_COMPILE),)
-CROSS_COMPILE    := bfin-uclinux-
+CROSS_COMPILE    := $(call cc-cross-prefix, bfin-uclinux-)
 endif
 LDFLAGS_vmlinux  := -X
 OBJCOPYFLAGS     := -O binary -R .note -R .comment -S
-- 
1.7.5.rc1

