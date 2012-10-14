Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab2JNOln (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:41:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46047 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753795Ab2JNOlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:41:35 -0400
Message-Id: <20121014143535.933829933@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:35:49 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Matthieu CASTET <matthieu.castet@parrot.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [ 016/147] UBI: erase free PEB with bitflip in EC header
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu CASTET <matthieu.castet@parrot.com>

commit 193819cf2e6e395b1e1be2d36785dc5563a6edca upstream.

Without this patch, these PEB are not scrubbed until we put data in them.
Bitflip can accumulate latter and we can loose the EC header (but VID header
should be intact and allow to recover data).

Signed-off-by: Matthieu Castet <matthieu.castet@parrot.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
[bwh: Backported to 3.2: adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mtd/ubi/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/ubi/scan.c
+++ b/drivers/mtd/ubi/scan.c
@@ -997,7 +997,7 @@ static int process_eb(struct ubi_device
 			return err;
 		goto adjust_mean_ec;
 	case UBI_IO_FF:
-		if (ec_err)
+		if (ec_err || bitflips)
 			err = add_to_list(si, pnum, ec, 1, &si->erase);
 		else
 			err = add_to_list(si, pnum, ec, 0, &si->free);


