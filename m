Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab0IRTBz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:01:55 -0400
Received: from kroah.org ([198.145.64.141]:51148 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab0IRTBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:17 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:54 2010
Message-Id: <20100918185954.003950482@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:57:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [014/123] staging: hv: Increased storvsc ringbuffer and max_io_requests
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=staging-hv-increased-storvsc-ringbuffer-and-max_io_requests.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 drivers/staging/hv/StorVscApi.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/hv/StorVscApi.h
+++ b/drivers/staging/hv/StorVscApi.h
@@ -28,10 +28,10 @@
 #include "VmbusApi.h"
 
 /* Defines */
-#define STORVSC_RING_BUFFER_SIZE			(10*PAGE_SIZE)
+#define STORVSC_RING_BUFFER_SIZE			(20*PAGE_SIZE)
 #define BLKVSC_RING_BUFFER_SIZE				(20*PAGE_SIZE)
 
-#define STORVSC_MAX_IO_REQUESTS				64
+#define STORVSC_MAX_IO_REQUESTS				128
 
 /*
  * In Hyper-V, each port/path/target maps to 1 scsi host adapter.  In


