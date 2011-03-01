Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab1CAICD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 03:02:03 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52737 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755208Ab1CAICB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 03:02:01 -0500
Message-ID: <4D6CA843.3090103@cn.fujitsu.com>
Date: Tue, 01 Mar 2011 16:03:15 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/4] rcu: don't assume the size of struct rcu_head
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-01 16:00:51,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-01 16:00:51,
	Serialize complete at 2011-03-01 16:00:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We always keep the struct rcu_head very small, but we may change it in future
or under some CONFIGs.

There are some other systems may assume the size of struct rcu_head as 2 * sizeof(long).
These assumptions obstruct us to add debug information or priority information
to struct rcu_head. It is time to fix them.

It is glad that I just find 3 places which need to be fixed. These 4 patches
are just cleanup patches when the size of struct rcu_head == 2 * sizeof(long).
NO overhead added and NO behavior changed.
Even when the size of struct rcu_head becomes larger, only slub is changed a little.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---

