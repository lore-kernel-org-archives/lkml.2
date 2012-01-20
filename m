Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab2ATO5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 09:57:35 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:14971 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830Ab2ATO5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 09:57:33 -0500
From: Glauber Costa <glommer@parallels.com>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        cgroups@vger.kernel.org
Subject: [PATCH 0/3] fixes for tcp memcg 
Date: Fri, 20 Jan 2012 18:57:13 +0400
Message-Id: <1327071436-20763-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Please consider adding the following fixes to 
your tree.

The first is a remaining build bug, that managed to survive
the bunch of randconfigs I tested with from my last fix (It
still breaks without CONFIG_NET, which is likely selected
by a bunch of other options).

The other two patches are a fix for a bug I verified in
my followup testings in the controller itself, that causes
a charge/uncharge mismatch under certain circumnstances.

Thanks

Glauber Costa (3):
  net: fix socket memcg build with !CONFIG_NET
  cgroup: make sure memcg margin is 0 when over limit
  net: introduce res_counter_charge_nofail() for socket allocations

 include/linux/res_counter.h |   11 ++++++++++-
 include/net/sock.h          |   12 +++++-------
 kernel/res_counter.c        |   25 +++++++++++++++++++++++++
 mm/memcontrol.c             |    4 ++--
 net/core/sock.c             |    4 ++--
 5 files changed, 44 insertions(+), 12 deletions(-)

-- 
1.7.7.4

