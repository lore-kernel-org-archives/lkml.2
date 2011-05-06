Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844Ab1EFAzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:55:46 -0400
Received: from kroah.org ([198.145.64.141]:36775 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755874Ab1EFAYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:50 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:10 2011
Message-Id: <20110506002210.222898782@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Florian Ragwitz <rafl@debian.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: [051/143] Input: elantech - fix firmware version check
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Florian Ragwitz <rafl@debian.org>

commit 225c61aad38b12924b3df5f4ef43150c0d6bae8c upstream.

The check determining whether device should use 4- or 6-byte packets
was trying to compare firmware with 2.48, but was failing on majors
greater than 2. The new check ensures that versions like 4.1 are
checked properly.

Signed-off-by: Florian Ragwitz <rafl@debian.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/input/mouse/elantech.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -665,7 +665,8 @@ int elantech_init(struct psmouse *psmous
 	 * Assume every version greater than this is new EeePC style
 	 * hardware with 6 byte packets
 	 */
-	if (etd->fw_version_maj >= 0x02 && etd->fw_version_min >= 0x30) {
+	if ((etd->fw_version_maj == 0x02 && etd->fw_version_min >= 0x30) ||
+	    etd->fw_version_maj > 0x02) {
 		etd->hw_version = 2;
 		/* For now show extra debug information */
 		etd->debug = 1;


