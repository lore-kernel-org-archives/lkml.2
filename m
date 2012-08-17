Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab2HQEdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 00:33:39 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:47699 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab2HQEdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 00:33:35 -0400
Message-ID: <502DC992.4040304@linux.vnet.ibm.com>
Date: Fri, 17 Aug 2012 12:33:22 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org,
        linux-mm@kvack.org, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org
CC: neilb@suse.de, catalin.marinas@arm.com, David Miller <davem@davemloft.net>,
        kaber@trash.net, pablo@netfilter.org,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 0/3] raid, kmemleak, netfilter: replace list_for_each_continue_rcu
 with new interface
References: <502CB91E.4050304@linux.vnet.ibm.com>
In-Reply-To: <502CB91E.4050304@linux.vnet.ibm.com>
X-Forwarded-Message-Id: <502CB91E.4050304@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12081704-1396-0000-0000-000001B98899
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

This patch set will replace the list_for_each_continue_rcu with the new
interface list_for_each_entry_continue_rcu, so we could remove the old
one later.

Changed:
	raid:		in "next_active_rdev"
	kmemleak:	in "kmemleak_seq_next"
	netfilter:	in "nf_iterate"	

Tested:
	raid:
		mdadm command with an internal bitmap.
	kmemleak:
		enable kmemleak and check the info it captured.
	netfilter:
		add rule to iptables and check result by ping.
		nfqnl_test which is a test utility of libnetfilter_queue.

	All testing are using printk to make sure the code we want test
	was invoked.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 drivers/md/bitmap.c  |    9 +++------
 mm/kmemleak.c        |    6 ++----
 net/netfilter/core.c |   11 +++++++----
 3 files changed, 12 insertions(+), 14 deletions(-)


