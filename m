Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032544Ab2I1U1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:27:15 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43081 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032535Ab2I1U1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:27:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Toshi Kani <toshi.kani@hp.com>, Lisa Mitchell <lisa.mitchell@hp.com>,
        Thomas Mingarelli <Thomas.Mingarelli@hp.com>,
        Wim Van Sebroeck <wim@iguana.be>
Subject: [ 103/218] hpwdt: Fix kdump issue in hpwdt
Date: Fri, 28 Sep 2012 13:15:20 -0700
Message-Id: <20120928201513.387355050@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/watchdog/hpwdt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -806,6 +806,9 @@ static int __devinit hpwdt_init_one(stru
 	hpwdt_timer_reg = pci_mem_addr + 0x70;
 	hpwdt_timer_con = pci_mem_addr + 0x72;
 
+	/* Make sure that timer is disabled until /dev/watchdog is opened */
+	hpwdt_stop();
+
 	/* Make sure that we have a valid soft_margin */
 	if (hpwdt_change_timer(soft_margin))
 		hpwdt_change_timer(DEFAULT_MARGIN);


