Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965439Ab2I1Thg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:37:36 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47421 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965316Ab2I1TAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:00:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Toshi Kani <toshi.kani@hp.com>, Lisa Mitchell <lisa.mitchell@hp.com>,
        Thomas Mingarelli <Thomas.Mingarelli@hp.com>,
        Wim Van Sebroeck <wim@iguana.be>
Subject: [ 130/262] hpwdt: Fix kdump issue in hpwdt
Date: Fri, 28 Sep 2012 11:50:59 -0700
Message-Id: <20120928183013.375493433@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -814,6 +814,9 @@ static int __devinit hpwdt_init_one(stru
 	hpwdt_timer_reg = pci_mem_addr + 0x70;
 	hpwdt_timer_con = pci_mem_addr + 0x72;
 
+	/* Make sure that timer is disabled until /dev/watchdog is opened */
+	hpwdt_stop();
+
 	/* Make sure that we have a valid soft_margin */
 	if (hpwdt_change_timer(soft_margin))
 		hpwdt_change_timer(DEFAULT_MARGIN);


