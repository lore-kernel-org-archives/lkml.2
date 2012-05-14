Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab2ENNmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:42:35 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43095 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab2ENNmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:42:33 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] tty: Fix LED error return
To: greg@kroah.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Date: Mon, 14 May 2012 14:41:31 +0100
Message-ID: <20120514134105.20268.84451.stgit@bluebook>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

3.4-rc introduced a regression when setting the LEDS. We do the right thing
but then return an error code.

Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=43144
Reported-by: Christian Casteyde
Signed-off-by: Alan Cox <alan@linux/intel.com>
---

 drivers/tty/vt/keyboard.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index 86dd1e3..9f5c462 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -2032,7 +2032,7 @@ int vt_do_kdskled(int console, int cmd, unsigned long arg, int perm)
 		kbd->default_ledflagstate = ((arg >> 4) & 7);
 		set_leds();
                 spin_unlock_irqrestore(&kbd_event_lock, flags);
-		break;
+		return 0;
 
 	/* the ioctls below only set the lights, not the functions */
 	/* for those, see KDGKBLED and KDSKBLED above */

