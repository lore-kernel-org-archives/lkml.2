Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab2HWGAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 02:00:08 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:39617 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab2HWGAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 02:00:00 -0400
Message-ID: <5035C6D5.6020608@linux.vnet.ibm.com>
Date: Thu, 23 Aug 2012 13:59:49 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        coreteam@netfilter.org, netfilter@vger.kernel.org,
        netfilter-devel@vger.kernel.org
CC: David Miller <davem@davemloft.net>, kaber@trash.net, pablo@netfilter.org
Subject: [PATCH 0/2] netfilter: code refine for using new interface 'list_for_each_entry_continue_rcu'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12082305-5816-0000-0000-0000041C7B1D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

Since 'list_for_each_continue_rcu' has been replaced with the new interface
'list_for_each_entry_continue_rcu' by commit 6705e86, we can no longer saving
code by passing 'list_head' to nf_iterate() and nf_queue() any more.

This patch set will pass 'nf_hook_ops' instead of 'list_head' to nf_iterate()
and nf_queue() as the parameter and saving some code.

Tested:
	add rule to iptables and check result by ping.
	nfqnl_test which is a test utility of libnetfilter_queue.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 b/net/netfilter/core.c         |   24 ++++++++++--------------
 b/net/netfilter/nf_internals.h |    2 +-
 b/net/netfilter/nf_queue.c     |    6 +++---
 net/netfilter/core.c           |    4 ++--
 net/netfilter/nf_internals.h   |    2 +-
 net/netfilter/nf_queue.c       |    8 ++++----
 6 files changed, 21 insertions(+), 25 deletions(-)

