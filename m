Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab0CaAGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:06:04 -0400
Received: from kroah.org ([198.145.64.141]:45261 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756768Ab0C3XS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:26 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:42 2010
Message-Id: <20100330225641.980727642@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:55:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andiry Xu <andiry.xu@amd.com>,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [067/116] USB: xHCI: re-initialize cmd_completion
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andiry Xu <andiry.xu@amd.com>

commit 1d68064a7d80da4a7334cab0356162e36229c1a1 upstream.

When a signal interrupts a Configure Endpoint command, the cmd_completion used
in xhci_configure_endpoint() is not re-initialized and the
wait_for_completion_interruptible_timeout() will return failure. Initialize
cmd_completion in xhci_configure_endpoint().

Signed-off-by: Andiry Xu <andiry.xu@amd.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-hcd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/xhci-hcd.c
+++ b/drivers/usb/host/xhci-hcd.c
@@ -1157,6 +1157,7 @@ static int xhci_configure_endpoint(struc
 		cmd_completion = &virt_dev->cmd_completion;
 		cmd_status = &virt_dev->cmd_status;
 	}
+	init_completion(cmd_completion);
 
 	if (!ctx_change)
 		ret = xhci_queue_configure_endpoint(xhci, in_ctx->dma,


