Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835Ab0IGPzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 11:55:44 -0400
Received: from mail.perches.com ([173.55.12.10]:1508 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757768Ab0IGPzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 11:55:41 -0400
Subject: [PATCH V2 net-next] include/net/raw.h: Convert raw_seq_private
 macro to inline
From: Joe Perches <joe@perches.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: David Miller <davem@davemloft.net>, trivial@kernel.org,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100907153721.GA6419@elliptictech.com>
References: <cover.1283650107.git.joe@perches.com>
	 <dd5d79c3aa9f2cffbca1a8d4a9163b0d6a9492a9.1283650107.git.joe@perches.com>
	 <20100906.183036.68150190.davem@davemloft.net>
	 <20100906.184749.214227378.davem@davemloft.net>
	 <1283835677.23280.108.camel@Joe-Laptop>
	 <20100907153721.GA6419@elliptictech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Sep 2010 08:55:38 -0700
Message-ID: <1283874938.23280.141.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/net/raw.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/net/raw.h b/include/net/raw.h
index 43c5750..42ce6fe 100644
--- a/include/net/raw.h
+++ b/include/net/raw.h
@@ -45,7 +45,10 @@ struct raw_iter_state {
 	struct raw_hashinfo *h;
 };
 
-#define raw_seq_private(seq) ((struct raw_iter_state *)(seq)->private)
+static inline struct raw_iter_state *raw_seq_private(struct seq_file *seq)
+{
+	return seq->private;
+}
 void *raw_seq_start(struct seq_file *seq, loff_t *pos);
 void *raw_seq_next(struct seq_file *seq, void *v, loff_t *pos);
 void raw_seq_stop(struct seq_file *seq, void *v);


