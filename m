Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab0KMS56 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 13:57:58 -0500
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:50103 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756060Ab0KMS5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 13:57:55 -0500
Date: Sat, 13 Nov 2010 19:46:50 +0100
From: Nicolas Kaiser <nikai@nikai.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging: comedi: fix memory leak
Message-ID: <20101113194650.28a0be1b@absol.kitzblitz>
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

Instead of freeing outBuffer, inBuffer gets freed twice.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
Only compile tested. I hope I got it right?

 drivers/staging/comedi/drivers/usbdux.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index aca4d14..696ee04 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -2295,8 +2295,8 @@ static void tidy_up(struct usbduxsub *usbduxsub_tmp)
 	usbduxsub_tmp->inBuffer = NULL;
 	kfree(usbduxsub_tmp->insnBuffer);
 	usbduxsub_tmp->insnBuffer = NULL;
-	kfree(usbduxsub_tmp->inBuffer);
-	usbduxsub_tmp->inBuffer = NULL;
+	kfree(usbduxsub_tmp->outBuffer);
+	usbduxsub_tmp->outBuffer = NULL;
 	kfree(usbduxsub_tmp->dac_commands);
 	usbduxsub_tmp->dac_commands = NULL;
 	kfree(usbduxsub_tmp->dux_commands);
-- 
1.7.2.2
