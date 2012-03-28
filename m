Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab2C1Kqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 06:46:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57710 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757994Ab2C1Kqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 06:46:30 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F72EB84.7080000@jp.fujitsu.com>
Date: Wed, 28 Mar 2012 19:44:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Han Ying <yinghan@google.com>, Glauber Costa <glommer@parallels.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Suleiman Souhlal <suleiman@google.com>
Subject: [RFC][PATCH 0/6 v2] reducing page_cgroup size
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, here is v2 (still RFC again because I changed many parts.)
I'd like to post v3 without 'RFC' tag after Lsf-MM Summit.

This series is for reducing size of 'struct page_cgroup' to 8 bytes.
v2 contains 6 patches and did clean-ups and fixes race in v1 and
adds a trial to integrate struct page_cgroup into struct page.

each patches are...

1/6 ....add methods to access pc->mem_cgroup
2/6 ....add pc_set_mem_cgroup_and_flags() to set ->mem_cgroup and flags by one call.
3/6 ....add PageCgroupReset() for handling a race.
4/6 ....reduce size of struct page_cgroup by removing ->mem_cgroup
5/6 ....remove unnecessary memory barrier
6/6 ....add CONFIG_INTEGRATED_PAGE_CGROUP to place page_cgroup in struct page.

Regards,
-Kame

