Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab0JEPpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 11:45:15 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:55969 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754558Ab0JEPpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 11:45:13 -0400
Date: Tue, 5 Oct 2010 17:38:12 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Jaroslav Kysela <perex@perex.cz>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sound/usb/usx2y: simplify conditional
Message-ID: <20101005173812.5190495d@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify conditional: (a || (!a && b)) => (a || b)

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 sound/usb/usx2y/usx2yhwdeppcm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/usb/usx2y/usx2yhwdeppcm.c b/sound/usb/usx2y/usx2yhwdeppcm.c
index 2a528e5..3146a81 100644
--- a/sound/usb/usx2y/usx2yhwdeppcm.c
+++ b/sound/usb/usx2y/usx2yhwdeppcm.c
@@ -54,7 +54,7 @@
 #include <linux/gfp.h>
 #include "usbusx2yaudio.c"
 
-#if defined(USX2Y_NRPACKS_VARIABLE) || (!defined(USX2Y_NRPACKS_VARIABLE) &&  USX2Y_NRPACKS == 1)
+#if defined(USX2Y_NRPACKS_VARIABLE) || USX2Y_NRPACKS == 1
 
 #include <sound/hwdep.h>
 
-- 
1.7.2.2
