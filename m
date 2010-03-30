Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab0C3XnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:43:10 -0400
Received: from kroah.org ([198.145.64.141]:46191 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932384Ab0C3XUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:20:22 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:07 2010
Message-Id: <20100330224806.705989387@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andiry Xu <andiry.xu@amd.com>,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [071/156] USB: xHCI: re-initialize cmd_completion
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1173,6 +1173,7 @@ static int xhci_configure_endpoint(struc
 		cmd_completion = &virt_dev->cmd_completion;
 		cmd_status = &virt_dev->cmd_status;
 	}
+	init_completion(cmd_completion);
 
 	if (!ctx_change)
 		ret = xhci_queue_configure_endpoint(xhci, in_ctx->dma,


