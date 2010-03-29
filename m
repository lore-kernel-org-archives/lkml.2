Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab0C2GNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 02:13:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60424 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746Ab0C2GNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 02:13:37 -0400
Date: Mon, 29 Mar 2010 16:28:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Daniel Mack <daniel@caiaq.de>, Takashi Iwai <tiwai@suse.de>
Subject: linux-next: build failure after merge of the slabh tree
Message-Id: <20100329162825.a233ce8e.sfr@canb.auug.org.au>
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

sound/usb/quirks.c: In function 'create_fixed_stream_quirk':
sound/usb/quirks.c:136: error: implicit declaration of function 'kmalloc'
sound/usb/quirks.c:136: warning: assignment makes pointer from integer without a cast
sound/usb/quirks.c:138: error: implicit declaration of function 'kfree'
sound/usb/quirks.c: In function 'create_uaxx_quirk':
sound/usb/quirks.c:223: warning: assignment makes pointer from integer without a cast

Caused by commit d103d3b3e8512312b5254950035366d4422a479a ("percpu: don't
implicitly include slab.h from percpu.h") from the slabh tree interacting
with commit e5779998bf8b70e48a6cc208c8b61b33bd6117ea ("ALSA: usb-audio:
refactor code") from the sound tree.

I applied the following merge fixup patch which should be applied to the
sound tree (see Documentation/SubmitChecklist Rule #1 :-)).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 29 Mar 2010 16:08:03 +1100
Subject: [PATCH] sound: quirks: use of kmalloc/kfree requires the include of slab.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 sound/usb/quirks.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index d4ced64..136e5b4 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/usb/audio.h>
 
-- 
1.7.0.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
