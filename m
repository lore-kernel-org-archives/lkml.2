Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab1ABHWI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:22:08 -0500
Received: from mail.windriver.com ([147.11.1.11]:34393 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab1ABHV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:21:59 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 040/260] staging: hv: Increased storvsc ringbuffer and max_io_requests
Date: Sun,  2 Jan 2011 02:15:36 -0500
Message-Id: <1293952756-15010-41-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:50.0241 (UTC) FILETIME=[9530FB10:01CBAA4D]
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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/hv/StorVscApi.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/StorVscApi.h b/drivers/staging/hv/StorVscApi.h
index 126a858..aad90bd 100644
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
-- 
1.7.3.3

