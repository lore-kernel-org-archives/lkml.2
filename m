Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab1AIDnD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 22:43:03 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27643 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab1AIDnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 22:43:01 -0500
Date: Sat, 8 Jan 2011 19:39:21 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, Linus <torvalds@linux-foundation.org>
Cc: netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH 4/6] net/sock.h: make some fields private to fix kernel-doc
 warning(s)
Message-Id: <20110108193921.e03ca09e.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix new kernel-doc notation warning in sock.h by annotating skc_dontcopy_*
as private fields.

Warning(include/net/sock.h:163): No description found for parameter 'skc_dontcopy_end[0]'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/net/sock.h |    4 ++++
 1 file changed, 4 insertions(+)

--- lnx0107.orig/include/net/sock.h
+++ lnx0107/include/net/sock.h
@@ -152,14 +152,18 @@ struct sock_common {
 	 * fields between dontcopy_begin/dontcopy_end
 	 * are not copied in sock_copy()
 	 */
+	/* private: */
 	int			skc_dontcopy_begin[0];
+	/* public: */
 	union {
 		struct hlist_node	skc_node;
 		struct hlist_nulls_node skc_nulls_node;
 	};
 	int			skc_tx_queue_mapping;
 	atomic_t		skc_refcnt;
+	/* private: */
 	int                     skc_dontcopy_end[0];
+	/* public: */
 };
 
 /**
