Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab0LHBCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:02:17 -0500
Received: from kroah.org ([198.145.64.141]:49140 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757365Ab0LHBCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:06 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:37 2010
Message-Id: <20101208005737.738088870@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [163/289] ALSA: hda - Use ALC_INIT_DEFAULT for really default initialization
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1438,6 +1438,7 @@ do_sku:
 		spec->init_amp = ALC_INIT_GPIO3;
 		break;
 	case 5:
+	default:
 		spec->init_amp = ALC_INIT_DEFAULT;
 		break;
 	}


