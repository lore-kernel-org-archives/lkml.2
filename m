Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab1CKADG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:03:06 -0500
Received: from kroah.org ([198.145.64.141]:46821 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301Ab1CJX5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:57:15 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Mar 10 15:55:36 2011
Message-Id: <20110310235536.638182601@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 10 Mar 2011 15:54:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [patch 06/29] ALSA: hda - Dont set to D3 in Cirrus errata init verbs
In-Reply-To: <20110310235548.GA10103@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 38c07641905c0db58e800ea974cd9158717c6610 upstream.

The errata init verbs for CS42xx codecs contain the verbs to set
the power-state of SPDIF nodes to D3, which seem to break the SPDIF
output on some MacBooks.  Since this is executed during the power-up
initialization, we shouldn't turn them down there.

Reported-by: Arun Raghavan <arun.raghavan@collabora.co.uk>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_cirrus.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -1039,9 +1039,11 @@ static struct hda_verb cs_errata_init_ve
 	{0x11, AC_VERB_SET_PROC_COEF, 0x0008},
 	{0x11, AC_VERB_SET_PROC_STATE, 0x00},
 
+#if 0 /* Don't to set to D3 as we are in power-up sequence */
 	{0x07, AC_VERB_SET_POWER_STATE, 0x03}, /* S/PDIF Rx: D3 */
 	{0x08, AC_VERB_SET_POWER_STATE, 0x03}, /* S/PDIF Tx: D3 */
 	/*{0x01, AC_VERB_SET_POWER_STATE, 0x03},*/ /* AFG: D3 This is already handled */
+#endif
 
 	{} /* terminator */
 };


