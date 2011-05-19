Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520Ab1ESXLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:11:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933288Ab1ESXLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:11:30 -0400
Date: Fri, 20 May 2011 02:11:05 +0300
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
Subject: [PATCHv2 05/14] virtio_test: support event index
Message-ID: <fbed57582b9e8d97c11f889937ea65f42eb03da2.1305846412.git.mst@redhat.com>
References: <cover.1305846412.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1305846412.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ability to test the new event idx feature,
enable by default.
---
 tools/virtio/virtio_test.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index df0c6d2..74d3331 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -198,6 +198,14 @@ const struct option longopts[] = {
 		.val = 'h',
 	},
 	{
+		.name = "event-idx",
+		.val = 'E',
+	},
+	{
+		.name = "no-event-idx",
+		.val = 'e',
+	},
+	{
 		.name = "indirect",
 		.val = 'I',
 	},
@@ -211,13 +219,17 @@ const struct option longopts[] = {
 
 static void help()
 {
-	fprintf(stderr, "Usage: virtio_test [--help] [--no-indirect]\n");
+	fprintf(stderr, "Usage: virtio_test [--help]"
+		" [--no-indirect]"
+		" [--no-event-idx]"
+		"\n");
 }
 
 int main(int argc, char **argv)
 {
 	struct vdev_info dev;
-	unsigned long long features = 1ULL << VIRTIO_RING_F_INDIRECT_DESC;
+	unsigned long long features = (1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
+		(1ULL << VIRTIO_RING_F_EVENT_IDX);
 	int o;
 
 	for (;;) {
@@ -228,6 +240,9 @@ int main(int argc, char **argv)
 		case '?':
 			help();
 			exit(2);
+		case 'e':
+			features &= ~(1ULL << VIRTIO_RING_F_EVENT_IDX);
+			break;
 		case 'h':
 			help();
 			goto done;
-- 
1.7.5.53.gc233e

