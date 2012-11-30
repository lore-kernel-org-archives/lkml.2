Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031591Ab2K3StA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:49:00 -0500
Received: from mail.kernel.org ([198.145.19.201]:57304 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031543Ab2K3Ss7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:48:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 01/37] ALSA: pcmcia - Use pcmcia_request_irq()
Date: Fri, 30 Nov 2012 10:45:48 -0800
Message-Id: <20121130183857.362490984@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130183857.166228045@linuxfoundation.org>
References: <20121130183857.166228045@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 08ef79490dad6b88010e94795cf9f89b018ed504 upstream.

The drivers don't require the exclusive irqs.  Let's fix the deprecated
warnings.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pcmcia/pdaudiocf/pdaudiocf.c |    2 +-
 sound/pcmcia/vx/vxpocket.c         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pcmcia/pdaudiocf/pdaudiocf.c
+++ b/sound/pcmcia/pdaudiocf/pdaudiocf.c
@@ -223,7 +223,7 @@ static int pdacf_config(struct pcmcia_de
 	if (ret)
 		goto failed;
 
-	ret = pcmcia_request_exclusive_irq(link, pdacf_interrupt);
+	ret = pcmcia_request_irq(link, pdacf_interrupt);
 	if (ret)
 		goto failed;
 
--- a/sound/pcmcia/vx/vxpocket.c
+++ b/sound/pcmcia/vx/vxpocket.c
@@ -229,7 +229,7 @@ static int vxpocket_config(struct pcmcia
 	if (ret)
 		goto failed;
 
-	ret = pcmcia_request_exclusive_irq(link, snd_vx_irq_handler);
+	ret = pcmcia_request_irq(link, snd_vx_irq_handler);
 	if (ret)
 		goto failed;
 


