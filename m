Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965065Ab2B1BIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:08:32 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37330 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965029Ab2B1BIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:08:22 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.74.74 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010430.467184125@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:04:41 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mans Rullgard <mans.rullgard@linaro.org>,
        Javi Merino <javi.merino@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 12/72] ARM: 7326/2: PL330: fix null pointer dereference in pl330_chan_ctrl()
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javi Merino <javi.merino@arm.com>

commit 46e33c606af8e0caeeca374103189663d877c0d6 upstream.

This fixes the thrd->req_running field being accessed before thrd
is checked for null. The error was introduced in

   abb959f: ARM: 7237/1: PL330: Fix driver freeze

Reference: <1326458191-23492-1-git-send-email-mans.rullgard@linaro.org>

Signed-off-by: Mans Rullgard <mans.rullgard@linaro.org>
Acked-by: Javi Merino <javi.merino@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/common/pl330.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm/common/pl330.c
+++ b/arch/arm/common/pl330.c
@@ -1496,12 +1496,13 @@ int pl330_chan_ctrl(void *ch_id, enum pl
 	struct pl330_thread *thrd = ch_id;
 	struct pl330_dmac *pl330;
 	unsigned long flags;
-	int ret = 0, active = thrd->req_running;
+	int ret = 0, active;
 
 	if (!thrd || thrd->free || thrd->dmac->state == DYING)
 		return -EINVAL;
 
 	pl330 = thrd->dmac;
+	active = thrd->req_running;
 
 	spin_lock_irqsave(&pl330->lock, flags);
 


