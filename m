Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab0DMFqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 01:46:03 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:56524 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab0DMFqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 01:46:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hgezhLFKPOkS9pF8N14+fahKhZll9SzC4TPezaR9C3Jwc08gu+nnn1skHtqA2lGHES
         W7qhY7m93yzZ0CdxOPtW8h6A84J9xj9DSRuAMWQpPmn3Q8Ls4MIzaVqldsNbsC5gE8c5
         gouBrkp+lNm4BJNR27rYO8mAMOeZIFOz4u4tE=
Date: Tue, 13 Apr 2010 13:49:35 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add USHRT_MAX, SHRT_MAX, SHRT_MIN
Message-ID: <20100413054935.GA4366@cr0.nay.redhat.com>
References: <20100413215206.GA17131@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100413215206.GA17131@x200>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 12:52:06AM +0300, Alexey Dobriyan wrote:
>* C99 knows about USHRT_MAX/SHRT_MAX/SHRT_MIN, not USHORT_MAX/SHORT_MAX/SHORT_MIN.

This doesn't hurt much, but it is reasonable to make this change.

>* Make SHRT_MIN of type s16, not int, for consistency.
>
>Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!


>---
>
> drivers/scsi/fcoe/fcoe.c              |    2 +-
> drivers/scsi/mpt2sas/mpt2sas_base.c   |    2 +-
> drivers/scsi/mpt2sas/mpt2sas_config.c |    2 +-
> drivers/vhost/vhost.c                 |    2 +-
> fs/nfs/super.c                        |    4 ++--
> fs/nfsd/nfsctl.c                      |    4 ++--
> fs/ocfs2/blockcheck.c                 |    4 ++--
> include/linux/kernel.h                |    6 +++---
> include/linux/sched.h                 |    2 +-
> include/net/ip.h                      |    6 +++---
> include/net/ipv6.h                    |    6 +++---
> ipc/msg.c                             |   12 ++++++------
> ipc/util.c                            |    4 ++--
> lib/vsprintf.c                        |    2 +-
> net/9p/protocol.c                     |    2 +-
> net/dccp/options.c                    |    2 +-
> net/ipv4/udp.c                        |    8 ++++----
> net/mac80211/sta_info.c               |    2 +-
> net/sunrpc/rpcb_clnt.c                |    2 +-
> 19 files changed, 37 insertions(+), 37 deletions(-)
>
>--- a/drivers/scsi/fcoe/fcoe.c
>+++ b/drivers/scsi/fcoe/fcoe.c
>@@ -683,7 +683,7 @@ static int fcoe_shost_config(struct fc_lport *lport, struct Scsi_Host *shost,
> 	}
> 
> 	if (!lport->vport)
>-		fc_host_max_npiv_vports(lport->host) = USHORT_MAX;
>+		fc_host_max_npiv_vports(lport->host) = USHRT_MAX;
> 
> 	snprintf(fc_host_symbolic_name(lport->host), FC_SYMBOLIC_NAME_SIZE,
> 		 "%s v%s over %s", FCOE_NAME, FCOE_VERSION,
>--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
>+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
>@@ -3714,7 +3714,7 @@ _base_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
> 		if (ioc->config_cmds.status & MPT2_CMD_PENDING) {
> 			ioc->config_cmds.status |= MPT2_CMD_RESET;
> 			mpt2sas_base_free_smid(ioc, ioc->config_cmds.smid);
>-			ioc->config_cmds.smid = USHORT_MAX;
>+			ioc->config_cmds.smid = USHRT_MAX;
> 			complete(&ioc->config_cmds.done);
> 		}
> 		break;
>--- a/drivers/scsi/mpt2sas/mpt2sas_config.c
>+++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
>@@ -258,7 +258,7 @@ mpt2sas_config_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
> #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
> 	_config_display_some_debug(ioc, smid, "config_done", mpi_reply);
> #endif
>-	ioc->config_cmds.smid = USHORT_MAX;
>+	ioc->config_cmds.smid = USHRT_MAX;
> 	complete(&ioc->config_cmds.done);
> 	return 1;
> }
>--- a/drivers/vhost/vhost.c
>+++ b/drivers/vhost/vhost.c
>@@ -802,7 +802,7 @@ static unsigned get_indirect(struct vhost_dev *dev, struct vhost_virtqueue *vq,
> 	count = indirect->len / sizeof desc;
> 	/* Buffers are chained via a 16 bit next field, so
> 	 * we can have at most 2^16 of these. */
>-	if (count > USHORT_MAX + 1) {
>+	if (count > USHRT_MAX + 1) {
> 		vq_err(vq, "Indirect buffer length too big: %d\n",
> 		       indirect->len);
> 		return -E2BIG;
>--- a/fs/nfs/super.c
>+++ b/fs/nfs/super.c
>@@ -1064,7 +1064,7 @@ static int nfs_parse_mount_options(char *raw,
> 				goto out_nomem;
> 			rc = strict_strtoul(string, 10, &option);
> 			kfree(string);
>-			if (rc != 0 || option > USHORT_MAX)
>+			if (rc != 0 || option > USHRT_MAX)
> 				goto out_invalid_value;
> 			mnt->nfs_server.port = option;
> 			break;
>@@ -1185,7 +1185,7 @@ static int nfs_parse_mount_options(char *raw,
> 				goto out_nomem;
> 			rc = strict_strtoul(string, 10, &option);
> 			kfree(string);
>-			if (rc != 0 || option > USHORT_MAX)
>+			if (rc != 0 || option > USHRT_MAX)
> 				goto out_invalid_value;
> 			mnt->mount_server.port = option;
> 			break;
>--- a/fs/nfsd/nfsctl.c
>+++ b/fs/nfsd/nfsctl.c
>@@ -995,7 +995,7 @@ static ssize_t __write_ports_addxprt(char *buf)
> 	if (sscanf(buf, "%15s %4u", transport, &port) != 2)
> 		return -EINVAL;
> 
>-	if (port < 1 || port > USHORT_MAX)
>+	if (port < 1 || port > USHRT_MAX)
> 		return -EINVAL;
> 
> 	err = nfsd_create_serv();
>@@ -1037,7 +1037,7 @@ static ssize_t __write_ports_delxprt(char *buf)
> 	if (sscanf(&buf[1], "%15s %4u", transport, &port) != 2)
> 		return -EINVAL;
> 
>-	if (port < 1 || port > USHORT_MAX || nfsd_serv == NULL)
>+	if (port < 1 || port > USHRT_MAX || nfsd_serv == NULL)
> 		return -EINVAL;
> 
> 	xprt = svc_find_xprt(nfsd_serv, transport, AF_UNSPEC, port);
>--- a/fs/ocfs2/blockcheck.c
>+++ b/fs/ocfs2/blockcheck.c
>@@ -403,7 +403,7 @@ void ocfs2_block_check_compute(void *data, size_t blocksize,
> 	 * No ecc'd ocfs2 structure is larger than 4K, so ecc will be no
> 	 * larger than 16 bits.
> 	 */
>-	BUG_ON(ecc > USHORT_MAX);
>+	BUG_ON(ecc > USHRT_MAX);
> 
> 	bc->bc_crc32e = cpu_to_le32(crc);
> 	bc->bc_ecc = cpu_to_le16((u16)ecc);
>@@ -508,7 +508,7 @@ void ocfs2_block_check_compute_bhs(struct buffer_head **bhs, int nr,
> 	 * No ecc'd ocfs2 structure is larger than 4K, so ecc will be no
> 	 * larger than 16 bits.
> 	 */
>-	BUG_ON(ecc > USHORT_MAX);
>+	BUG_ON(ecc > USHRT_MAX);
> 
> 	bc->bc_crc32e = cpu_to_le32(crc);
> 	bc->bc_ecc = cpu_to_le16((u16)ecc);
>--- a/include/linux/kernel.h
>+++ b/include/linux/kernel.h
>@@ -22,9 +22,9 @@
> extern const char linux_banner[];
> extern const char linux_proc_banner[];
> 
>-#define USHORT_MAX	((u16)(~0U))
>-#define SHORT_MAX	((s16)(USHORT_MAX>>1))
>-#define SHORT_MIN	(-SHORT_MAX - 1)
>+#define USHRT_MAX	((u16)(~0U))
>+#define SHRT_MAX	((s16)(USHRT_MAX>>1))
>+#define SHRT_MIN	((s16)(-SHRT_MAX - 1))
> #define INT_MAX		((int)(~0U>>1))
> #define INT_MIN		(-INT_MAX - 1)
> #define UINT_MAX	(~0U)
>--- a/include/linux/sched.h
>+++ b/include/linux/sched.h
>@@ -379,7 +379,7 @@ struct user_namespace;
>  * 1-3 now and depends on arch. We use "5" as safe margin, here.
>  */
> #define MAPCOUNT_ELF_CORE_MARGIN	(5)
>-#define DEFAULT_MAX_MAP_COUNT	(USHORT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
>+#define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
> 
> extern int sysctl_max_map_count;
> 
>--- a/include/net/ip.h
>+++ b/include/net/ip.h
>@@ -352,11 +352,11 @@ enum ip_defrag_users {
> 	IP_DEFRAG_LOCAL_DELIVER,
> 	IP_DEFRAG_CALL_RA_CHAIN,
> 	IP_DEFRAG_CONNTRACK_IN,
>-	__IP_DEFRAG_CONNTRACK_IN_END	= IP_DEFRAG_CONNTRACK_IN + USHORT_MAX,
>+	__IP_DEFRAG_CONNTRACK_IN_END	= IP_DEFRAG_CONNTRACK_IN + USHRT_MAX,
> 	IP_DEFRAG_CONNTRACK_OUT,
>-	__IP_DEFRAG_CONNTRACK_OUT_END	= IP_DEFRAG_CONNTRACK_OUT + USHORT_MAX,
>+	__IP_DEFRAG_CONNTRACK_OUT_END	= IP_DEFRAG_CONNTRACK_OUT + USHRT_MAX,
> 	IP_DEFRAG_CONNTRACK_BRIDGE_IN,
>-	__IP_DEFRAG_CONNTRACK_BRIDGE_IN = IP_DEFRAG_CONNTRACK_BRIDGE_IN + USHORT_MAX,
>+	__IP_DEFRAG_CONNTRACK_BRIDGE_IN = IP_DEFRAG_CONNTRACK_BRIDGE_IN + USHRT_MAX,
> 	IP_DEFRAG_VS_IN,
> 	IP_DEFRAG_VS_OUT,
> 	IP_DEFRAG_VS_FWD
>--- a/include/net/ipv6.h
>+++ b/include/net/ipv6.h
>@@ -354,11 +354,11 @@ struct inet_frag_queue;
> enum ip6_defrag_users {
> 	IP6_DEFRAG_LOCAL_DELIVER,
> 	IP6_DEFRAG_CONNTRACK_IN,
>-	__IP6_DEFRAG_CONNTRACK_IN	= IP6_DEFRAG_CONNTRACK_IN + USHORT_MAX,
>+	__IP6_DEFRAG_CONNTRACK_IN	= IP6_DEFRAG_CONNTRACK_IN + USHRT_MAX,
> 	IP6_DEFRAG_CONNTRACK_OUT,
>-	__IP6_DEFRAG_CONNTRACK_OUT	= IP6_DEFRAG_CONNTRACK_OUT + USHORT_MAX,
>+	__IP6_DEFRAG_CONNTRACK_OUT	= IP6_DEFRAG_CONNTRACK_OUT + USHRT_MAX,
> 	IP6_DEFRAG_CONNTRACK_BRIDGE_IN,
>-	__IP6_DEFRAG_CONNTRACK_BRIDGE_IN = IP6_DEFRAG_CONNTRACK_BRIDGE_IN + USHORT_MAX,
>+	__IP6_DEFRAG_CONNTRACK_BRIDGE_IN = IP6_DEFRAG_CONNTRACK_BRIDGE_IN + USHRT_MAX,
> };
> 
> struct ip6_create_arg {
>--- a/ipc/msg.c
>+++ b/ipc/msg.c
>@@ -345,19 +345,19 @@ copy_msqid_to_user(void __user *buf, struct msqid64_ds *in, int version)
> 		out.msg_rtime		= in->msg_rtime;
> 		out.msg_ctime		= in->msg_ctime;
> 
>-		if (in->msg_cbytes > USHORT_MAX)
>-			out.msg_cbytes	= USHORT_MAX;
>+		if (in->msg_cbytes > USHRT_MAX)
>+			out.msg_cbytes	= USHRT_MAX;
> 		else
> 			out.msg_cbytes	= in->msg_cbytes;
> 		out.msg_lcbytes		= in->msg_cbytes;
> 
>-		if (in->msg_qnum > USHORT_MAX)
>-			out.msg_qnum	= USHORT_MAX;
>+		if (in->msg_qnum > USHRT_MAX)
>+			out.msg_qnum	= USHRT_MAX;
> 		else
> 			out.msg_qnum	= in->msg_qnum;
> 
>-		if (in->msg_qbytes > USHORT_MAX)
>-			out.msg_qbytes	= USHORT_MAX;
>+		if (in->msg_qbytes > USHRT_MAX)
>+			out.msg_qbytes	= USHRT_MAX;
> 		else
> 			out.msg_qbytes	= in->msg_qbytes;
> 		out.msg_lqbytes		= in->msg_qbytes;
>--- a/ipc/util.c
>+++ b/ipc/util.c
>@@ -124,8 +124,8 @@ void ipc_init_ids(struct ipc_ids *ids)
> 	ids->seq = 0;
> 	{
> 		int seq_limit = INT_MAX/SEQ_MULTIPLIER;
>-		if (seq_limit > USHORT_MAX)
>-			ids->seq_max = USHORT_MAX;
>+		if (seq_limit > USHRT_MAX)
>+			ids->seq_max = USHRT_MAX;
> 		 else
> 		 	ids->seq_max = seq_limit;
> 	}
>--- a/lib/vsprintf.c
>+++ b/lib/vsprintf.c
>@@ -1979,7 +1979,7 @@ int vsscanf(const char *buf, const char *fmt, va_list args)
> 		{
> 			char *s = (char *)va_arg(args, char *);
> 			if (field_width == -1)
>-				field_width = SHORT_MAX;
>+				field_width = SHRT_MAX;
> 			/* first, skip leading white space in buffer */
> 			str = skip_spaces(str);
> 
>--- a/net/9p/protocol.c
>+++ b/net/9p/protocol.c
>@@ -393,7 +393,7 @@ p9pdu_vwritef(struct p9_fcall *pdu, int proto_version, const char *fmt,
> 				const char *sptr = va_arg(ap, const char *);
> 				int16_t len = 0;
> 				if (sptr)
>-					len = MIN(strlen(sptr), USHORT_MAX);
>+					len = MIN(strlen(sptr), USHRT_MAX);
> 
> 				errcode = p9pdu_writef(pdu, proto_version,
> 								"w", len);
>--- a/net/dccp/options.c
>+++ b/net/dccp/options.c
>@@ -296,7 +296,7 @@ static inline u8 dccp_ndp_len(const u64 ndp)
> {
> 	if (likely(ndp <= 0xFF))
> 		return 1;
>-	return likely(ndp <= USHORT_MAX) ? 2 : (ndp <= UINT_MAX ? 4 : 6);
>+	return likely(ndp <= USHRT_MAX) ? 2 : (ndp <= UINT_MAX ? 4 : 6);
> }
> 
> int dccp_insert_option(struct sock *sk, struct sk_buff *skb,
>--- a/net/ipv4/udp.c
>+++ b/net/ipv4/udp.c
>@@ -1676,8 +1676,8 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
> 			return -ENOPROTOOPT;
> 		if (val != 0 && val < 8) /* Illegal coverage: use default (8) */
> 			val = 8;
>-		else if (val > USHORT_MAX)
>-			val = USHORT_MAX;
>+		else if (val > USHRT_MAX)
>+			val = USHRT_MAX;
> 		up->pcslen = val;
> 		up->pcflag |= UDPLITE_SEND_CC;
> 		break;
>@@ -1690,8 +1690,8 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
> 			return -ENOPROTOOPT;
> 		if (val != 0 && val < 8) /* Avoid silly minimal values.       */
> 			val = 8;
>-		else if (val > USHORT_MAX)
>-			val = USHORT_MAX;
>+		else if (val > USHRT_MAX)
>+			val = USHRT_MAX;
> 		up->pcrlen = val;
> 		up->pcflag |= UDPLITE_RECV_CC;
> 		break;
>--- a/net/mac80211/sta_info.c
>+++ b/net/mac80211/sta_info.c
>@@ -250,7 +250,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
> 	skb_queue_head_init(&sta->tx_filtered);
> 
> 	for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
>-		sta->last_seq_ctrl[i] = cpu_to_le16(USHORT_MAX);
>+		sta->last_seq_ctrl[i] = cpu_to_le16(USHRT_MAX);
> 
> #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
> 	printk(KERN_DEBUG "%s: Allocated STA %pM\n",
>--- a/net/sunrpc/rpcb_clnt.c
>+++ b/net/sunrpc/rpcb_clnt.c
>@@ -783,7 +783,7 @@ static int rpcb_dec_getport(struct rpc_rqst *req, __be32 *p,
> 	port = ntohl(*p);
> 	dprintk("RPC: %5u PMAP_%s result: %lu\n", task->tk_pid,
> 			task->tk_msg.rpc_proc->p_name, port);
>-	if (unlikely(port > USHORT_MAX))
>+	if (unlikely(port > USHRT_MAX))
> 		return -EIO;
> 
> 	rpcb->r_port = port;
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
