Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab2HOU11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:27:27 -0400
Received: from mail.windriver.com ([147.11.1.11]:36717 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520Ab2HOTuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:06 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 053/165] ALSA: hda/realtek - Avoid bogus HP-pin assignment
Date: Wed, 15 Aug 2012 15:46:37 -0400
Message-ID: <1345060109-9187-54-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 5fe6e0151dbd969f5fbcd94d05c968b76d76952b upstream.

When the headphone pin is assigned as primary output to line_out_pins[],
the automatic HP-pin assignment by ASSID must be suppressed.  Otherwise
a wrong pin might be assigned to the headphone and breaks the auto-mute.

Reference: https://bugzilla.novell.com/show_bug.cgi?id=716104

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/hda/patch_realtek.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index d388680..2c71de1 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1336,7 +1336,9 @@ do_sku:
 	 * 15   : 1 --> enable the function "Mute internal speaker
 	 *	        when the external headphone out jack is plugged"
 	 */
-	if (!spec->autocfg.hp_pins[0]) {
+	if (!spec->autocfg.hp_pins[0] &&
+	    !(spec->autocfg.line_out_pins[0] &&
+	      spec->autocfg.line_out_type == AUTO_PIN_HP_OUT)) {
 		hda_nid_t nid;
 		tmp = (ass >> 11) & 0x3;	/* HP to chassis */
 		if (tmp == 0)
-- 
1.7.12.rc2

