Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761824Ab0HFS2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:28:21 -0400
Received: from kroah.org ([198.145.64.141]:36022 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761783Ab0HFS2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:28:18 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 10:56:11 2010
Message-Id: <20100806175611.638902395@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 10:54:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        James Bottomley <James.Bottomley@suse.de>
Subject: [3/4] SCSI: enclosure: fix error path - actually return ERR_PTR() on error
In-Reply-To: <20100806182735.GA15732@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: James Bottomley <James.Bottomley@suse.de>

commit a91c1be21704113b023919826c6d531da46656ef upstream.

we also need to clean up and free the cdev.

Reported-by: Jani Nikula <ext-jani.1.nikula@nokia.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/enclosure.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -264,8 +264,11 @@ enclosure_component_register(struct encl
 	cdev->groups = enclosure_groups;
 
 	err = device_register(cdev);
-	if (err)
-		ERR_PTR(err);
+	if (err) {
+		ecomp->number = -1;
+		put_device(cdev);
+		return ERR_PTR(err);
+	}
 
 	return ecomp;
 }


