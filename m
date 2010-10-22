Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab0JVBTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 21:19:48 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:60090 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab0JVBTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 21:19:47 -0400
Date: Fri, 22 Oct 2010 12:19:43 +1100
From: Stephen Rothwell <sfr@au1.ibm.com>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jesse Gross <jesse@nicira.com>
Subject: linux-next: manual merge of the net tree with Linus' tree
Message-Id: <20101022121943.120aa4f2.sfr@au1.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got a conflict in net/core/dev.c
between commit cf66ba58b5cb8b1526e9dd2fb96ff8db048d4d44 ("netdev: Add
tracepoints to netdev layer") from Linus' tree and commits
05532121da0728eaedac2a0a5c3cecad3a95d765 ("net: 802.1q: make
vlan_hwaccel_do_receive() return void") and
3701e51382a026cba10c60b03efabe534fba4ca4 ("vlan: Centralize handling of
hardware acceleration") from the net tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/core/dev.c
index 154e25e,6d4218c..0000000
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@@ -128,9 -128,8 +128,10 @@@
  #include <linux/jhash.h>
  #include <linux/random.h>
  #include <trace/events/napi.h>
 +#include <trace/events/net.h>
 +#include <trace/events/skb.h>
  #include <linux/pci.h>
+ #include <linux/inetdevice.h>
  
  #include "net-sysfs.h"
  
@@@ -2835,10 -2898,6 +2905,8 @@@ static int __netif_receive_skb(struct s
  	if (!netdev_tstamp_prequeue)
  		net_timestamp_check(skb);
  
 +	trace_netif_receive_skb(skb);
- 	if (vlan_tx_tag_present(skb) && vlan_hwaccel_do_receive(skb))
- 		return NET_RX_SUCCESS;
 +
  	/* if we've gotten here through NAPI, check netpoll */
  	if (netpoll_receive_skb(skb))
  		return NET_RX_DROP;
