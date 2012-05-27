Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab2E0BXO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:23:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422814Ab2E0BU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:20:28 -0400
Message-Id: <20120527002524.631696340@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:26:28 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ming Lei <ming.lei@canonical.com>,
        Venkatraman S <svenkatr@ti.com>, Chris Ball <cjb@laptop.org>
Subject: [ 82/91] mmc: omap_hsmmc: pass IRQF_ONESHOT to request_threaded_irq
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@canonical.com>

commit db35f83ef47b5f180f2670d11f5f93992314ea09 upstream.

The flag of IRQF_ONESHOT should be passed to request_threaded_irq,
otherwise the following failure message should be dumped because
hardware handler is defined as NULL:

[    3.383483] genirq: Threaded irq requested with handler=NULL and
!ONESHOT for irq 368
[    3.392730] omap_hsmmc: probe of omap_hsmmc.0 failed with error -22

The patch fixes one kernel hang bug which is caused by mmc card
probe failure and root device can't be brought up.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
Acked-by: Venkatraman S <svenkatr@ti.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/omap_hsmmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1969,7 +1969,7 @@ static int __devinit omap_hsmmc_probe(st
 		ret = request_threaded_irq(mmc_slot(host).card_detect_irq,
 					   NULL,
 					   omap_hsmmc_detect,
-					   IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+					   IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 					   mmc_hostname(mmc), host);
 		if (ret) {
 			dev_dbg(mmc_dev(host->mmc),


