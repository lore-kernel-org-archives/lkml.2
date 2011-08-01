Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1HAX0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:26:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38584 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab1HAX0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:26:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:55 2011
Message-Id: <20110801232055.143454451@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:19:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: [45/70] si4713-i2c: avoid potential buffer overflow on si4713
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mauro Carvalho Chehab <mchehab@redhat.com>

commit dc6b845044ccb7e9e6f3b7e71bd179b3cf0223b6 upstream.

While compiling it with Fedora 15, I noticed this issue:

  inlined from ‘si4713_write_econtrol_string’ at drivers/media/radio/si4713-i2c.c:1065:24:
  arch/x86/include/asm/uaccess_32.h:211:26: error: call to ‘copy_from_user_overflow’ declared with attribute error: copy_from_user() buffer size is not provably correct

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Acked-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Acked-by: Eduardo Valentin <edubezval@gmail.com>
Reviewed-by: Eugene Teo <eugeneteo@kernel.sg>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/radio/si4713-i2c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/radio/si4713-i2c.c
+++ b/drivers/media/radio/si4713-i2c.c
@@ -1033,7 +1033,7 @@ static int si4713_write_econtrol_string(
 		char ps_name[MAX_RDS_PS_NAME + 1];
 
 		len = control->size - 1;
-		if (len > MAX_RDS_PS_NAME) {
+		if (len < 0 || len > MAX_RDS_PS_NAME) {
 			rval = -ERANGE;
 			goto exit;
 		}
@@ -1057,7 +1057,7 @@ static int si4713_write_econtrol_string(
 		char radio_text[MAX_RDS_RADIO_TEXT + 1];
 
 		len = control->size - 1;
-		if (len > MAX_RDS_RADIO_TEXT) {
+		if (len < 0 || len > MAX_RDS_RADIO_TEXT) {
 			rval = -ERANGE;
 			goto exit;
 		}


