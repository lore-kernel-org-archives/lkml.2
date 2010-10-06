Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410Ab0JFWkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 18:40:13 -0400
Received: from smtp.outflux.net ([198.145.64.163]:54801 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758185Ab0JFWkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 18:40:12 -0400
Date: Wed, 6 Oct 2010 15:39:41 -0700
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Stefan Ringel <stefan.ringel@arcor.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] staging: fix possible use-before-NULL-check crash
Message-ID: <20101006223941.GW14666@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found via http://coccinelle.lip6.fr/rules/mini_null_ref.cocci

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 drivers/staging/tm6000/tm6000-alsa.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index 087137d..c1aff0e 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -426,10 +426,11 @@ error:
 
 static int tm6000_audio_fini(struct tm6000_core *dev)
 {
-	struct snd_tm6000_card	*chip = dev->adev;
+	struct snd_tm6000_card	*chip;
 
 	if (!dev)
 		return 0;
+	chip = dev->adev;
 
 	if (!chip)
 		return 0;
-- 
1.7.1


-- 
Kees Cook
Ubuntu Security Team
