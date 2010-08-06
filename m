Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761906Ab0HFSfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:35:34 -0400
Received: from kroah.org ([198.145.64.141]:48570 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761847Ab0HFSf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:35:26 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:32:00 2010
Message-Id: <20100806183200.680677691@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:30:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [07/38] amd64_edac: Fix operator precendence error
In-Reply-To: <20100806183250.GA23019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Borislav Petkov <borislav.petkov@amd.com>

commit 962b70a1eb22c467b95756a290c694e73da17f41 upstream.

The bitwise AND is of higher precedence, make that explicit.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/edac/amd64_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1679,7 +1679,7 @@ static void f10_map_sysaddr_to_csrow(str
 	 * ganged. Otherwise @chan should already contain the channel at
 	 * this point.
 	 */
-	if (dct_ganging_enabled(pvt) && pvt->nbcfg & K8_NBCFG_CHIPKILL)
+	if (dct_ganging_enabled(pvt) && (pvt->nbcfg & K8_NBCFG_CHIPKILL))
 		chan = get_channel_from_ecc_syndrome(mci, syndrome);
 
 	if (chan >= 0)


