Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965526Ab2I1TXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:23:33 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47421 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030499Ab2I1TDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:03:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [ 195/262] drm/nvc0/copy: check PUNITS to determine which copy engines are disabled
Date: Fri, 28 Sep 2012 11:52:04 -0700
Message-Id: <20120928183021.096229133@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit 14f0458a41e033dee31ba605137419385c03fc78 upstream.

On some Fermi chipsets (NVCE particularly) PCOPY1 doesn't exist.  And if
what I've seen on Kepler is true of Fermi too, chipsets of the same type
can have different PCOPY units available.

This should fix a v3.5 regression reported by a number of people effecting
suspend/resume on NVC8/NVCE chipsets.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_state.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_state.c
+++ b/drivers/gpu/drm/nouveau/nouveau_state.c
@@ -737,9 +737,11 @@ nouveau_card_init(struct drm_device *dev
 			}
 			break;
 		case NV_C0:
-			nvc0_copy_create(dev, 1);
+			if (!(nv_rd32(dev, 0x022500) & 0x00000200))
+				nvc0_copy_create(dev, 1);
 		case NV_D0:
-			nvc0_copy_create(dev, 0);
+			if (!(nv_rd32(dev, 0x022500) & 0x00000100))
+				nvc0_copy_create(dev, 0);
 			break;
 		default:
 			break;


