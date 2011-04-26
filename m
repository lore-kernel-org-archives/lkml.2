Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551Ab1DZAV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 20:21:29 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:53125 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932167Ab1DZAV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 20:21:28 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB60FE2.5080701@verizon.net>
Date: Mon, 25 Apr 2011 20:20:50 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-ia64@vger.kernel.org>, <tony.luck@intel.com>,
        <fenghua.yu@intel.com>
Subject: [PATCH] arch: ia64: don't check the toolchain if nothing is being
 compiled
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch disables the ia64 toolchain checks if nothing is being compiled
so targets like headers_install_all don't spew errors when they try
to compile ia64 code with a toolchain targeting a different architecture.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 arch/ia64/Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/Makefile b/arch/ia64/Makefile
index be7bfa1..b6279a0 100644
--- a/arch/ia64/Makefile
+++ b/arch/ia64/Makefile
@@ -30,8 +30,10 @@ cflags-y	:= -pipe $(EXTRA) -ffixed-r13 -mfixed-range=f12-f15,f32-f127 \
 		   -falign-functions=32 -frename-registers -fno-optimize-sibling-calls
 KBUILD_CFLAGS_KERNEL := -mconstant-gp
 +ifeq ($(dot-config),1)
 GAS_STATUS	= $(shell $(srctree)/arch/ia64/scripts/check-gas "$(CC)" "$(OBJDUMP)")
 KBUILD_CPPFLAGS += $(shell $(srctree)/arch/ia64/scripts/toolchain-flags "$(CC)" "$(OBJDUMP)" "$(READELF)")
+endif
  ifeq ($(GAS_STATUS),buggy)
 $(error Sorry, you need a newer version of the assember, one that is built from	\
-- 
1.7.5.rc1

