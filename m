Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab2DDHY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 03:24:58 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53082 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab2DDHY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 03:24:56 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH] virtio-spec: add an rpmsg appendix
Date: Wed,  4 Apr 2012 10:24:24 +0300
Message-Id: <1333524264-14811-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an rpmsg appendix to the virtio spec and tag it as Appendix H.

Push the SCSI host appendix to 'I' so the appendices order stays
according to the virtio device ids.

Patch is against:
http://ozlabs.org/~rusty/virtio-spec/virtio-0.9.4.lyx

Tested with LyX 2.0.0.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: <virtualization@lists.linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>
---
These changes were produced using lyx: they look reasonable when viewing as a PDF,
but I didn't reviewed the actual .lyx code, so I hope they make sense.

PS. Congrats, Rusty!

 virtio-0.9.4.lyx |  489 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 486 insertions(+), 3 deletions(-)

diff --git a/virtio-0.9.4.lyx b/virtio-0.9.4.lyx
index 6c7bab1..f377294 100644
--- a/virtio-0.9.4.lyx
+++ b/virtio-0.9.4.lyx
@@ -56,6 +56,7 @@
 \html_math_output 0
 \html_css_as_file 0
 \html_be_strict false
+\author -1096565211 "Ohad,,," 
 \author -608949062 "Rusty Russell,,," 
 \author 1531152142 "pbonzini" 
 \end_header
@@ -573,8 +574,12 @@ rpmsg
 
 \begin_layout Plain Layout
 
-\change_inserted -608949062 1323409055
+\change_inserted -1096565211 1333519287
+Appendix H
+\change_deleted -1096565211 1333521034
 -
+\change_inserted -608949062 1323409055
+
 \end_layout
 
 \end_inset
@@ -609,7 +614,13 @@ SCSI host
 \begin_layout Plain Layout
 
 \change_inserted 1531152142 1322650861
-Appendix H
+Appendix 
+\change_deleted -1096565211 1333519291
+H
+\change_inserted -1096565211 1333519291
+I
+\change_inserted 1531152142 1322650861
+
 \end_layout
 
 \end_inset
@@ -6332,12 +6343,484 @@ VIRTIO_BALLOON_S_MEMFREE The amount of memory not being used for any purpose
 
 \begin_layout Description
 VIRTIO_BALLOON_S_MEMTOT The total amount of memory available (in bytes).
+\change_inserted -1096565211 1333519339
+
+\end_layout
+
+\begin_layout Chapter*
+
+\change_inserted -1096565211 1333519459
+Appendix H: Rpmsg: Remote Processor Messaging
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted -1096565211 1333519548
+Virtio rpmsg devices represent remote processors on the system which run
+ in asymmetric multi-processing (AMP) configuration, and which are usually
+ used to offload cpu-intensive tasks from the main application processor
+ (a typical SoC methodology).
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted -1096565211 1333519483
+Virtio is being used to communicate with those remote processors; empty
+ buffers are placed in one virtqueue for receiving messages, and non-empty
+ buffers, containing outbound messages, are enqueued in a second virtqueue
+ for transmission.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted -1096565211 1333519614
+Numerous communication channels can be multiplexed over those two virtqueues,
+ so different entities, running on the application and remote processor,
+ can directly communicate in a point-to-point fashion.
+\end_layout
+
+\begin_layout Section*
+
+\change_inserted -1096565211 1333519460
+Configuration
+\end_layout
+
+\begin_layout Description
+
+\change_inserted -1096565211 1333519622
+Subsystem
+\begin_inset space ~
+\end_inset
+
+Device
+\begin_inset space ~
+\end_inset
+
+ID 7
+\end_layout
+
+\begin_layout Description
+
+\change_inserted -1096565211 1333519647
+Virtqueues 0:receiveq.
+ 1:transmitq.
+\end_layout
+
+\begin_layout Description
+
+\change_inserted -1096565211 1333519460
+Feature
+\begin_inset space ~
+\end_inset
+
+bits
+\end_layout
+
+\begin_deeper
+\begin_layout Description
+
+\change_inserted -1096565211 1333520994
+VIRTIO_RPMSG_F_NS
+\begin_inset space ~
+\end_inset
+
+(0) Device sends (and capable of receiving) name service messages announcing
+ the creation (or destruction) of a channel:
+\begin_inset listings
+inline false
+status open
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520994
+
+/**
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520994
+
+ * struct rpmsg_ns_msg - dynamic name service announcement message
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520994
+
+ * @name: name of remote service that is published
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520994
+
+ * @addr: address of remote service that is published
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520994
+
+ * @flags: indicates whether service is created or destroyed
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520994
+
+ *
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520994
+
+ * This message is sent across to publish a new service (or announce
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520994
+
+ * about its removal).
+ When we receives these messages, an appropriate
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520994
+
+ * rpmsg channel (i.e device) is created/destroyed.
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520994
+
+ */
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520994
+
+struct rpmsg_ns_msgoon_config {
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520994
+
+	char name[RPMSG_NAME_SIZE];
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520994
+
+	u32 addr;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520994
+
+	u32 flags;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520994
+
+} __packed;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520994
+
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520994
+
+/**
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520994
+
+ * enum rpmsg_ns_flags - dynamic name service announcement flags
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520994
+
+ *
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520994
+
+ * @RPMSG_NS_CREATE: a new remote service was just created
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520994
+
+ * @RPMSG_NS_DESTROY: a remote service was just destroyed
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520994
+
+ */
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520994
+
+enum rpmsg_ns_flags {
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520994
+
+	RPMSG_NS_CREATE = 0,
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520994
+
+	RPMSG_NS_DESTROY = 1,
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520994
+
+};
+\end_layout
+
+\end_inset
+
+
+\end_layout
+
+\end_deeper
+\begin_layout Description
+
+\change_inserted -1096565211 1333520275
+Device
+\begin_inset space ~
+\end_inset
+
+configuration
+\begin_inset space ~
+\end_inset
+
+layout
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted -1096565211 1333521209
+At his point none currently defined.
+\end_layout
+
+\begin_layout Section*
+
+\change_inserted -1096565211 1333519460
+Device Initialization
+\end_layout
+
+\begin_layout Enumerate
+
+\change_inserted -1096565211 1333520334
+The initialization routine should identify the receive and transmission
+ virtqueues.
+\end_layout
+
+\begin_layout Enumerate
+
+\change_inserted -1096565211 1333520335
+The receive virtqueue should be filled with receive buffers.
+\end_layout
+
+\begin_layout Section*
+
+\change_inserted -1096565211 1333520381
+Device Operation
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted -1096565211 1333520426
+Messages are transmitted by placing them in the transmitq, and buffers for
+ inbound messages are placed in the receiveq.
+ In any case, messages are always preceded by the following header: 
+\begin_inset listings
+inline false
+status open
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520439
+
+/**
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520443
+
+ * struct rpmsg_hdr - common header for all rpmsg messages
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520447
+
+ * @src: source address
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520450
+
+ * @dst: destination address
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520453
+
+ * @reserved: reserved for future use
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520456
+
+ * @len: length of payload (in bytes)
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520459
+
+ * @flags: message flags
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520462
+
+ * @data: @len bytes of message payload data
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520464
+
+ *
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520467
+
+ * Every message sent(/received) on the rpmsg bus begins with this header.
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520471
+
+ */
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520475
+
+struct rpmsg_hdr {
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520477
+
+	u32 src;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520480
+
+	u32 dst;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520481
+
+	u32 reserved;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520484
+
+	u16 len;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520486
+
+	u16 flags;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520489
+
+	u8 data[0];
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted -1096565211 1333520487
+
+} __packed;
+\end_layout
+
+\end_inset
+
+
 \end_layout
 
 \begin_layout Chapter*
 
 \change_inserted 1531152142 1322571716
-Appendix H: SCSI Host Device
+Appendix 
+\change_deleted -1096565211 1333519318
+H
+\change_inserted -1096565211 1333519319
+I
+\change_inserted 1531152142 1322571716
+: SCSI Host Device
 \end_layout
 
 \begin_layout Standard
-- 
1.7.5.4

