Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab2H0TBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 15:01:39 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:46222 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab2H0TBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 15:01:37 -0400
From: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
To: "Kani, Toshimitsu" <toshi.kani@hp.com>, "wim@iguana.be" <wim@iguana.be>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] hpwdt: Fix kdump issue in hpwdt
Thread-Topic: [PATCH] hpwdt: Fix kdump issue in hpwdt
Thread-Index: AQHNhIXkE7PQ9svsVEWLdvcjNA0XY5duAu1g
Date: Mon, 27 Aug 2012 18:59:27 +0000
Message-ID: <9774516974AF5F4C8A2C3C69CD34123323352FF9@G1W3651.americas.hpqcorp.net>
References: <1346093544-12007-1-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1346093544-12007-1-git-send-email-toshi.kani@hp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.193.232.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wim:

I acknowledge and accept this patch.


Thanks,
Tom

-----Original Message-----
From: Kani, Toshimitsu 
Sent: Monday, August 27, 2012 1:52 PM
To: wim@iguana.be; linux-watchdog@vger.kernel.org
Cc: linux-kernel@vger.kernel.org; Mingarelli, Thomas; Kani, Toshimitsu; stable@vger.kernel.org
Subject: [PATCH] hpwdt: Fix kdump issue in hpwdt

kdump can be interrupted by watchdog timer when the timer is left
activated on the crash kernel. Changed the hpwdt driver to disable
watchdog timer at boot-time. This assures that watchdog timer is
disabled until /dev/watchdog is opened, and prevents watchdog timer
to be left running on the crash kernel.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Tested-by: Lisa Mitchell <lisa.mitchell@hp.com>
Cc: stable@vger.kernel.org 
---
 drivers/watchdog/hpwdt.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

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
-- 
1.7.7.6

