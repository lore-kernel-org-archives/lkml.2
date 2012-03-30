Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965923Ab2C3VUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:20:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935995Ab2C3VUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:20:17 -0400
Message-Id: <20120330194837.977124166@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mike Christie <michaelc@cs.wisc.edu>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 070/175] SCSI: iscsi: fix setting of pid from netlink skb
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Christie <michaelc@cs.wisc.edu>

commit df1c7baba1b7b3053950f3845a6575aca47ba9ce upstream.

NETLINK_CREDS's pid now returns 0, so I guess we are supposed to
be using NETLINK_CB. This changed while the patch to export the
pid was getting merged upstream, so it was not noticed until both
the network and iscsi changes were in the same tree.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/scsi_transport_iscsi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1941,7 +1941,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 	switch (nlh->nlmsg_type) {
 	case ISCSI_UEVENT_CREATE_SESSION:
 		err = iscsi_if_create_session(priv, ep, ev,
-					      NETLINK_CREDS(skb)->pid,
+					      NETLINK_CB(skb).pid,
 					      ev->u.c_session.initial_cmdsn,
 					      ev->u.c_session.cmds_max,
 					      ev->u.c_session.queue_depth);
@@ -1954,7 +1954,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 		}
 
 		err = iscsi_if_create_session(priv, ep, ev,
-					NETLINK_CREDS(skb)->pid,
+					NETLINK_CB(skb).pid,
 					ev->u.c_bound_session.initial_cmdsn,
 					ev->u.c_bound_session.cmds_max,
 					ev->u.c_bound_session.queue_depth);


