Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab1HYPJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:09:40 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33400 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab1HYPJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:24 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 043/118] drbd: Rename "enum drbd_packets" to "enum drbd_packet"
Date: Thu, 25 Aug 2011 17:07:39 +0200
Message-Id: <1314284934-17999-44-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |   40 +++++++--------
 drivers/block/drbd/drbd_main.c     |   43 +++++++---------
 drivers/block/drbd/drbd_receiver.c |   97 +++++++++++++++++++++--------------
 3 files changed, 97 insertions(+), 83 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index e2a33ce..7cc75dd9 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -159,7 +159,7 @@ extern struct drbd_conf **minor_table;
 extern struct ratelimit_state drbd_ratelimit_state;
 
 /* on the wire */
-enum drbd_packets {
+enum drbd_packet {
 	/* receiver (data socket) */
 	P_DATA		      = 0x00,
 	P_DATA_REPLY	      = 0x01, /* Response to P_DATA_REQUEST */
@@ -221,7 +221,7 @@ enum drbd_packets {
 	P_HAND_SHAKE	      = 0xfffe	/* FIXED for the next century! */
 };
 
-extern const char *cmdname(enum drbd_packets cmd);
+extern const char *cmdname(enum drbd_packet cmd);
 
 /* for sending/receiving the bitmap,
  * possibly in some encoding scheme */
@@ -1189,36 +1189,34 @@ extern int drbd_send_sizes(struct drbd_conf *mdev, int trigger_reply, enum dds_f
 extern int _drbd_send_state(struct drbd_conf *mdev);
 extern int drbd_send_state(struct drbd_conf *mdev);
 extern int _drbd_send_cmd(struct drbd_conf *mdev, struct socket *sock,
-			enum drbd_packets cmd, struct p_header *h,
-			size_t size, unsigned msg_flags);
+			  enum drbd_packet cmd, struct p_header *h,
+			  size_t size, unsigned msg_flags);
 #define USE_DATA_SOCKET 1
 #define USE_META_SOCKET 0
 extern int drbd_send_cmd(struct drbd_conf *mdev, int use_data_socket,
-			enum drbd_packets cmd, struct p_header *h,
-			size_t size);
-extern int drbd_send_cmd2(struct drbd_conf *mdev, enum drbd_packets cmd,
-			char *data, size_t size);
+			 enum drbd_packet cmd, struct p_header *h, size_t size);
+extern int drbd_send_cmd2(struct drbd_conf *mdev, enum drbd_packet cmd,
+			  char *data, size_t size);
 extern int drbd_send_sync_param(struct drbd_conf *mdev, struct syncer_conf *sc);
 extern int drbd_send_b_ack(struct drbd_conf *mdev, u32 barrier_nr,
 			u32 set_size);
-extern int drbd_send_ack(struct drbd_conf *mdev, enum drbd_packets cmd,
-			struct drbd_epoch_entry *e);
-extern int drbd_send_ack_rp(struct drbd_conf *mdev, enum drbd_packets cmd,
-			struct p_block_req *rp);
-extern int drbd_send_ack_dp(struct drbd_conf *mdev, enum drbd_packets cmd,
-			struct p_data *dp, int data_size);
-extern int drbd_send_ack_ex(struct drbd_conf *mdev, enum drbd_packets cmd,
+extern int drbd_send_ack(struct drbd_conf *mdev, enum drbd_packet cmd,
+			 struct drbd_epoch_entry *e);
+extern int drbd_send_ack_rp(struct drbd_conf *mdev, enum drbd_packet cmd,
+			    struct p_block_req *rp);
+extern int drbd_send_ack_dp(struct drbd_conf *mdev, enum drbd_packet cmd,
+			    struct p_data *dp, int data_size);
+extern int drbd_send_ack_ex(struct drbd_conf *mdev, enum drbd_packet cmd,
 			    sector_t sector, int blksize, u64 block_id);
 extern int drbd_send_oos(struct drbd_conf *mdev, struct drbd_request *req);
-extern int drbd_send_block(struct drbd_conf *mdev, enum drbd_packets cmd,
+extern int drbd_send_block(struct drbd_conf *mdev, enum drbd_packet cmd,
 			   struct drbd_epoch_entry *e);
 extern int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req);
 extern int drbd_send_drequest(struct drbd_conf *mdev, int cmd,
 			      sector_t sector, int size, u64 block_id);
-extern int drbd_send_drequest_csum(struct drbd_conf *mdev,
-				   sector_t sector,int size,
-				   void *digest, int digest_size,
-				   enum drbd_packets cmd);
+extern int drbd_send_drequest_csum(struct drbd_conf *mdev, sector_t sector,
+				   int size, void *digest, int digest_size,
+				   enum drbd_packet cmd);
 extern int drbd_send_ov_request(struct drbd_conf *mdev,sector_t sector,int size);
 
 extern int drbd_send_bitmap(struct drbd_conf *mdev);
@@ -1961,7 +1959,7 @@ static inline void request_ping(struct drbd_conf *mdev)
 }
 
 static inline int drbd_send_short_cmd(struct drbd_conf *mdev,
-	enum drbd_packets cmd)
+				      enum drbd_packet cmd)
 {
 	struct p_header h;
 	return drbd_send_cmd(mdev, USE_DATA_SOCKET, cmd, &h, sizeof(h));
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 097b7a2..a673693 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1821,7 +1821,7 @@ void drbd_thread_current_set_cpu(struct drbd_conf *mdev)
 #endif
 
 static void prepare_header80(struct drbd_conf *mdev, struct p_header80 *h,
-			     enum drbd_packets cmd, int size)
+			     enum drbd_packet cmd, int size)
 {
 	h->magic   = cpu_to_be32(DRBD_MAGIC);
 	h->command = cpu_to_be16(cmd);
@@ -1829,7 +1829,7 @@ static void prepare_header80(struct drbd_conf *mdev, struct p_header80 *h,
 }
 
 static void prepare_header95(struct drbd_conf *mdev, struct p_header95 *h,
-			     enum drbd_packets cmd, int size)
+			     enum drbd_packet cmd, int size)
 {
 	h->magic   = cpu_to_be16(DRBD_MAGIC_BIG);
 	h->command = cpu_to_be16(cmd);
@@ -1837,7 +1837,7 @@ static void prepare_header95(struct drbd_conf *mdev, struct p_header95 *h,
 }
 
 static void prepare_header(struct drbd_conf *mdev, struct p_header *h,
-			   enum drbd_packets cmd, int size)
+			   enum drbd_packet cmd, int size)
 {
 	if (mdev->tconn->agreed_pro_version >= 100 || size > DRBD_MAX_SIZE_H80_PACKET)
 		prepare_header95(mdev, &h->h95, cmd, size);
@@ -1847,8 +1847,8 @@ static void prepare_header(struct drbd_conf *mdev, struct p_header *h,
 
 /* the appropriate socket mutex must be held already */
 int _drbd_send_cmd(struct drbd_conf *mdev, struct socket *sock,
-			  enum drbd_packets cmd, struct p_header *h,
-			  size_t size, unsigned msg_flags)
+		   enum drbd_packet cmd, struct p_header *h, size_t size,
+		   unsigned msg_flags)
 {
 	int sent, ok;
 
@@ -1872,7 +1872,7 @@ int _drbd_send_cmd(struct drbd_conf *mdev, struct socket *sock,
  * when we hold the appropriate socket mutex.
  */
 int drbd_send_cmd(struct drbd_conf *mdev, int use_data_socket,
-		  enum drbd_packets cmd, struct p_header *h, size_t size)
+		  enum drbd_packet cmd, struct p_header *h, size_t size)
 {
 	int ok = 0;
 	struct socket *sock;
@@ -1897,7 +1897,7 @@ int drbd_send_cmd(struct drbd_conf *mdev, int use_data_socket,
 	return ok;
 }
 
-int drbd_send_cmd2(struct drbd_conf *mdev, enum drbd_packets cmd, char *data,
+int drbd_send_cmd2(struct drbd_conf *mdev, enum drbd_packet cmd, char *data,
 		   size_t size)
 {
 	struct p_header h;
@@ -1938,7 +1938,8 @@ int drbd_send_sync_param(struct drbd_conf *mdev, struct syncer_conf *sc)
 	sock = mdev->tconn->data.socket;
 
 	if (likely(sock != NULL)) {
-		enum drbd_packets cmd = apv >= 89 ? P_SYNC_PARAM89 : P_SYNC_PARAM;
+		enum drbd_packet cmd =
+			apv >= 89 ? P_SYNC_PARAM89 : P_SYNC_PARAM;
 
 		p = &mdev->tconn->data.sbuf.rs_param_95;
 
@@ -2391,10 +2392,8 @@ int drbd_send_b_ack(struct drbd_conf *mdev, u32 barrier_nr, u32 set_size)
  * @blksize:	size in byte, needs to be in big endian byte order
  * @block_id:	Id, big endian byte order
  */
-static int _drbd_send_ack(struct drbd_conf *mdev, enum drbd_packets cmd,
-			  u64 sector,
-			  u32 blksize,
-			  u64 block_id)
+static int _drbd_send_ack(struct drbd_conf *mdev, enum drbd_packet cmd,
+			  u64 sector, u32 blksize, u64 block_id)
 {
 	int ok;
 	struct p_block_ack p;
@@ -2413,7 +2412,7 @@ static int _drbd_send_ack(struct drbd_conf *mdev, enum drbd_packets cmd,
 /* dp->sector and dp->block_id already/still in network byte order,
  * data_size is payload size according to dp->head,
  * and may need to be corrected for digest size. */
-int drbd_send_ack_dp(struct drbd_conf *mdev, enum drbd_packets cmd,
+int drbd_send_ack_dp(struct drbd_conf *mdev, enum drbd_packet cmd,
 		     struct p_data *dp, int data_size)
 {
 	data_size -= (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->integrity_r_tfm) ?
@@ -2422,7 +2421,7 @@ int drbd_send_ack_dp(struct drbd_conf *mdev, enum drbd_packets cmd,
 			      dp->block_id);
 }
 
-int drbd_send_ack_rp(struct drbd_conf *mdev, enum drbd_packets cmd,
+int drbd_send_ack_rp(struct drbd_conf *mdev, enum drbd_packet cmd,
 		     struct p_block_req *rp)
 {
 	return _drbd_send_ack(mdev, cmd, rp->sector, rp->blksize, rp->block_id);
@@ -2434,8 +2433,8 @@ int drbd_send_ack_rp(struct drbd_conf *mdev, enum drbd_packets cmd,
  * @cmd:	Packet command code.
  * @e:		Epoch entry.
  */
-int drbd_send_ack(struct drbd_conf *mdev,
-	enum drbd_packets cmd, struct drbd_epoch_entry *e)
+int drbd_send_ack(struct drbd_conf *mdev, enum drbd_packet cmd,
+		  struct drbd_epoch_entry *e)
 {
 	return _drbd_send_ack(mdev, cmd,
 			      cpu_to_be64(e->i.sector),
@@ -2445,7 +2444,7 @@ int drbd_send_ack(struct drbd_conf *mdev,
 
 /* This function misuses the block_id field to signal if the blocks
  * are is sync or not. */
-int drbd_send_ack_ex(struct drbd_conf *mdev, enum drbd_packets cmd,
+int drbd_send_ack_ex(struct drbd_conf *mdev, enum drbd_packet cmd,
 		     sector_t sector, int blksize, u64 block_id)
 {
 	return _drbd_send_ack(mdev, cmd,
@@ -2468,10 +2467,8 @@ int drbd_send_drequest(struct drbd_conf *mdev, int cmd,
 	return ok;
 }
 
-int drbd_send_drequest_csum(struct drbd_conf *mdev,
-			    sector_t sector, int size,
-			    void *digest, int digest_size,
-			    enum drbd_packets cmd)
+int drbd_send_drequest_csum(struct drbd_conf *mdev, sector_t sector, int size,
+			    void *digest, int digest_size, enum drbd_packet cmd)
 {
 	int ok;
 	struct p_block_req p;
@@ -2742,7 +2739,7 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
  *  Peer       -> (diskless) R_PRIMARY   (P_DATA_REPLY)
  *  C_SYNC_SOURCE -> C_SYNC_TARGET         (P_RS_DATA_REPLY)
  */
-int drbd_send_block(struct drbd_conf *mdev, enum drbd_packets cmd,
+int drbd_send_block(struct drbd_conf *mdev, enum drbd_packet cmd,
 		    struct drbd_epoch_entry *e)
 {
 	int ok;
@@ -4101,7 +4098,7 @@ static int w_md_sync(struct drbd_conf *mdev, struct drbd_work *w, int unused)
 	return 1;
 }
 
-const char *cmdname(enum drbd_packets cmd)
+const char *cmdname(enum drbd_packet cmd)
 {
 	/* THINK may need to become several global tables
 	 * when we want to support more than
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 24c906f..72b2512 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -697,15 +697,16 @@ out:
 	return s_estab;
 }
 
-static int drbd_send_fp(struct drbd_conf *mdev,
-	struct socket *sock, enum drbd_packets cmd)
+static int drbd_send_fp(struct drbd_conf *mdev, struct socket *sock,
+			enum drbd_packet cmd)
 {
 	struct p_header *h = &mdev->tconn->data.sbuf.header;
 
 	return _drbd_send_cmd(mdev, sock, cmd, h, sizeof(*h), 0);
 }
 
-static enum drbd_packets drbd_recv_fp(struct drbd_conf *mdev, struct socket *sock)
+static enum drbd_packet drbd_recv_fp(struct drbd_conf *mdev,
+				     struct socket *sock)
 {
 	struct p_header80 *h = &mdev->tconn->data.rbuf.header.h80;
 	int rr;
@@ -926,8 +927,8 @@ out_release_sockets:
 	return -1;
 }
 
-static bool decode_header(struct drbd_conf *mdev, struct p_header *h, enum drbd_packets *cmd,
-			  unsigned int *packet_size)
+static bool decode_header(struct drbd_conf *mdev, struct p_header *h,
+			  enum drbd_packet *cmd, unsigned int *packet_size)
 {
 	u32 vol_n_len;
 
@@ -949,7 +950,8 @@ static bool decode_header(struct drbd_conf *mdev, struct p_header *h, enum drbd_
 	return true;
 }
 
-static int drbd_recv_header(struct drbd_conf *mdev, enum drbd_packets *cmd, unsigned int *packet_size)
+static int drbd_recv_header(struct drbd_conf *mdev, enum drbd_packet *cmd,
+			    unsigned int *packet_size)
 {
 	struct p_header *h = &mdev->tconn->data.rbuf.header;
 	int r;
@@ -1174,7 +1176,8 @@ fail:
 	return err;
 }
 
-static int receive_Barrier(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int data_size)
+static int receive_Barrier(struct drbd_conf *mdev, enum drbd_packet cmd,
+			   unsigned int data_size)
 {
 	int rv;
 	struct p_barrier *p = &mdev->tconn->data.rbuf.barrier;
@@ -1503,7 +1506,8 @@ find_request(struct drbd_conf *mdev, struct rb_root *root, u64 id,
 	return NULL;
 }
 
-static int receive_DataReply(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int data_size)
+static int receive_DataReply(struct drbd_conf *mdev, enum drbd_packet cmd,
+			     unsigned int data_size)
 {
 	struct drbd_request *req;
 	sector_t sector;
@@ -1532,7 +1536,8 @@ static int receive_DataReply(struct drbd_conf *mdev, enum drbd_packets cmd, unsi
 	return ok;
 }
 
-static int receive_RSDataReply(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int data_size)
+static int receive_RSDataReply(struct drbd_conf *mdev, enum drbd_packet cmd,
+			       unsigned int data_size)
 {
 	sector_t sector;
 	int ok;
@@ -1685,7 +1690,8 @@ static unsigned long wire_flags_to_bio(struct drbd_conf *mdev, u32 dpf)
 }
 
 /* mirrored write */
-static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int data_size)
+static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
+			unsigned int data_size)
 {
 	sector_t sector;
 	struct drbd_epoch_entry *e;
@@ -1970,7 +1976,8 @@ int drbd_rs_should_slow_down(struct drbd_conf *mdev, sector_t sector)
 }
 
 
-static int receive_DataRequest(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int digest_size)
+static int receive_DataRequest(struct drbd_conf *mdev, enum drbd_packet cmd,
+			       unsigned int digest_size)
 {
 	sector_t sector;
 	const sector_t capacity = drbd_get_capacity(mdev->this_bdev);
@@ -2695,7 +2702,8 @@ static int cmp_after_sb(enum drbd_after_sb_p peer, enum drbd_after_sb_p self)
 	return 1;
 }
 
-static int receive_protocol(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int data_size)
+static int receive_protocol(struct drbd_conf *mdev, enum drbd_packet cmd,
+			    unsigned int data_size)
 {
 	struct p_protocol *p = &mdev->tconn->data.rbuf.protocol;
 	int p_proto, p_after_sb_0p, p_after_sb_1p, p_after_sb_2p;
@@ -2794,7 +2802,8 @@ struct crypto_hash *drbd_crypto_alloc_digest_safe(const struct drbd_conf *mdev,
 	return tfm;
 }
 
-static int receive_SyncParam(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int packet_size)
+static int receive_SyncParam(struct drbd_conf *mdev, enum drbd_packet cmd,
+			     unsigned int packet_size)
 {
 	int ok = true;
 	struct p_rs_param_95 *p = &mdev->tconn->data.rbuf.rs_param_95;
@@ -2958,7 +2967,8 @@ static void warn_if_differ_considerably(struct drbd_conf *mdev,
 		     (unsigned long long)a, (unsigned long long)b);
 }
 
-static int receive_sizes(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int data_size)
+static int receive_sizes(struct drbd_conf *mdev, enum drbd_packet cmd,
+			 unsigned int data_size)
 {
 	struct p_sizes *p = &mdev->tconn->data.rbuf.sizes;
 	enum determine_dev_size dd = unchanged;
@@ -3061,7 +3071,8 @@ static int receive_sizes(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 	return true;
 }
 
-static int receive_uuids(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int data_size)
+static int receive_uuids(struct drbd_conf *mdev, enum drbd_packet cmd,
+			 unsigned int data_size)
 {
 	struct p_uuids *p = &mdev->tconn->data.rbuf.uuids;
 	u64 *p_uuid;
@@ -3155,7 +3166,8 @@ static union drbd_state convert_state(union drbd_state ps)
 	return ms;
 }
 
-static int receive_req_state(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int data_size)
+static int receive_req_state(struct drbd_conf *mdev, enum drbd_packet cmd,
+			     unsigned int data_size)
 {
 	struct p_req_state *p = &mdev->tconn->data.rbuf.req_state;
 	union drbd_state mask, val;
@@ -3181,7 +3193,8 @@ static int receive_req_state(struct drbd_conf *mdev, enum drbd_packets cmd, unsi
 	return true;
 }
 
-static int receive_state(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int data_size)
+static int receive_state(struct drbd_conf *mdev, enum drbd_packet cmd,
+			 unsigned int data_size)
 {
 	struct p_state *p = &mdev->tconn->data.rbuf.state;
 	union drbd_state os, ns, peer_state;
@@ -3333,7 +3346,8 @@ static int receive_state(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 	return true;
 }
 
-static int receive_sync_uuid(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int data_size)
+static int receive_sync_uuid(struct drbd_conf *mdev, enum drbd_packet cmd,
+			     unsigned int data_size)
 {
 	struct p_rs_uuid *p = &mdev->tconn->data.rbuf.rs_uuid;
 
@@ -3529,7 +3543,8 @@ void INFO_bm_xfer_stats(struct drbd_conf *mdev,
    in order to be agnostic to the 32 vs 64 bits issue.
 
    returns 0 on failure, 1 if we successfully received it. */
-static int receive_bitmap(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int data_size)
+static int receive_bitmap(struct drbd_conf *mdev, enum drbd_packet cmd,
+			  unsigned int data_size)
 {
 	struct bm_xfer_ctx c;
 	void *buffer;
@@ -3620,7 +3635,8 @@ static int receive_bitmap(struct drbd_conf *mdev, enum drbd_packets cmd, unsigne
 	return ok;
 }
 
-static int receive_skip(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int data_size)
+static int receive_skip(struct drbd_conf *mdev, enum drbd_packet cmd,
+			unsigned int data_size)
 {
 	/* TODO zero copy sink :) */
 	static char sink[128];
@@ -3640,7 +3656,8 @@ static int receive_skip(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 	return size == 0;
 }
 
-static int receive_UnplugRemote(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int data_size)
+static int receive_UnplugRemote(struct drbd_conf *mdev, enum drbd_packet cmd,
+				unsigned int data_size)
 {
 	/* Make sure we've acked all the TCP data associated
 	 * with the data requests being unplugged */
@@ -3649,7 +3666,8 @@ static int receive_UnplugRemote(struct drbd_conf *mdev, enum drbd_packets cmd, u
 	return true;
 }
 
-static int receive_out_of_sync(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int data_size)
+static int receive_out_of_sync(struct drbd_conf *mdev, enum drbd_packet cmd,
+			       unsigned int data_size)
 {
 	struct p_block_desc *p = &mdev->tconn->data.rbuf.block_desc;
 
@@ -3668,7 +3686,8 @@ static int receive_out_of_sync(struct drbd_conf *mdev, enum drbd_packets cmd, un
 	return true;
 }
 
-typedef int (*drbd_cmd_handler_f)(struct drbd_conf *, enum drbd_packets cmd, unsigned int to_receive);
+typedef int (*drbd_cmd_handler_f)(struct drbd_conf *, enum drbd_packet cmd,
+				  unsigned int to_receive);
 
 struct data_cmd {
 	int expect_payload;
@@ -3715,7 +3734,7 @@ static void drbdd(struct drbd_conf *mdev)
 {
 	struct p_header *header = &mdev->tconn->data.rbuf.header;
 	unsigned int packet_size;
-	enum drbd_packets cmd;
+	enum drbd_packet cmd;
 	size_t shs; /* sub header size */
 	int rv;
 
@@ -3942,7 +3961,7 @@ static int drbd_do_handshake(struct drbd_conf *mdev)
 	struct p_handshake *p = &mdev->tconn->data.rbuf.handshake;
 	const int expect = sizeof(struct p_handshake) - sizeof(struct p_header80);
 	unsigned int length;
-	enum drbd_packets cmd;
+	enum drbd_packet cmd;
 	int rv;
 
 	rv = drbd_send_handshake(mdev);
@@ -4023,7 +4042,7 @@ static int drbd_do_auth(struct drbd_conf *mdev)
 	unsigned int key_len = strlen(mdev->tconn->net_conf->shared_secret);
 	unsigned int resp_size;
 	struct hash_desc desc;
-	enum drbd_packets cmd;
+	enum drbd_packet cmd;
 	unsigned int length;
 	int rv;
 
@@ -4195,7 +4214,7 @@ int drbdd_init(struct drbd_thread *thi)
 
 /* ********* acknowledge sender ******** */
 
-static int got_RqSReply(struct drbd_conf *mdev, enum drbd_packets cmd)
+static int got_RqSReply(struct drbd_conf *mdev, enum drbd_packet cmd)
 {
 	struct p_req_state_reply *p = &mdev->tconn->meta.rbuf.req_state_reply;
 
@@ -4213,13 +4232,13 @@ static int got_RqSReply(struct drbd_conf *mdev, enum drbd_packets cmd)
 	return true;
 }
 
-static int got_Ping(struct drbd_conf *mdev, enum drbd_packets cmd)
+static int got_Ping(struct drbd_conf *mdev, enum drbd_packet cmd)
 {
 	return drbd_send_ping_ack(mdev);
 
 }
 
-static int got_PingAck(struct drbd_conf *mdev, enum drbd_packets cmd)
+static int got_PingAck(struct drbd_conf *mdev, enum drbd_packet cmd)
 {
 	/* restore idle timeout */
 	mdev->tconn->meta.socket->sk->sk_rcvtimeo = mdev->tconn->net_conf->ping_int*HZ;
@@ -4229,7 +4248,7 @@ static int got_PingAck(struct drbd_conf *mdev, enum drbd_packets cmd)
 	return true;
 }
 
-static int got_IsInSync(struct drbd_conf *mdev, enum drbd_packets cmd)
+static int got_IsInSync(struct drbd_conf *mdev, enum drbd_packet cmd)
 {
 	struct p_block_ack *p = &mdev->tconn->meta.rbuf.block_ack;
 	sector_t sector = be64_to_cpu(p->sector);
@@ -4274,7 +4293,7 @@ validate_req_change_req_state(struct drbd_conf *mdev, u64 id, sector_t sector,
 	return true;
 }
 
-static int got_BlockAck(struct drbd_conf *mdev, enum drbd_packets cmd)
+static int got_BlockAck(struct drbd_conf *mdev, enum drbd_packet cmd)
 {
 	struct p_block_ack *p = &mdev->tconn->meta.rbuf.block_ack;
 	sector_t sector = be64_to_cpu(p->sector);
@@ -4315,7 +4334,7 @@ static int got_BlockAck(struct drbd_conf *mdev, enum drbd_packets cmd)
 					     what, false);
 }
 
-static int got_NegAck(struct drbd_conf *mdev, enum drbd_packets cmd)
+static int got_NegAck(struct drbd_conf *mdev, enum drbd_packet cmd)
 {
 	struct p_block_ack *p = &mdev->tconn->meta.rbuf.block_ack;
 	sector_t sector = be64_to_cpu(p->sector);
@@ -4348,7 +4367,7 @@ static int got_NegAck(struct drbd_conf *mdev, enum drbd_packets cmd)
 	return true;
 }
 
-static int got_NegDReply(struct drbd_conf *mdev, enum drbd_packets cmd)
+static int got_NegDReply(struct drbd_conf *mdev, enum drbd_packet cmd)
 {
 	struct p_block_ack *p = &mdev->tconn->meta.rbuf.block_ack;
 	sector_t sector = be64_to_cpu(p->sector);
@@ -4362,7 +4381,7 @@ static int got_NegDReply(struct drbd_conf *mdev, enum drbd_packets cmd)
 					     NEG_ACKED, false);
 }
 
-static int got_NegRSDReply(struct drbd_conf *mdev, enum drbd_packets cmd)
+static int got_NegRSDReply(struct drbd_conf *mdev, enum drbd_packet cmd)
 {
 	sector_t sector;
 	int size;
@@ -4393,7 +4412,7 @@ static int got_NegRSDReply(struct drbd_conf *mdev, enum drbd_packets cmd)
 	return true;
 }
 
-static int got_BarrierAck(struct drbd_conf *mdev, enum drbd_packets cmd)
+static int got_BarrierAck(struct drbd_conf *mdev, enum drbd_packet cmd)
 {
 	struct p_barrier_ack *p = &mdev->tconn->meta.rbuf.barrier_ack;
 
@@ -4409,7 +4428,7 @@ static int got_BarrierAck(struct drbd_conf *mdev, enum drbd_packets cmd)
 	return true;
 }
 
-static int got_OVResult(struct drbd_conf *mdev, enum drbd_packets cmd)
+static int got_OVResult(struct drbd_conf *mdev, enum drbd_packet cmd)
 {
 	struct p_block_ack *p = &mdev->tconn->meta.rbuf.block_ack;
 	struct drbd_work *w;
@@ -4453,14 +4472,14 @@ static int got_OVResult(struct drbd_conf *mdev, enum drbd_packets cmd)
 	return true;
 }
 
-static int got_skip(struct drbd_conf *mdev, enum drbd_packets cmd)
+static int got_skip(struct drbd_conf *mdev, enum drbd_packet cmd)
 {
 	return true;
 }
 
 struct asender_cmd {
 	size_t pkt_size;
-	int (*process)(struct drbd_conf *mdev, enum drbd_packets cmd);
+	int (*process)(struct drbd_conf *mdev, enum drbd_packet cmd);
 };
 
 static struct asender_cmd *get_asender_cmd(int cmd)
@@ -4503,7 +4522,7 @@ int drbd_asender(struct drbd_thread *thi)
 	int expect   = sizeof(struct p_header);
 	int ping_timeout_active = 0;
 	int empty, pkt_size;
-	enum drbd_packets cmd_nr;
+	enum drbd_packet cmd_nr;
 
 	sprintf(current->comm, "drbd%d_asender", mdev_to_minor(mdev));
 
-- 
1.7.4.1

