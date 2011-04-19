Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab1DSURI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:17:08 -0400
Received: from kroah.org ([198.145.64.141]:47644 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545Ab1DSURF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:05 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:45 2011
Message-Id: <20110419201045.386193187@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        James Chapman <jchapman@katalix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [21/70] l2tp: fix possible oops on l2tp_eth module unload
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: James Chapman <jchapman@katalix.com>

[ Upstream commit 8aa525a9340da4227797a06221ca08399006635f ]

A struct used in the l2tp_eth driver for registering network namespace
ops was incorrectly marked as __net_initdata, leading to oops when
module unloaded.

BUG: unable to handle kernel paging request at ffffffffa00ec098
IP: [<ffffffff8123dbd8>] ops_exit_list+0x7/0x4b
PGD 142d067 PUD 1431063 PMD 195da8067 PTE 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/module/l2tp_eth/refcnt
Call Trace:
 [<ffffffff8123dc94>] ? unregister_pernet_operations+0x32/0x93
 [<ffffffff8123dd20>] ? unregister_pernet_device+0x2b/0x38
 [<ffffffff81068b6e>] ? sys_delete_module+0x1b8/0x222
 [<ffffffff810c7300>] ? do_munmap+0x254/0x318
 [<ffffffff812c64e5>] ? page_fault+0x25/0x30
 [<ffffffff812c6952>] ? system_call_fastpath+0x16/0x1b

Signed-off-by: James Chapman <jchapman@katalix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/l2tp/l2tp_eth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -283,7 +283,7 @@ static __net_init int l2tp_eth_init_net(
 	return 0;
 }
 
-static __net_initdata struct pernet_operations l2tp_eth_net_ops = {
+static struct pernet_operations l2tp_eth_net_ops = {
 	.init = l2tp_eth_init_net,
 	.id   = &l2tp_eth_net_id,
 	.size = sizeof(struct l2tp_eth_net),


