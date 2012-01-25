Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab2AYNEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 08:04:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963Ab2AYNEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 08:04:04 -0500
Message-ID: <4F1FFD97.1080204@redhat.com>
Date: Wed, 25 Jan 2012 14:03:19 +0100
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: [PATCH] cciss: add Smart Array 5i to the kdump blacklist
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sent this originally to scsi list - resending.


The '5i' controller freezes when a kdump is attempted.
This patch admits it and adds the controller
to the unresetable list.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>

---
 drivers/block/cciss.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 8f4ef65..b43ed87 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -576,12 +576,14 @@ static u32 unresettable_controller[] = {
 	0x3215103C, /* Smart Array E200i */
 	0x3237103C, /* Smart Array E500 */
 	0x323D103C, /* Smart Array P700m */
+	0x40800E11, /* Smart Array 5i */
 	0x409C0E11, /* Smart Array 6400 */
 	0x409D0E11, /* Smart Array 6400 EM */
 };
 
 /* List of controllers which cannot even be soft reset */
 static u32 soft_unresettable_controller[] = {
+	0x40800E11, /* Smart Array 5i */
 	0x409C0E11, /* Smart Array 6400 */
 	0x409D0E11, /* Smart Array 6400 EM */
 };
-- 1.7.6.4 -- To unsubscribe from this list: send the line "unsubscribe
linux-scsi" in the body of a message to majordomo@vger.kernel.org More
majordomo info at http://vger.kernel.org/majordomo-info.html



