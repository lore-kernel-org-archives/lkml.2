Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1769007Ab2K3TRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:17:12 -0500
Received: from mail.kernel.org ([198.145.19.201]:59334 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992893Ab2K3TB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:01:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 14/54] ALSA: hda - Cirrus: Correctly clear line_out_pins when moving to speaker
Date: Fri, 30 Nov 2012 10:55:45 -0800
Message-Id: <20121130185209.330503168@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185207.894301294@linuxfoundation.org>
References: <20121130185207.894301294@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 34c3d1926bdaf45d3a891dd577482abcdd9faa34 upstream.

If this array is not cleared, the jack related code later might
fail to create "Internal Speaker Phantom Jack" on Dell Inspiron 3420 and
Dell Vostro 2420.

BugLink: https://bugs.launchpad.net/bugs/1076840
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_cirrus.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -461,6 +461,7 @@ static int parse_output(struct hda_codec
 		memcpy(cfg->speaker_pins, cfg->line_out_pins,
 		       sizeof(cfg->speaker_pins));
 		cfg->line_outs = 0;
+		memset(cfg->line_out_pins, 0, sizeof(cfg->line_out_pins));
 	}
 
 	return 0;


