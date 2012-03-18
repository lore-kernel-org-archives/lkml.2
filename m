Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964818Ab2CRXUo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 19:20:44 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38417 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964777Ab2CRXUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 19:20:30 -0400
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: linaro-mm-sig@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 4/4] dma-buf: document fd flags and O_CLOEXEC requirement
Date: Mon, 19 Mar 2012 00:34:28 +0100
Message-Id: <1332113668-4364-4-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1332113668-4364-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1332113668-4364-1-git-send-email-daniel.vetter@ffwll.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise subsystems will get this wrong and end up with and second
export ioctl with the flag and O_CLOEXEC support added.

Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 Documentation/dma-buf-sharing.txt |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
index 9f3aeef..087e261 100644
--- a/Documentation/dma-buf-sharing.txt
+++ b/Documentation/dma-buf-sharing.txt
@@ -319,6 +319,11 @@ Miscellaneous notes
 - Any exporters or users of the dma-buf buffer sharing framework must have
   a 'select DMA_SHARED_BUFFER' in their respective Kconfigs.
 
+- To avoid the wrath of userspace library writers exporting subsystems must have
+  a flag parameter in the ioctl that creates the dma-buf fd which needs to
+  support at least the O_CLOEXEC fd flag. This needs to be passed in the flag
+  parameter of dma_buf_export.
+
 References:
 [1] struct dma_buf_ops in include/linux/dma-buf.h
 [2] All interfaces mentioned above defined in include/linux/dma-buf.h
-- 
1.7.7.5

