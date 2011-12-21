Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab1LUHGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 02:06:50 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52313 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab1LUHGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 02:06:47 -0500
Message-ID: <4EF185AA.2000006@linaro.org>
Date: Wed, 21 Dec 2011 11:07:22 +0400
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: linaro-dev@lists.linaro.org
CC: patches@linaro.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ohci-hcd: ohci-hcd: use usleep_range() instead of mdelay()
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From ac60fe289eef3d81009f2b14a12acbac3e71878b Mon Sep 17 00:00:00 2001
From: Dmitry Antipov <dmitry.antipov@linaro.org>
Date: Wed, 21 Dec 2011 11:05:27 +0400
Subject: [PATCH] ohci-hcd: use usleep_range() instead of mdelay()

---
  drivers/usb/host/ohci-hcd.c |    4 +++-
  1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index b263919..a6d58da 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -574,6 +574,7 @@ static int ohci_run (struct ohci_hcd *ohci)
  	u32			mask, val;
  	int			first = ohci->fminterval == 0;
  	struct usb_hcd		*hcd = ohci_to_hcd(ohci);
+	unsigned long		usecs;

  	disable (ohci);

@@ -724,7 +725,8 @@ retry:
  	spin_unlock_irq (&ohci->lock);

  	// POTPGT delay is bits 24-31, in 2 ms units.
-	mdelay ((val >> 23) & 0x1fe);
+	usecs = ((val >> 23) & 0x1fe) * USEC_PER_MSEC;
+	usleep_range(usecs, usecs + 1000);
  	hcd->state = HC_STATE_RUNNING;

  	if (quirk_zfmicro(ohci)) {
-- 
1.7.7.4

