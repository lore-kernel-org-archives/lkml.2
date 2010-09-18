Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab0IRTPE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:15:04 -0400
Received: from kroah.org ([198.145.64.141]:43276 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756707Ab0IRTO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:14:59 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:12:59 2010
Message-Id: <20100918191259.756211618@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [029/129] staging: hv: Increased storvsc ringbuffer and max_io_requests
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hank Janssen <hjanssen@microsoft.com>

commit 15dd1c9f53b31cdc84b8072a88c23fa09527c596 upstream.

Increased storvsc ringbuffer and max_io_requests. This now more
closely mimics the numbers on Hyper-V. And will allow more IO requests
to take place for the SCSI driver.

Max_IO is set to double from what it was before, Hyper-V allows it and
we have had appliance builder requests to see if it was a problem to
increase the number.

Ringbuffer size for storvsc is now increased because I have seen A few buffer
problems on extremely busy systems. They were Set pretty low before.
And since max_io_requests is increased I Really needed to increase the buffer
as well.


Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/hv/storvsc_api.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -28,10 +28,10 @@
 #include "vmbus_api.h"
 
 /* Defines */
-#define STORVSC_RING_BUFFER_SIZE			(10*PAGE_SIZE)
+#define STORVSC_RING_BUFFER_SIZE			(20*PAGE_SIZE)
 #define BLKVSC_RING_BUFFER_SIZE				(20*PAGE_SIZE)
 
-#define STORVSC_MAX_IO_REQUESTS				64
+#define STORVSC_MAX_IO_REQUESTS				128
 
 /*
  * In Hyper-V, each port/path/target maps to 1 scsi host adapter.  In


