Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab1CPGjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 02:39:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57182 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab1CPGjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 02:39:35 -0400
Date: Wed, 16 Mar 2011 17:39:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Clemens Ladisch <clemens@ladisch.de>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Jay Fenlason <fenlason@redhat.com>
Subject: linux-next: build failure after merge of the final tree (sound tree
 related)
Message-Id: <20110316173928.6481eda5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

sound/firewire/fcp.c: In function 'fcp_avc_transaction':
sound/firewire/fcp.c:103: error: implicit declaration of function 'msleep'

Caused by commit 31ef9134eb52 ("ALSA: add LaCie FireWire Speakers/Griffin
FireWave Surround driver").  See Rule 1 from
Documentation/SubmitChecklist.

I have added this patch for today:

>From d238d290ba37e4a31929e6d3f6a08c187b537628 Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 16 Mar 2011 17:35:53 +1100
Subject: [PATCH] ALSA: msleep needs delay.h

fixes this error:

sound/firewire/fcp.c: In function 'fcp_avc_transaction':
sound/firewire/fcp.c:103: error: implicit declaration of function 'msleep'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 sound/firewire/fcp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/firewire/fcp.c b/sound/firewire/fcp.c
index c20bd9c..ec578b5 100644
--- a/sound/firewire/fcp.c
+++ b/sound/firewire/fcp.c
@@ -13,6 +13,7 @@
 #include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/wait.h>
+#include <linux/delay.h>
 #include "fcp.h"
 #include "lib.h"
 
-- 
1.7.4.1


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
