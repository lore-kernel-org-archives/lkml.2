Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab2KGTk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 14:40:56 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:60476 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab2KGTky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 14:40:54 -0500
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsW3AAW5mlBV5h1yPGdsb2JhbABEilK4GgEBexkBAQEBHxkNJ4IeAQEEATocEwEPBQsIAw4DAwECLxQlCgwOE4gECrxoFIt5gUWBLoJzYQOVeoV7jTo
X-IronPort-AV: E=Sophos;i="4.80,732,1344204000"; 
   d="scan'208";a="225690663"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 7 Nov 2012 20:46:17 +0100
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] input: fix input-mt kernel-doc warning
Message-ID: <20121107194617.GA3738@polaris.bitmath.org>
References: <5099B45E.8080105@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5099B45E.8080105@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix new kernel-doc warning in input-mt.c:
> 
> Warning(drivers/input/input-mt.c:38): No description found for parameter 'flags'

Thanks for the patch. It seemed reasonable to expand the function
documentation a bit as well, hope you are alright with the patch
below, Dmitry, care to pick this up for 3.7? Otherwise I can carry it
for 3.8.

Thanks,
Henrik

---

>From a96b3a67eefba05d7e6de3afa1b51d17728d45d3 Mon Sep 17 00:00:00 2001
From: Henrik Rydberg <rydberg@euromail.se>
Date: Wed, 7 Nov 2012 20:40:24 +0100
Subject: [PATCH] Input: MT - Document undocumented init argument

Fixes new kernel-doc warning in input-mt.c:

Warning(drivers/input/input-mt.c:38): No description found for parameter 'flags'

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/input-mt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
index c0ec7d4..1abbc17 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -26,10 +26,14 @@ static void copy_abs(struct input_dev *dev, unsigned int dst, unsigned int src)
  * input_mt_init_slots() - initialize MT input slots
  * @dev: input device supporting MT events and finger tracking
  * @num_slots: number of slots used by the device
+ * @flags: mt tasks to handle in core
  *
  * This function allocates all necessary memory for MT slot handling
  * in the input device, prepares the ABS_MT_SLOT and
  * ABS_MT_TRACKING_ID events for use and sets up appropriate buffers.
+ * Depending on the flags set, it also performs pointer emulation and
+ * frame synchronization.
+ *
  * May be called repeatedly. Returns -EINVAL if attempting to
  * reinitialize with a different number of slots.
  */
-- 
1.8.0

