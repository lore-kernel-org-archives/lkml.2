Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab1BPBpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:45:50 -0500
Received: from kroah.org ([198.145.64.141]:38809 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756829Ab1BPATR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:19:17 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:29 2011
Message-Id: <20110216001429.881006988@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:11:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roel Kluin <roel.kluin@gmail.com>
Subject: [048/272] Staging: speakup: &&/|| confusion in silent_store()
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: roel kluin <roel.kluin@gmail.com>

commit e7bf352fcd85c33b0805da891fc97fea8b5e996e upstream.

Fix test: the branch is always taken.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/speakup/kobjects.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/speakup/kobjects.c
+++ b/drivers/staging/speakup/kobjects.c
@@ -332,7 +332,7 @@ static ssize_t silent_store(struct kobje
 	unsigned long flags;
 
 	len = strlen(buf);
-	if (len > 0 || len < 3) {
+	if (len > 0 && len < 3) {
 		ch = buf[0];
 		if (ch == '\n')
 			ch = '0';


