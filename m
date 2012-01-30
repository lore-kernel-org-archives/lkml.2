Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab2A3Sov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 13:44:51 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:52376 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751794Ab2A3Sot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 13:44:49 -0500
Message-ID: <4F26F2BB.6070701@xenotime.net>
Date: Mon, 30 Jan 2012 11:42:51 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] sound: fix include/sound/core.h warning
References: <20120130144102.8d202c7d8eccd503a86b3053@canb.auug.org.au>
In-Reply-To: <20120130144102.8d202c7d8eccd503a86b3053@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build warning by providing a struct stub since no fields of
the struct are used:

include/sound/core.h:454:56: warning: 'struct pci_dev' declared inside parameter list

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Jaroslav Kysela <perex@perex.cz>
Cc:	Takashi Iwai <tiwai@suse.de>
Cc:	alsa-devel@alsa-project.org
---
 include/sound/core.h |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20120130.orig/include/sound/core.h
+++ linux-next-20120130/include/sound/core.h
@@ -450,6 +450,8 @@ struct snd_pci_quirk {
 	{_SND_PCI_QUIRK_ID_MASK(vend, 0, 0), .value = (val)}
 #endif
 
+struct pci_dev;
+
 const struct snd_pci_quirk *
 snd_pci_quirk_lookup(struct pci_dev *pci, const struct snd_pci_quirk *list);
 
