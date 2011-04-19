Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab1DSVyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:54:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58004 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab1DSVyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:54:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qLZeNLcI3dcD5dUjnSfcT+KurnDr3ABIjF2BKLL+L+WPCksxfbq5yHesF1UA8CaUeQ
         uZO2vtJrmJDc7jMmtgXHApdAeUdIML4kwKftWyujdYNI4LKQnh96vqCllExkJg8RXLo/
         3KBmXcjQkmuP3J3IyisEs2ZAsaVQd1msZGYK8=
Date: Tue, 19 Apr 2011 23:52:42 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Ben Skeggs <bskeggs@redhat.com>
Cc: Kyle Spaans <kspaans@uwaterloo.ca>, linux-kernel@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>, airlied@redhat.com,
        dri-devel@lists.freedesktop.org, mjg@redhat.com,
        maciej.rutecki@gmail.com, nouveau@lists.freedesktop.org,
        Nigel Cunningham <lkml@nigelcunningham.com.au>,
        Nick Piggin <npiggin@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/2] drm/nouveau: fix allocation of notifier object
Message-ID: <20110419215242.GC2965@joi.lan>
References: <20110415061136.GA21979@isilmar-3.linta.de>
 <4DAA1453.5000604@nigelcunningham.com.au>
 <20110416235028.GA6096@taurine.csclub.uwaterloo.ca>
 <20110417151204.GA24519@taurine.csclub.uwaterloo.ca>
 <20110417154557.GA2871@joi.lan>
 <20110417162427.GB25242@taurine.csclub.uwaterloo.ca>
 <20110417164920.GA2626@joi.lan>
 <20110418200204.GA2522@joi.lan>
 <BANLkTi=Oo03CQchHYh4EvEsk+wZy7akLNw@mail.gmail.com>
 <20110419214747.GA2965@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110419214747.GA2965@joi.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 73412c3854c877e5f37ad944ee8977addde4d35a ("drm/nouveau: allocate
kernel's notifier object at end of block") intended to align end of
notifier block to page boundary, but start of block was miscalculated
to be off by -16 bytes. Fix it.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
---
 drivers/gpu/drm/nouveau/nouveau_dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_dma.c b/drivers/gpu/drm/nouveau/nouveau_dma.c
index ce38e97..568caed 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dma.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dma.c
@@ -83,7 +83,7 @@ nouveau_dma_init(struct nouveau_channel *chan)
 		return ret;
 
 	/* NV_MEMORY_TO_MEMORY_FORMAT requires a notifier object */
-	ret = nouveau_notifier_alloc(chan, NvNotify0, 32, 0xfd0, 0x1000,
+	ret = nouveau_notifier_alloc(chan, NvNotify0, 32, 0xfe0, 0x1000,
 				     &chan->m2mf_ntfy);
 	if (ret)
 		return ret;
-- 
1.7.4.1

