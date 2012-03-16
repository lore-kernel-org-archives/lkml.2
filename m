Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423037Ab2CPPUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 11:20:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032852Ab2CPPUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 11:20:39 -0400
Subject: [PATCH] virtio-spec: split virtio-net device status filed into ro and
 rw byte
To: qemu-devel@nongnu.org, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, mst@redhat.com
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 16 Mar 2012 23:20:26 +0800
Message-ID: <20120316152026.6428.6983.stgit@jason-ThinkPad-T400>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch splits the device status field of virtio-net into ro and rw
byte. This would simplify the implementation of both host and guest
and make the layout more clean. As VIRTIO_NET_S_ANNOUNCE is a rw bit,
it was moved to bit 8 (0x100).

btw. looks like there's no implementation that depends on
VIRTIO_NET_S_ANNOUNCE, so the move is safe.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 virtio-0.9.4.lyx |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/virtio-0.9.4.lyx b/virtio-0.9.4.lyx
index 6c7bab1..ef3951c 100644
--- a/virtio-0.9.4.lyx
+++ b/virtio-0.9.4.lyx
@@ -58,6 +58,7 @@
 \html_be_strict false
 \author -608949062 "Rusty Russell,,," 
 \author 1531152142 "pbonzini" 
+\author 2090695081 "Jason" 
 \end_header
 
 \begin_body
@@ -4012,8 +4013,19 @@ configuration
 layout Two configuration fields are currently defined.
  The mac address field always exists (though is only valid if VIRTIO_NET_F_MAC
  is set), and the status field only exists if VIRTIO_NET_F_STATUS is set.
+
+\change_inserted 2090695081 1331907586
+ The low byte of status field is read-only, guest write to this byte would
+ be ignored.
+ Currently only one bit is defined for this byte: VIRTIO_NET_S_LINK_UP.
+ The high byte of status field is read-writable.
+ Currently only one bit is defined for this byte: VIRTIO_NET_S_ANNOUNCE.
+
+\change_deleted 2090695081 1331907489
  Two bits are currently defined for the status field: VIRTIO_NET_S_LINK_UP
  and VIRTIO_NET_S_ANNOUNCE.
+
+\change_unchanged
  
 \begin_inset listings
 inline false
@@ -4026,7 +4038,13 @@ status open
 
 \begin_layout Plain Layout
 
-#define VIRTIO_NET_S_ANNOUNCE	2
+#define VIRTIO_NET_S_ANNOUNCE	
+\change_inserted 2090695081 1331907493
+0x100
+\change_deleted 2090695081 1331907491
+2
+\change_unchanged
+
 \end_layout
 
 \begin_layout Plain Layout

