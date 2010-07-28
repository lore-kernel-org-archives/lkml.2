Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab0G1I6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 04:58:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38629 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab0G1I6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 04:58:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=teqjuRs6lPqi371hrGQzTp4vbWs2qeK9/p6TYYV2EIwFgO7fVONmHkm/cWt/liHn49
         yQem/htcrYxnEsqqjpR50gOKmpJ7zzryC4IjYXWqrBARf/JK7D+sP3n3M3zU8zLJxDdi
         dcyWxFP7sCg5ZZm8FTe0dum/Xl1TRrJWcMa2o=
Subject: [PATCH] hpimsgx: fix wrong sizeof
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Eliot Blennerhassett <eblennerhassett@audioscience.com>
Content-Type: text/plain
Date: Wed, 28 Jul 2010 16:58:42 +0800
Message-Id: <1280307522.28099.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The correct size should be sizeof(gRESP_HPI_SUBSYS_FIND_ADAPTERS),
sizeof(&gRESP_HPI_SUBSYS_FIND_ADAPTERS) is incorrect.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/pci/asihpi/hpimsgx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/asihpi/hpimsgx.c b/sound/pci/asihpi/hpimsgx.c
index 2ee90dc..f01ab96 100644
--- a/sound/pci/asihpi/hpimsgx.c
+++ b/sound/pci/asihpi/hpimsgx.c
@@ -741,7 +741,7 @@ static void HPIMSGX__reset(u16 adapter_index)
 		hpi_init_response(&hr, HPI_OBJ_SUBSYSTEM,
 			HPI_SUBSYS_FIND_ADAPTERS, 0);
 		memcpy(&gRESP_HPI_SUBSYS_FIND_ADAPTERS, &hr,
-			sizeof(&gRESP_HPI_SUBSYS_FIND_ADAPTERS));
+			sizeof(gRESP_HPI_SUBSYS_FIND_ADAPTERS));
 
 		for (adapter = 0; adapter < HPI_MAX_ADAPTERS; adapter++) {
 
-- 
1.5.4.3



