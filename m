Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab1ABIJk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:09:40 -0500
Received: from mail.windriver.com ([147.11.1.11]:34378 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab1ABHV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:21:58 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 039/260] staging: hv: Fixed the value of the 64bit-hole inside ring buffer
Date: Sun,  2 Jan 2011 02:15:35 -0500
Message-Id: <1293952756-15010-40-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:49.0116 (UTC) FILETIME=[948551C0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

commit e5fa721d1c2a54261a37eb59686e18dee34b6af6 upstream.

Fixed the value of the 64bit-hole inside ring buffer, this
caused a problem on Hyper-V when running checked Windows builds.

Checked builds of Windows are used internally and given to external
system integrators at times. They are builds that for example that all
elements in a structure follow the definition of that Structure. The bug
this fixed was for a field that we did not fill in at all (Because we do
Not use it on the Linux side), and the checked build of windows gives
errors on it internally to the Windows logs.

This fixes that error.

Signed-off-by:Hank Janssen <hjanssen@microsoft.com>
Signed-off-by:Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/hv/RingBuffer.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/RingBuffer.c b/drivers/staging/hv/RingBuffer.c
index 80b8a2c..512b5fd 100644
--- a/drivers/staging/hv/RingBuffer.c
+++ b/drivers/staging/hv/RingBuffer.c
@@ -192,8 +192,7 @@ Description:
 static inline u64
 GetRingBufferIndices(RING_BUFFER_INFO *RingInfo)
 {
-	return ((u64)RingInfo->RingBuffer->WriteIndex << 32)
-	|| RingInfo->RingBuffer->ReadIndex;
+	return (u64)RingInfo->RingBuffer->WriteIndex << 32;
 }
 
 
-- 
1.7.3.3

