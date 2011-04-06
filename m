Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232Ab1DFElc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 00:41:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44677 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab1DFEl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 00:41:29 -0400
Date: Wed, 6 Apr 2011 14:41:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olaf Hering <olaf@aepfle.de>, Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: linux-next: manual merge of the staging tree with the
 staging.current tree
Message-Id: <20110406144122.8d67030e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/hv/vmbus_drv.c between commit 22356585712d ("staging: hv:
use sync_bitops when interacting with the hypervisor") from the
staging.current tree and commit 98e087022b61 ("staging: hv: Remove all
unneeded DPRINT from hv_vmbus") from the staging tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/hv/vmbus_drv.c
index 79089f8,501ab36..0000000
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@@ -254,10 -527,8 +527,8 @@@ static int vmbus_on_isr(void
  	event = (union hv_synic_event_flags *)page_addr + VMBUS_MESSAGE_SINT;
  
  	/* Since we are a child, we only need to check bit 0 */
- 	if (sync_test_and_clear_bit(0, (unsigned long *) &event->flags32[0])) {
- 		DPRINT_DBG(VMBUS, "received event %d", event->flags32[0]);
 -	if (test_and_clear_bit(0, (unsigned long *) &event->flags32[0]))
++	if (sync_test_and_clear_bit(0, (unsigned long *) &event->flags32[0]))
  		ret |= 0x2;
- 	}
  
  	return ret;
  }
