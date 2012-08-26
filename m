Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab2HZVnD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 17:43:03 -0400
Received: from toccata.ens-lyon.fr ([140.77.166.68]:56899 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab2HZVnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 17:43:01 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Aug 2012 17:43:01 EDT
Date: Sun, 26 Aug 2012 23:35:17 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, speakup@braille.uwo.ca
Subject: [PATCH,STAGING] speakup: lower default software speech rate
Message-ID: <20120826213517.GT23559@type.wlan.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, speakup@braille.uwo.ca
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Speech synthesis beginners need a low speech rate, and trained people
want a high speech rate.  A medium speech rate is thus actually not a
good default for neither.  Since trained people will typically know how
to change the rate, better default for a low speech rate, which
beginners can grasp and learn how to increase it afterwards

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
---

This was agreed with users on the speakup mailing list.

diff --git a/drivers/staging/speakup/speakup_soft.c b/drivers/staging/speakup/speakup_soft.c
index 42cdafe..2a67610 100644
--- a/drivers/staging/speakup/speakup_soft.c
+++ b/drivers/staging/speakup/speakup_soft.c
@@ -46,7 +46,7 @@ static int misc_registered;
 static struct var_t vars[] = {
 	{ CAPS_START, .u.s = {"\x01+3p" } },
 	{ CAPS_STOP, .u.s = {"\x01-3p" } },
-	{ RATE, .u.n = {"\x01%ds", 5, 0, 9, 0, 0, NULL } },
+	{ RATE, .u.n = {"\x01%ds", 2, 0, 9, 0, 0, NULL } },
 	{ PITCH, .u.n = {"\x01%dp", 5, 0, 9, 0, 0, NULL } },
 	{ VOL, .u.n = {"\x01%dv", 5, 0, 9, 0, 0, NULL } },
 	{ TONE, .u.n = {"\x01%dx", 1, 0, 2, 0, 0, NULL } },
