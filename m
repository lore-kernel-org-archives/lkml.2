Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab0CVPjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 11:39:24 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:47443 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab0CVPjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 11:39:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=P4eZbH6zYBNLLJ59QPMIZlYRTZj0/vyLctB+Yf1GJp5JNZBZZuTSG1S4PqhAQHgtlI
         CZaVPukdhwUx+usQtQRmr/cHTjnhYC8ioPfHet5aYxf8nZYg/78rAOOv3Oxm0BGMLtvQ
         XiCW3IvXX9Gl52aDMfyK47NXe5Cen9onbn5N4=
Date: Mon, 22 Mar 2010 18:39:09 +0300
From: Dan Carpenter <error27@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Srinivasa Deevi <srinivasa.deevi@conexant.com>,
       linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch v2] cx231xx: card->driver "Conexant cx231xx Audio" too long
Message-ID: <20100322153909.GC23411@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20100319114957.GQ5331@bicker> <s5hr5ncxvm9.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hr5ncxvm9.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

card->driver is 15 characters and a NULL, the original code could 
cause a buffer overflow.
 
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
In version 2, I used a better name that Takashi Iwai suggested.

diff --git a/drivers/media/video/cx231xx/cx231xx-audio.c b/drivers/media/video/cx231xx/cx231xx-audio.c
index 7793d60..7cae95a 100644
--- a/drivers/media/video/cx231xx/cx231xx-audio.c
+++ b/drivers/media/video/cx231xx/cx231xx-audio.c
@@ -495,7 +495,7 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 	pcm->info_flags = 0;
 	pcm->private_data = dev;
 	strcpy(pcm->name, "Conexant cx231xx Capture");
-	strcpy(card->driver, "Conexant cx231xx Audio");
+	strcpy(card->driver, "Cx231xx-Audio");
 	strcpy(card->shortname, "Cx231xx Audio");
 	strcpy(card->longname, "Conexant cx231xx Audio");
 
