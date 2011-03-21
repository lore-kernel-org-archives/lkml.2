Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab1CUXOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:14:06 -0400
Received: from kroah.org ([198.145.64.141]:49057 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064Ab1CUXN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:13:56 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:10:53 2011
Message-Id: <20110321231053.282744395@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:10:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Przemyslaw Bruski <pbruskispam@op.pl>, Takashi Iwai <tiwai@suse.de>
Subject: [25/44] ALSA: ctxfi - Fix incorrect SPDIF status bit mask
In-Reply-To: <20110321231105.GA1744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -868,7 +868,7 @@ spdif_passthru_playback_setup(struct ct_
 	mutex_lock(&atc->atc_mutex);
 	dao->ops->get_spos(dao, &status);
 	if (((status >> 24) & IEC958_AES3_CON_FS) != iec958_con_fs) {
-		status &= ((~IEC958_AES3_CON_FS) << 24);
+		status &= ~(IEC958_AES3_CON_FS << 24);
 		status |= (iec958_con_fs << 24);
 		dao->ops->set_spos(dao, status);
 		dao->ops->commit_write(dao);


