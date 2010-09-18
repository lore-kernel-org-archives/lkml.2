Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab0IRTBw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:01:52 -0400
Received: from kroah.org ([198.145.64.141]:51144 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423Ab0IRTBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:17 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:53 2010
Message-Id: <20100918185953.922961386@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:57:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [013/123] staging: hv: Fixed the value of the 64bit-hole inside ring buffer
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=staging-hv-fixed-the-value-of-the-64bit-hole-inside-ring-buffer.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
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

Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/hv/RingBuffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/hv/RingBuffer.c
+++ b/drivers/staging/hv/RingBuffer.c
@@ -192,7 +192,7 @@ Description:
 static inline u64
 GetRingBufferIndices(RING_BUFFER_INFO* RingInfo)
 {
-	return ((u64)RingInfo->RingBuffer->WriteIndex << 32) || RingInfo->RingBuffer->ReadIndex;
+	return (u64)RingInfo->RingBuffer->WriteIndex << 32;
 }
 
 


