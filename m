Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab2JGXV7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:21:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38126 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752686Ab2JGXVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:21:52 -0400
Message-Id: <20121007225836.666663351@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:58:48 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Toshi Kani <toshi.kani@hp.com>, Lisa Mitchell <lisa.mitchell@hp.com>,
        Thomas Mingarelli <Thomas.Mingarelli@hp.com>,
        Wim Van Sebroeck <wim@iguana.be>
Subject: [ 014/108] hpwdt: Fix kdump issue in hpwdt
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toshi Kani <toshi.kani@hp.com>

commit 308b135e4fcc00c80c07e0e04e7afa8edf78583c upstream.

kdump can be interrupted by watchdog timer when the timer is left
activated on the crash kernel. Changed the hpwdt driver to disable
watchdog timer at boot-time. This assures that watchdog timer is
disabled until /dev/watchdog is opened, and prevents watchdog timer
to be left running on the crash kernel.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Tested-by: Lisa Mitchell <lisa.mitchell@hp.com>
Signed-off-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/watchdog/hpwdt.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 1eff743..ae60406 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -814,6 +814,9 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev,
 	hpwdt_timer_reg = pci_mem_addr + 0x70;
 	hpwdt_timer_con = pci_mem_addr + 0x72;
 
+	/* Make sure that timer is disabled until /dev/watchdog is opened */
+	hpwdt_stop();
+
 	/* Make sure that we have a valid soft_margin */
 	if (hpwdt_change_timer(soft_margin))
 		hpwdt_change_timer(DEFAULT_MARGIN);


