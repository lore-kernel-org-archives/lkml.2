Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161387Ab2CSP2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:28:03 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33281 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030847Ab2CSP2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:28:01 -0400
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: linaro-mm-sig@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@gmail.com>
Subject: [PATCH] dma-buf: document fd flags and O_CLOEXEC requirement
Date: Mon, 19 Mar 2012 16:41:55 +0100
Message-Id: <1332171715-1484-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <CAPM=9twSZJyYcNwDwaC5eSy7fXNaRBGTZZ6F2K3D8AeQdYtgww@mail.gmail.com>
References: <CAPM=9twSZJyYcNwDwaC5eSy7fXNaRBGTZZ6F2K3D8AeQdYtgww@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise subsystems will get this wrong and end up with a second
export ioctl with the flag and O_CLOEXEC support added.

v2: Fixup the function name and caution exporters to limit the flags
to only O_CLOEXEC. Noted by Dave Airlie.

Cc: Dave Airlie <airlied@gmail.com>
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 Documentation/dma-buf-sharing.txt |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
index 9f3aeef..a6d4c37 100644
--- a/Documentation/dma-buf-sharing.txt
+++ b/Documentation/dma-buf-sharing.txt
@@ -319,6 +319,12 @@ Miscellaneous notes
 - Any exporters or users of the dma-buf buffer sharing framework must have
   a 'select DMA_SHARED_BUFFER' in their respective Kconfigs.
 
+- To avoid the wrath of userspace library writers exporting subsystems must have
+  a flag parameter in the ioctl that creates the dma-buf fd which needs to
+  support at least the O_CLOEXEC fd flag. This needs to be passed in the flag
+  parameter of dma_buf_fd. Without any other reasons applying it is recommended
+  that exporters limit the flags passed to dma_buf_fd to only O_CLOEXEC.
+
 References:
 [1] struct dma_buf_ops in include/linux/dma-buf.h
 [2] All interfaces mentioned above defined in include/linux/dma-buf.h
-- 
1.7.7.5

