Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab0IRTPB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:15:01 -0400
Received: from kroah.org ([198.145.64.141]:43273 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756706Ab0IRTO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:14:58 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:12:59 2010
Message-Id: <20100918191259.655269892@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [028/129] staging: hv: Fixed the value of the 64bit-hole inside ring buffer
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

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

Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/hv/ring_buffer.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/staging/hv/ring_buffer.c
+++ b/drivers/staging/hv/ring_buffer.c
@@ -192,8 +192,7 @@ Description:
 static inline u64
 GetRingBufferIndices(RING_BUFFER_INFO *RingInfo)
 {
-	return ((u64)RingInfo->RingBuffer->WriteIndex << 32)
-	|| RingInfo->RingBuffer->ReadIndex;
+	return (u64)RingInfo->RingBuffer->WriteIndex << 32;
 }
 
 


