Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab1DMP4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:56:11 -0400
Received: from kroah.org ([198.145.64.141]:54642 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343Ab1DMP4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:56:07 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 08:51:50 2011
Message-Id: <20110413155150.638980872@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 08:51:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Moritz Muehlenhoff <jmm@debian.org>
Subject: [71/74] CAN: Use inode instead of kernel address for /proc file
In-Reply-To: <20110413155406.GA22568@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit 9f260e0efa4766e56d0ac14f1aeea6ee5eb8fe83 upstream.

Since the socket address is just being used as a unique identifier, its
inode number is an alternative that does not leak potentially sensitive
information.

CC-ing stable because MITRE has assigned CVE-2010-4565 to the issue.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Moritz Muehlenhoff <jmm@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/can/bcm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -124,7 +124,7 @@ struct bcm_sock {
 	struct list_head tx_ops;
 	unsigned long dropped_usr_msgs;
 	struct proc_dir_entry *bcm_proc_read;
-	char procname [20]; /* pointer printed in ASCII with \0 */
+	char procname [32]; /* inode number in decimal with \0 */
 };
 
 static inline struct bcm_sock *bcm_sk(const struct sock *sk)
@@ -1519,7 +1519,7 @@ static int bcm_connect(struct socket *so
 
 	if (proc_dir) {
 		/* unique socket address as filename */
-		sprintf(bo->procname, "%p", sock);
+		sprintf(bo->procname, "%lu", sock_i_ino(sk));
 		bo->bcm_proc_read = proc_create_data(bo->procname, 0644,
 						     proc_dir,
 						     &bcm_proc_fops, sk);


