Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab0C2IBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 04:01:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34547 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631Ab0C2IBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 04:01:51 -0400
Date: Mon, 29 Mar 2010 19:01:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Daniel Mack <daniel@caiaq.de>
Subject: Re: linux-next: build failure after merge of the slabh tree
Message-Id: <20100329190148.2a0849b8.sfr@canb.auug.org.au>
In-Reply-To: <20100329173852.3550bbea.sfr@canb.auug.org.au>
References: <20100329160250.1515a2ca.sfr@canb.auug.org.au>
	<s5hy6hb4p6u.wl%tiwai@suse.de>
	<20100329173852.3550bbea.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

On Mon, 29 Mar 2010 17:38:52 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> On Mon, 29 Mar 2010 08:28:09 +0200 Takashi Iwai <tiwai@suse.de> wrote:
> >
> > Thanks, I applied all these oneliners to sound/usb/* as a single
> > patch now.
> 
> Again, thanks.  They were just one liner because I found them one at a
> time :-(

Looks like you missed the one that updated sound/usb/pcm.c ... ah, I
forgot to cc you, sorry.  Here is the patch again:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 29 Mar 2010 16:37:58 +1100
Subject: [PATCH] sound: usb pcm: use of kmalloc requires the include of slab.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 sound/usb/pcm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 630e220..2bf0d77 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -15,6 +15,7 @@
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
