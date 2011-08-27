Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab1H0BIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 21:08:06 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:58753 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab1H0BIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 21:08:04 -0400
Message-ID: <4E584365.1010806@gmail.com>
Date: Sat, 27 Aug 2011 09:07:49 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] virtio: fix size computation according to the definition
 of struct vring_used in vring_size
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is against 3.1-rc3.

struct vring_used has two __u16 fields plus array of struct vring_used_elem.
Current vring_size counts the __u16 fields to 3. Fix it to 2 in the patch.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 include/linux/virtio_ring.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index 4a32cb6..fcda152 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -143,7 +143,7 @@ static inline unsigned vring_size(unsigned int num, unsigned long align)
 {
 	return ((sizeof(struct vring_desc) * num + sizeof(__u16) * (2 + num)
 		 + align - 1) & ~(align - 1))
-		+ sizeof(__u16) * 3 + sizeof(struct vring_used_elem) * num;
+		+ sizeof(__u16) * 2 + sizeof(struct vring_used_elem) * num;
 }
 
 /* The following is used with USED_EVENT_IDX and AVAIL_EVENT_IDX */
-- 
1.7.1

crossover@crossover-plinux:~/dev/patchwork$ 
