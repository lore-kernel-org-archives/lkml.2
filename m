Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab1BYCjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 21:39:40 -0500
Received: from cantor.suse.de ([195.135.220.2]:40154 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518Ab1BYCjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 21:39:39 -0500
Message-ID: <4D671667.4000602@suse.com>
Date: Thu, 24 Feb 2011 21:39:35 -0500
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] firmware: Allow release-specific firmware dir
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Every kernel package trying to provide files under /lib/firmware runs
 into problems really quickly with multiple kernels installed.

 This patch moves them to /lib/firmware/$KERNELRELEASE. udev v127's
 firmware.sh looks there first before falling back to /lib/firmware.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -975,7 +975,7 @@ depend dep:
 
 # ---------------------------------------------------------------------------
 # Firmware install
-INSTALL_FW_PATH=$(INSTALL_MOD_PATH)/lib/firmware
+INSTALL_FW_PATH=$(INSTALL_MOD_PATH)/lib/firmware/$(KERNELRELEASE)
 export INSTALL_FW_PATH
 
 PHONY += firmware_install
-- 
Jeff Mahoney
SUSE Labs
