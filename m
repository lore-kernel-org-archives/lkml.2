Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab1LERng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:43:36 -0500
Received: from www17.your-server.de ([213.133.104.17]:50757 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab1LERnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:43:35 -0500
Subject: [PATCH] ALSA: ctxf: Use kcalloc instead of kzalloc to allocate
 array
From: Thomas Meyer <thomas@m3y3r.de>
To: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.351.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/sound/pci/ctxfi/ctsrc.c b/sound/pci/ctxfi/ctsrc.c
--- a/sound/pci/ctxfi/ctsrc.c 2011-11-13 11:08:15.090921741 +0100
+++ b/sound/pci/ctxfi/ctsrc.c 2011-11-28 20:14:46.651112893 +0100
@@ -437,7 +437,7 @@ get_src_rsc(struct src_mgr *mgr, const s
 
 	/* Allocate mem for master src resource */
 	if (MEMRD == desc->mode)
-		src = kzalloc(sizeof(*src)*desc->multi, GFP_KERNEL);
+		src = kcalloc(desc->multi, sizeof(*src), GFP_KERNEL);
 	else
 		src = kzalloc(sizeof(*src), GFP_KERNEL);
 
