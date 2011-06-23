Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab1FWCsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 22:48:03 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37458 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170Ab1FWCsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 22:48:00 -0400
Date: Thu, 23 Jun 2011 12:47:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Rose <gregory.v.rose@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: linux-next: manual merge of the wireless tree with the net tree
Message-Id: <20110623124755.f4e1a7e1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
include/linux/netlink.h between commit c7ac8679bec9 ("rtnetlink: Compute
and store minimum ifinfo dump size") from the net tree and commit
670dc2833d14 ("netlink: advertise incomplete dumps") from the wireless
tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/netlink.h
index fdd0188,8d1bcec..0000000
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@@ -221,8 -221,8 +222,9 @@@ struct netlink_callback 
  	int			(*dump)(struct sk_buff * skb,
  					struct netlink_callback *cb);
  	int			(*done)(struct netlink_callback *cb);
 -	int			family;
 +	u16			family;
 +	u16			min_dump_alloc;
+ 	unsigned int		prev_seq, seq;
  	long			args[6];
  };
  
