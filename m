Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab2C2GYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 02:24:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33541 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab2C2GYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 02:24:39 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F73FF9D.4090809@jp.fujitsu.com>
Date: Thu, 29 Mar 2012 15:22:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, davem@davemloft.net
Subject: [BUGFIX][PATCH 0/3] memcg: tcp memcontrol fixes.
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series is 3 bugfixes for memcg's kmem.tcp memory controller.
Maybe this should go via network tree. (CC akpm for noticing an ugly change in res_counter.)

All patches are generated onto today linus's git tree.

Brief description:

Patch  1/3 .... tcp memcontrol doesn't see memcg's use_hierarchy value. Fix it.

Patch  2/3 and 3/3 .... 
                Because tcp memcontrol doesn't do any accounting when limit=RESOUCE_MAX,
	        there will be account leakage when limit is changed. This can trigger
                WARN_ON() in res_counter which checks usage >= 0.

Patch 2/3  .... don't call static_key_slow_dec(&memcg_socket_limit_enabled) until
                a cgroup under accounted is destroyed.

Patch 3/3  .... add res_counter_uncharge_nowarn() to ignore leakage.

Thanks,
-Kame

