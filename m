Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab0LMAJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:09:27 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36238 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab0LLXrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:00 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: tiwai@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [118/223] ALSA: hda - Use ALC_INIT_DEFAULT for really default initialization
Message-Id: <20101212234659.7ECF5B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:59 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Takashi Iwai <tiwai@suse.de>

commit 5a8cfb4e8ae317d283f84122ed20faa069c5e0c4 upstream.

When SKU assid gives no valid bits for 0x38, the driver didn't take
any action, so far.  This resulted in the missing initialization for
external amps, etc, thus the silent output in the end.

Especially users hit this problem on ALC888 newly since 2.6.35,
where the driver doesn't force to use ALC_INIT_DEFAULT any more.

This patch sets the default initialization scheme to use
ALC_INIT_DEFAULT when no valid bits are set for SKU assid.

Reference:
	https://bugzilla.redhat.com/show_bug.cgi?id=657388

Reported-and-tested-by: Kyle McMartin <kyle@redhat.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/sound/pci/hda/patch_realtek.c
===================================================================
--- linux.orig/sound/pci/hda/patch_realtek.c
+++ linux/sound/pci/hda/patch_realtek.c
@@ -1391,6 +1391,7 @@ do_sku:
 		spec->init_amp = ALC_INIT_GPIO3;
 		break;
 	case 5:
+	default:
 		spec->init_amp = ALC_INIT_DEFAULT;
 		break;
 	}
