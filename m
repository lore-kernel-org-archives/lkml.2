Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449Ab0HETak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 15:30:40 -0400
Received: from smtp.microsoft.com ([131.107.115.212]:18483 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933169Ab0HETad convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 15:30:33 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "'gregkh@suse.de'" <gregkh@suse.de>
Subject: [PATCH 4/5] staging: hv: Increased storvsc ringbuffer and
 max_io_requests
Thread-Topic: [PATCH 4/5] staging: hv: Increased storvsc ringbuffer and
 max_io_requests
Thread-Index: Acs008UdxtEncPL+Rpqoxnj3OpofFw==
Date: Thu, 5 Aug 2010 19:30:31 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56223FEC89F@TK5EX14MBXC114.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hank Janssen <hjanssen@microsoft.com>

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


Signed-off-by:Hank Janssen <hjanssen@microsoft.com>
Signed-off-by:Haiyang Zhang <haiyangz@microsoft.com>
Cc: stable <stable@kernel.org>
---
 drivers/staging/hv/storvsc_api.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index 0063bde..8505a1c 100644
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
--
1.6.0.2

