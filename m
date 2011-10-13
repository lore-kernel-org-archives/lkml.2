Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab1JMWIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 18:08:11 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:44025 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755086Ab1JMWIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 18:08:09 -0400
Message-ID: <4E976147.9030000@xenotime.net>
Date: Thu, 13 Oct 2011 15:08:07 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Faisal Latif <faisal.latif@intel.com>,
        Linux RDMA <linux-rdma@vger.kernel.org>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: [PATCH -next] infiniband: fix printk format in hw/nes_cm.c
References: <20111013181606.a204565fad9caaa0fe680b75@canb.auug.org.au>
In-Reply-To: <20111013181606.a204565fad9caaa0fe680b75@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warning seen on x86_64:
drivers/infiniband/hw/nes/nes_cm.c:3190:2: warning: format '%zu' expects type 'size_t', but argument 11 has type 'int'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Faisal Latif <faisal.latif@intel.com>
---
 drivers/infiniband/hw/nes/nes_cm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- next-2011-1013.orig/drivers/infiniband/hw/nes/nes_cm.c
+++ next-2011-1013/drivers/infiniband/hw/nes/nes_cm.c
@@ -3189,7 +3189,7 @@ int nes_accept(struct iw_cm_id *cm_id, s
 
 	nes_debug(NES_DBG_CM, "QP%u, Destination IP = 0x%08X:0x%04X, local = "
 		  "0x%08X:0x%04X, rcv_nxt=0x%08X, snd_nxt=0x%08X, mpa + "
-		  "private data length=%zu.\n", nesqp->hwqp.qp_id,
+		  "private data length=%u.\n", nesqp->hwqp.qp_id,
 		  ntohl(cm_id->remote_addr.sin_addr.s_addr),
 		  ntohs(cm_id->remote_addr.sin_port),
 		  ntohl(cm_id->local_addr.sin_addr.s_addr),
