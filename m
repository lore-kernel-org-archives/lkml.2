Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab2L1Tnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:43:37 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55265 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754736Ab2L1TST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:19 -0500
Message-Id: <20121228190354.138959026@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:24 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 114/173] regmap: debugfs: Avoid overflows for very small reads
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit db04328c167ff8e7c57f4a3532214aeada3a82fd upstream.

If count is less than the size of a register then we may hit integer
wraparound when trying to move backwards to check if we're still in
the buffer. Instead move the position forwards to check if it's still
in the buffer, we are unlikely to be able to allocate a buffer
sufficiently big to overflow here.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
[bwh: Backported to 3.2: formatted length is tot_len]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/base/regmap/regmap-debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -67,7 +67,7 @@ static ssize_t regmap_map_read_file(stru
 		/* If we're in the region the user is trying to read */
 		if (p >= *ppos) {
 			/* ...but not beyond it */
-			if (buf_pos >= count - 1 - tot_len)
+			if (buf_pos + 1 + tot_len >= count)
 				break;
 
 			/* Format the register */


