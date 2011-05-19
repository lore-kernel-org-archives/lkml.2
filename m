Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab1ESBCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 21:02:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59949 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab1ESBC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 21:02:29 -0400
Date: Thu, 19 May 2011 11:02:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Pirko <jpirko@redhat.com>, David Miller <davem@davemloft.net>,
        <netdev@vger.kernel.org>, Javier Lopez <jlopex@gmail.com>
Subject: linux-next: manual merge of the wireless tree with the net tree
Message-Id: <20110519110221.dbb8c524.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/net/wireless/mac80211_hwsim.c between commit 1c5cae815d19 ("net:
call dev_alloc_name from register_netdevice") from the net tree and
commit 444c7896bf5b ("mac80211_hwsim driver support userspace frame
tx/rx") from the wireless tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/mac80211_hwsim.c
index 9d4a40e,d8ec575..0000000
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@@ -1519,8 -1880,23 +1878,16 @@@ static int __init init_mac80211_hwsim(v
  	if (err < 0)
  		goto failed_mon;
  
 -
 -	err = register_netdevice(hwsim_mon);
 -	if (err < 0)
 -		goto failed_mon;
 -
 -	rtnl_unlock();
 -
+ 	err = hwsim_init_netlink();
+ 	if (err < 0)
+ 		goto failed_nl;
+ 
  	return 0;
  
+ failed_nl:
+ 	printk(KERN_DEBUG "mac80211_hwsim: failed initializing netlink\n");
+ 	return err;
+ 
  failed_mon:
  	rtnl_unlock();
  	free_netdev(hwsim_mon);
