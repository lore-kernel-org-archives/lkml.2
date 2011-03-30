Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965274Ab1C3VKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:10:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:38344 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965281Ab1C3VKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:10:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411279227"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: cascardo@holoscopio.com, mjg@redhat.com, ak@linux.intel.com,
        randy.dunlap@oracle.com, platform-driver-x86@vger.kernel.org,
        don@syst.com.br, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [256/275] classmate-laptop: depends on RFKILL or RFKILL=n
Message-Id: <20110330210823.3951A3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

[ upstream commit f35843ed8d17562f7c5da4b34a4a81b0cc450e9e ]

Randy Dunlap has reported that building classmate-laptop fails when
CONFIG_RFKILL=m and CONFIG_ACPI_CMPC=y. He suggested depending on
RFKILL, but, then, it will not be possible to select classmate-laptop
when RFKILL is off. There's no known problem with building and using
classmate-laptop with RFKILL off. So depend on RFKILL or RFKILL=n.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: platform-driver-x86@vger.kernel.org
Cc: Daniel Oliveira Nascimento <don@syst.com.br>

---
 drivers/platform/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/drivers/platform/x86/Kconfig
===================================================================
--- linux-2.6.35.y.orig/drivers/platform/x86/Kconfig	2011-03-29 23:03:58.646799545 -0700
+++ linux-2.6.35.y/drivers/platform/x86/Kconfig	2011-03-29 23:04:02.297706128 -0700
@@ -520,6 +520,7 @@
 config ACPI_CMPC
 	tristate "CMPC Laptop Extras"
 	depends on X86 && ACPI
+	depends on RFKILL || RFKILL=n
 	select INPUT
 	select BACKLIGHT_CLASS_DEVICE
 	default n
