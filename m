Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964979Ab1GMG5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 02:57:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37945 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab1GMG5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 02:57:45 -0400
Date: Tue, 12 Jul 2011 23:57:37 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        "Sreedhara Murthy. D.S" <sreedhara.ds@intel.com>,
        linux-input@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] Input: intel-mid-touch - remove pointless checking for
 variable 'found'
Message-ID: <20110713065737.GA4201@core.coreip.homeip.net>
References: <1310454831.16511.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310454831.16511.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 03:13:51PM +0800, Axel Lin wrote:
> The implementation does break from the for loop after we assign i to variable
> 'found'.
> 

Hmm, if we are cleaning this up what about the following?

Thanks.

-- 
Dmitry


Input: intel-mid-touch - remove pointless checking for variable 'found'

From: Axel Lin <axel.lin@gmail.com>

The implementation does break from the for loop after we assign i to variable
'found'.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/touchscreen/intel-mid-touch.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)


diff --git a/drivers/input/touchscreen/intel-mid-touch.c b/drivers/input/touchscreen/intel-mid-touch.c
index 66c96bf..3276952 100644
--- a/drivers/input/touchscreen/intel-mid-touch.c
+++ b/drivers/input/touchscreen/intel-mid-touch.c
@@ -448,15 +448,11 @@ static int __devinit mrstouch_read_pmic_id(uint *vendor, uint *rev)
  */
 static int __devinit mrstouch_chan_parse(struct mrstouch_dev *tsdev)
 {
-	int err, i, found;
+	int found = 0;
+	int err, i;
 	u8 r8;
 
-	found = -1;
-
 	for (i = 0; i < MRSTOUCH_MAX_CHANNELS; i++) {
-		if (found >= 0)
-			break;
-
 		err = intel_scu_ipc_ioread8(PMICADDR0 + i, &r8);
 		if (err)
 			return err;
@@ -466,16 +462,15 @@ static int __devinit mrstouch_chan_parse(struct mrstouch_dev *tsdev)
 			break;
 		}
 	}
-	if (found < 0)
-		return 0;
 
 	if (tsdev->vendor == PMIC_VENDOR_FS) {
-		if (found && found > (MRSTOUCH_MAX_CHANNELS - 18))
+		if (found > MRSTOUCH_MAX_CHANNELS - 18)
 			return -ENOSPC;
 	} else {
-		if (found && found > (MRSTOUCH_MAX_CHANNELS - 4))
+		if (found > MRSTOUCH_MAX_CHANNELS - 4)
 			return -ENOSPC;
 	}
+
 	return found;
 }
 
