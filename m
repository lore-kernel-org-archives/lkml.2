Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab1CUXSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:18:47 -0400
Received: from kroah.org ([198.145.64.141]:52707 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932330Ab1CUXSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:18:16 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:27 2011
Message-Id: <20110321230327.058308947@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:02:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Przemyslaw Bruski <pbruskispam@op.pl>, Takashi Iwai <tiwai@suse.de>
Subject: [52/78] ALSA: ctxfi - Fix incorrect SPDIF status bit mask
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Przemyslaw Bruski <pbruskispam@op.pl>

commit 4c1847e884efddcc3ede371f7839e5e65b25c34d upstream.

SPDIF status mask creation was incorrect.

Signed-off-by: Przemyslaw Bruski <pbruskispam@op.pl>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/ctxfi/ctatc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/ctxfi/ctatc.c
+++ b/sound/pci/ctxfi/ctatc.c
@@ -869,7 +869,7 @@ spdif_passthru_playback_setup(struct ct_
 	mutex_lock(&atc->atc_mutex);
 	dao->ops->get_spos(dao, &status);
 	if (((status >> 24) & IEC958_AES3_CON_FS) != iec958_con_fs) {
-		status &= ((~IEC958_AES3_CON_FS) << 24);
+		status &= ~(IEC958_AES3_CON_FS << 24);
 		status |= (iec958_con_fs << 24);
 		dao->ops->set_spos(dao, status);
 		dao->ops->commit_write(dao);


