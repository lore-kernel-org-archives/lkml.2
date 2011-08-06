Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab1HFTLN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 15:11:13 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:51114 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756614Ab1HFTLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 15:11:13 -0400
Date: Sat, 6 Aug 2011 21:11:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] memblock: add NO_BOOTMEM config symbol
Message-ID: <20110806191111.GB8494@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the NO_BOOTMEM symbol added archistectures may now
use the following syntax to tell that they do not need bootmem:

	select NO_BOOTMEM

This is much more convinient than adding a new kconfig symbol
which was otherwise required.

Addign this symbol does not conflict with the architctures that
already define their own symbol.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Yinghai Lu <yinghai@kernel.org>
---
diff --git a/mm/Kconfig b/mm/Kconfig
index 7c56971..af0047d 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -137,6 +137,9 @@ config HAVE_MEMBLOCK_NODE_MAP
 config ARCH_DISCARD_MEMBLOCK
 	boolean
 
+config NO_BOOTMEM
+	boolean
+
 # eventually, we can have this option just 'select SPARSEMEM'
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
