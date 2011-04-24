Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735Ab1DXUhI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 16:37:08 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:59940 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757669Ab1DXUhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 16:37:05 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB489BF.80106@verizon.net>
Date: Sun, 24 Apr 2011 16:36:15 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <ysato@users.sourceforge.jp>
Subject: [PATCH 2/2] arch: h8300: use cc-cross-prefix to set CROSS_COMPILE
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the h8300 Makefile to use cc-cross-prefix 
to only set CROSS_COMPILE if h8300-elf-gcc exists.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 arch/h8300/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/h8300/Makefile b/arch/h8300/Makefile
index a556447..43646f0 100644
--- a/arch/h8300/Makefile
+++ b/arch/h8300/Makefile
@@ -38,7 +38,7 @@ KBUILD_CFLAGS += -DUTS_SYSNAME=\"uClinux\"
 KBUILD_AFLAGS += -DPLATFORM=$(PLATFORM) -DMODEL=$(MODEL) $(cflags-y)
 LDFLAGS += $(ldflags-y)
 
-CROSS_COMPILE = h8300-elf-
+CROSS_COMPILE = $(call cc-cross-prefix, h8300-elf-)
 LIBGCC := $(shell $(CROSS-COMPILE)$(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
 
 head-y := arch/$(ARCH)/platform/$(PLATFORM)/$(BOARD)/crt0_$(MODEL).o
-- 
1.7.5.rc1

