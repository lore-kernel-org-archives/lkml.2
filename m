Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab2CTGUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 02:20:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753997Ab2CTGUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 02:20:32 -0400
Subject: [PATCH] virtio-spec: clarify ro/rw bits and updating rule of
 virtio-net status field
To: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        mst@redhat.com
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 20 Mar 2012 14:20:21 +0800
Message-ID: <20120320062020.12815.61342.stgit@jason-ThinkPad-T400>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch clarifies VIRTIO_NET_S_LINK_UP as a read-only bit and
VIRTIO_NET_S_ANNOUNCE as a read-writable bit. Also introduce the write 1 to
clear semantics for all read-writable bits of config status field. This could
help to reduce the config status field updating race between host and guest and
also simplify the implementation.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 virtio-0.9.4.lyx |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/virtio-0.9.4.lyx b/virtio-0.9.4.lyx
index 6c7bab1..614ab55 100644
--- a/virtio-0.9.4.lyx
+++ b/virtio-0.9.4.lyx
@@ -58,6 +58,7 @@
 \html_be_strict false
 \author -608949062 "Rusty Russell,,," 
 \author 1531152142 "pbonzini" 
+\author 2090695081 "jason" 
 \end_header
 
 \begin_body
@@ -4013,7 +4014,21 @@ layout Two configuration fields are currently defined.
  The mac address field always exists (though is only valid if VIRTIO_NET_F_MAC
  is set), and the status field only exists if VIRTIO_NET_F_STATUS is set.
  Two bits are currently defined for the status field: VIRTIO_NET_S_LINK_UP
- and VIRTIO_NET_S_ANNOUNCE.
+ 
+\change_inserted 2090695081 1332220873
+(read-only) 
+\change_unchanged
+and VIRTIO_NET_S_ANNOUNCE
+\change_inserted 2090695081 1332220883
+ (read-writable)
+\change_unchanged
+.
+
+\change_inserted 2090695081 1332220901
+ Writing 1 to any read-writable bit of status filed would cause the bit
+ to be cleared.
+
+\change_unchanged
  
 \begin_inset listings
 inline false
@@ -4915,7 +4930,11 @@ Processing this notification involves:
 \end_layout
 
 \begin_layout Enumerate
-Clearing VIRTIO_NET_S_ANNOUNCE bit in the status field.
+Clearing VIRTIO_NET_S_ANNOUNCE bit in the status field
+\change_inserted 2090695081 1332220849
+ (by writing 1 to VIRTIO_NET_S_ANNOUNCE bit)
+\change_unchanged
+.
 \end_layout
 
 \begin_layout Enumerate

