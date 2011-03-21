Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab1CUXQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:16:18 -0400
Received: from kroah.org ([198.145.64.141]:49556 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503Ab1CUXQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:16:01 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:15 2011
Message-Id: <20110321230715.610365623@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:07:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <drosenberg@vsecurity.com>, Takashi Iwai <tiwai@suse.de>
Subject: [62/87] ALSA: sound/pci/asihpi: check adapter index in hpi_ioctl
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit 4a122c10fbfe9020df469f0f669da129c5757671 upstream.

The user-supplied index into the adapters array needs to be checked, or
an out-of-bounds kernel pointer could be accessed and used, leading to
potentially exploitable memory corruption.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/asihpi/hpioctl.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/pci/asihpi/hpioctl.c
+++ b/sound/pci/asihpi/hpioctl.c
@@ -155,6 +155,11 @@ long asihpi_hpi_ioctl(struct file *file,
 		goto out;
 	}
 
+	if (hm->h.adapter_index >= HPI_MAX_ADAPTERS) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	pa = &adapters[hm->h.adapter_index];
 	hr->h.size = 0;
 	if (hm->h.object == HPI_OBJ_SUBSYSTEM) {


