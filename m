Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab1H0O7m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:59:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47208 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932119Ab1H0O7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:59:38 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 14:50:56 2011
Message-Id: <20110826215056.294816796@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:49:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Aaron Lu <Aaron.Lu@amd.com>, Chris Ball <cjb@laptop.org>
Subject: [33/35] mmc: sdhci: fix retuning timer wrongly deleted in sdhci_tasklet_finish
In-Reply-To: <20110826215139.GA11498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Aaron Lu <Aaron.Lu@amd.com>

commit 78869618a886d33d8cdfcb78cf9b245b5250e465 upstream.

Currently, the retuning timer for retuning mode 1 will be deleted in
function sdhci_tasklet_finish after a mmc request done, which will make
retuning timing never trigger again. This patch fixed this problem.

Signed-off-by: Aaron Lu <Aaron.Lu@amd.com>
Reviewed-by: Philip Rakity <prakity@marvell.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/sdhci.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1863,9 +1863,6 @@ static void sdhci_tasklet_finish(unsigne
 
 	del_timer(&host->timer);
 
-	if (host->version >= SDHCI_SPEC_300)
-		del_timer(&host->tuning_timer);
-
 	mrq = host->mrq;
 
 	/*


