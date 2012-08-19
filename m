Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab2HSDBF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:01:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:48688 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632Ab2HSC5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="182422058"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>, tiwai@suse.de
Subject: [PATCH 26/74] lto, sound: Fix export symbols for !CONFIG_MODULES
Date: Sat, 18 Aug 2012 19:56:22 -0700
Message-Id: <1345345030-22211-27-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The new LTO EXPORT_SYMBOL references symbols even without CONFIG_MODULES.
Since these functions are macros in this case this doesn't work.
Add a ifdef to fix the build.

Cc: tiwai@suse.de
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 sound/core/seq/seq_device.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/core/seq/seq_device.c b/sound/core/seq/seq_device.c
index 5cf8d65..60e8fc1 100644
--- a/sound/core/seq/seq_device.c
+++ b/sound/core/seq/seq_device.c
@@ -569,5 +569,7 @@ EXPORT_SYMBOL(snd_seq_device_load_drivers);
 EXPORT_SYMBOL(snd_seq_device_new);
 EXPORT_SYMBOL(snd_seq_device_register_driver);
 EXPORT_SYMBOL(snd_seq_device_unregister_driver);
+#ifdef CONFIG_MODULES
 EXPORT_SYMBOL(snd_seq_autoload_lock);
 EXPORT_SYMBOL(snd_seq_autoload_unlock);
+#endif
-- 
1.7.7.6

