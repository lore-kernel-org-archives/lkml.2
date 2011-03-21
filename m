Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab1CUXPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:15:21 -0400
Received: from kroah.org ([198.145.64.141]:49277 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233Ab1CUXPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:13 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:10 2011
Message-Id: <20110321230710.722935436@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Indan Zupancic <indan@nul.nu>, Keith Packard <keithp@keithp.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wilson <chris@chris-wilson.co.uk>, Takashi Iwai <tiwai@suse.de>
Subject: [15/87] drm/i915: Fix calculation of backlight value in combined mode
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ba3820ade317ee36e496b9b40d2ec3987dd4aef0 upstream.

[The upstream commit above is a combination of revert + one-liner fix.
 This patch contains only the latter that is needed for 2.6.37.x.]

This patch fixes the backlight level calculation for combination mode
used in some models like GM45.  It's due to a wrong bit shift
introduced by the commit a95735569312f2ab0c80425e2cd1e5cb0b4e1870
    drm/i915: Refactor panel backlight controls

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=23472
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=34524
Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=672946

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/gpu/drm/i915/intel_panel.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -176,7 +176,6 @@ u32 intel_panel_get_backlight(struct drm
 			val &= ~1;
 			pci_read_config_byte(dev->pdev, PCI_LBPC, &lbpc);
 			val *= lbpc;
-			val >>= 1;
 		}
 	}
 


