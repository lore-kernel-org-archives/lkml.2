Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab0I2VZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 17:25:29 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37479 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab0I2VZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 17:25:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=vljCUSDCC3IYp7Mq+vJbcYVXyHxr910ZMEfeB4bzCOy9wsfYK0QxTwysx0iPk7EKeJ
         jWp1CnjfVaAlh9hz58TXF83Lzej/A5lrrXVADGWaZb1glXH1du4NpO7EdTQG+qzs/22n
         J4qj8+uF0oMaIK9EGoCf+XEM4TyEyI4OPtvzk=
Message-ID: <4CA3CA3C.4080709@gmail.com>
Date: Thu, 30 Sep 2010 01:22:36 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: David Brownell <dbrownell@users.sourceforge.net>,
        linux-usb@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] USB: Don't dereference snd->filp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't dereference snd->filp.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/usb/gadget/u_audio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

Or should it return the error pointer?

diff --git a/drivers/usb/gadget/u_audio.c b/drivers/usb/gadget/u_audio.c
index 7a86d2c..38d0305 100644
--- a/drivers/usb/gadget/u_audio.c
+++ b/drivers/usb/gadget/u_audio.c
@@ -242,6 +242,7 @@ static int gaudio_open_snd_dev(struct gaudio *card)
 	if (IS_ERR(snd->filp)) {
 		ERROR(card, "No such PCM playback device: %s\n", fn_play);
 		snd->filp = NULL;
+		return 0;
 	}
 	pcm_file = snd->filp->private_data;
 	snd->substream = pcm_file->substream;
