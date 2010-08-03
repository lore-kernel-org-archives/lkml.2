Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab0HCRhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 13:37:16 -0400
Received: from smtp.microsoft.com ([131.107.115.212]:15551 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757260Ab0HCRhI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:37:08 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "'gregkh@suse.de'" <gregkh@suse.de>
Subject: [PATCH 5/6] staging: hv: Increased storvsc ringbuffer and
 max_io_requests
Thread-Topic: [PATCH 5/6] staging: hv: Increased storvsc ringbuffer and
 max_io_requests
Thread-Index: AcszLcUhHXq5Q0YpSPmrzukUj2qQ+A==
Date: Tue, 3 Aug 2010 17:31:55 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56223FD1D36@TK5EX14MBXC114.redmond.corp.microsoft.com>
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

Increased storvsc ringbuffer and max_io_requests. This now more closely mimics 
the numbers on Hyper-V. And will allow more IO requests to take place for the SCSI driver.

Signed-off-by:Hank Janssen <hjanssen@microsoft.com>
Signed-off-by:Haiyang Zhang <haiyangz@microsoft.com> 

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

