Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966503Ab2EQD5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 23:57:13 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:12763 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965780Ab2EQD5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 23:57:08 -0400
Message-ID: <4FB4770E.8030301@suse.com>
Date: Wed, 16 May 2012 20:57:02 -0700
From: Lee Duncan <lduncan@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org, kai.makisara@kolumbus.fi, jeffm@suse.com
Subject: [PATCH 5/5] st: raise device limit
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device limit of 128 tape drives was established in 2003 as a
significant increase from the 8 tape drives allowed previously.

We're seeing customer sites that between a large number of drives
and multipath are discovering more than 128 devices and running
into problems.

Now that we're not stuck having to store a pointer in array
and aren't limited by kmalloc failing on higher order allocs we can
lift the limit to fill the entire minor range based on the number
of modes.

Based on the current code, that's 2^17 devices.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/st.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index 4456735..2092f93 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -77,7 +77,7 @@ struct st_modedef {
 #define ST_MODE_SHIFT (7 - ST_NBR_MODE_BITS)
 #define ST_MODE_MASK ((ST_NBR_MODES - 1) << ST_MODE_SHIFT)
 
-#define ST_MAX_TAPES 128
+#define ST_MAX_TAPES (1 << (20 - (ST_NBR_MODE_BITS + 1)))
 #define ST_MAX_TAPE_ENTRIES  (ST_MAX_TAPES << (ST_NBR_MODE_BITS + 1))
 
 /* The status related to each partition */
-- 
1.7.9.2

