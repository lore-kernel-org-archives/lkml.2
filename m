Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab0HCRhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 13:37:19 -0400
Received: from maila.microsoft.com ([131.107.115.212]:15604 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757278Ab0HCRhN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:37:13 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "'gregkh@suse.de'" <gregkh@suse.de>
Subject: [PATCH 3/6] staging: hv: Fixed the value of the 64bit-hole inside
 ring buffer
Thread-Topic: [PATCH 3/6] staging: hv: Fixed the value of the 64bit-hole
 inside ring buffer
Thread-Index: AcszLO9qZOv04Uv+S4i5FuiriXxrpA==
Date: Tue, 3 Aug 2010 17:31:57 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56223FD1D45@TK5EX14MBXC114.redmond.corp.microsoft.com>
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

From: Haiyang Zhang <haiyangz@microsoft.com>

Fixed the value of the 64bit-hole inside ring buffer, this caused a problem on Hyper-V when running checked Windows builds.

Signed-off-by:Hank Janssen <hjanssen@microsoft.com>
Signed-off-by:Haiyang Zhang <haiyangz@microsoft.com>

---
 drivers/staging/hv/ring_buffer.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/ring_buffer.c b/drivers/staging/hv/ring_buffer.c
index 66a4974..133f909 100644
--- a/drivers/staging/hv/ring_buffer.c
+++ b/drivers/staging/hv/ring_buffer.c
@@ -192,8 +192,7 @@ Description:
 static inline u64
 GetRingBufferIndices(RING_BUFFER_INFO *RingInfo)  {
-	return ((u64)RingInfo->RingBuffer->WriteIndex << 32)
-	|| RingInfo->RingBuffer->ReadIndex;
+	return (u64)RingInfo->RingBuffer->WriteIndex << 32;
 }
 
 
--
1.6.0.2

