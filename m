Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab1EDUxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:53:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172Ab1EDUw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:52:58 -0400
Date: Wed, 4 May 2011 23:52:14 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Shirley Ma <xma@us.ibm.com>, lguest@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Krishna Kumar <krkumar2@in.ibm.com>,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, steved@us.ibm.com,
        habanero@linux.vnet.ibm.com
Subject: [PATCH 12/18] virtio_test: support used_event index
Message-ID: <3f1f65fa3724ae084109fd77aa1d92d7ef1c328a.1304541919.git.mst@redhat.com>
References: <cover.1304541918.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1304541918.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ability to test the new used_event feature,
enable by default.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 tools/virtio/virtio_test.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index 9e65e6d..157ec68 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -210,18 +210,29 @@ const struct option longopts[] = {
 		.val = 'i',
 	},
 	{
+		.name = "used-event-idx",
+		.val = 'U',
+	},
+	{
+		.name = "no-used-event-idx",
+		.val = 'u',
+	},
+	{
 	}
 };
 
 static void help()
 {
-	fprintf(stderr, "Usage: virtio_test [--help] [--no-indirect]\n");
+	fprintf(stderr, "Usage: virtio_test [--help]"
+		" [--no-indirect] "
+		" [--no-used-event-idx]\n");
 }
 
 int main(int argc, char **argv)
 {
 	struct vdev_info dev;
-	unsigned long long features = 1ULL << VIRTIO_RING_F_INDIRECT_DESC;
+	unsigned long long features = (1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
+		(1ULL << VIRTIO_RING_F_USED_EVENT_IDX);
 	int o;
 
 	for (;;) {
@@ -238,6 +249,9 @@ int main(int argc, char **argv)
 		case 'i':
 			features &= ~(1ULL << VIRTIO_RING_F_INDIRECT_DESC);
 			break;
+		case 'u':
+			features &= ~(1ULL << VIRTIO_RING_F_USED_EVENT_IDX);
+			break;
 		default:
 			assert(0);
 			break;
-- 
1.7.5.53.gc233e

