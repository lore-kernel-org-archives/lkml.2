Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab1G0Lxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 07:53:40 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:61307 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab1G0Lxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 07:53:37 -0400
Subject: Re: [GIT PATCH] STAGING patches for 3.1
From: Daniel Morsing <daniel.morsing@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
In-Reply-To: <CA+55aFwOgkOXmY654-qbuiFFnUC1yXZ27DBDFR02JP12NxAF9w@mail.gmail.com>
References: <20110726051533.GA2835@kroah.com>
	 <CA+55aFwOgkOXmY654-qbuiFFnUC1yXZ27DBDFR02JP12NxAF9w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jul 2011 13:53:28 +0200
Message-ID: <1311767608.9876.18.camel@morsingpad>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 23:31 -0700, Linus Torvalds wrote:
> 
> So all merged and pushed out. Of course, maybe I made a mistake
> somewhere, but none of it looked at all questionable (famous last
> words ;)
> 
>                    Linus
> 

I came across a double include of linux/interrupt.h in
drivers/staging/brcm80211/brcmsmac/mac80211_if.h from this merge while
trying to teach myself how to effectively use git as a tool for
resolving merges. 

The merge also added an include of linux/interrupt.h in mac80211_if.c
which includes mac80211_if.h, but I left that in, since it explicitly
shows the dependencies of the file.

Anyway, Here's the patch:

---
From: Daniel Morsing <daniel.morsing@gmail.com>

staging: brcm80211: Fix double include introduced by bad merge

A merge with Linus' tree added a double include of linux/interrupt.h.
Fix by removing one of the includes.

Signed-off-by: Daniel Morsing <daniel.morsing@gmail.com>
---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
index 5711e7c..40e3d37 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
@@ -24,8 +24,6 @@
 #define BRCMS_SET_SHORTSLOT_OVERRIDE		146
 
 
-#include <linux/interrupt.h>
-
 /* BMAC Note: High-only driver is no longer working in softirq context
as it needs to block and
  * sleep so perimeter lock has to be a semaphore instead of spinlock.
This requires timers to be
  * submitted to workqueue instead of being on kernel timer





