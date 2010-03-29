Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab0C2GO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 02:14:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60435 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086Ab0C2GNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 02:13:40 -0400
Date: Mon, 29 Mar 2010 16:29:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Daniel Mack <daniel@caiaq.de>, Takashi Iwai <tiwai@suse.de>
Subject: linux-next: build failure after merge of the slabh tree
Message-Id: <20100329162908.c86324d9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

After merging the slabh tree, today's linux-next build (x86_64
allmodconfig) failed like this:

sound/usb/format.c: In function 'parse_audio_format_rates_v1':
sound/usb/format.c:163: error: implicit declaration of function 'kmalloc'
sound/usb/format.c:163: warning: assignment makes pointer from integer without a cast
sound/usb/format.c: In function 'parse_audio_format_rates_v2':
sound/usb/format.c:231: error: implicit declaration of function 'kzalloc'
sound/usb/format.c:231: warning: assignment makes pointer from integer without a cast
sound/usb/format.c:249: warning: assignment makes pointer from integer without a cast
sound/usb/format.c:271: error: implicit declaration of function 'kfree'

Caused by commit d103d3b3e8512312b5254950035366d4422a479a ("percpu: don't
implicitly include slab.h from percpu.h") from the slabh tree interacting
with commit e5779998bf8b70e48a6cc208c8b61b33bd6117ea ("ALSA: usb-audio:
refactor code") from the sound tree.

I applied the following merge fixup patch which should be applied to the
sound tree (see Documentation/SubmitChecklist Rule #1 :-)).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 29 Mar 2010 16:23:34 +1100
Subject: [PATCH] sound: usb format: use of kmalloc/kzalloc/kfree requires the include of slab.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 sound/usb/format.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/usb/format.c b/sound/usb/format.c
index fcadedd..b87cf87 100644
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -16,6 +16,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/usb/audio.h>
 #include <linux/usb/audio-v2.h>
-- 
1.7.0.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
