Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab2K1Iws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 03:52:48 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59921 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab2K1Iwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 03:52:47 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50B5D0C8.2010209@jp.fujitsu.com>
Date: Wed, 28 Nov 2012 17:52:24 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Tejun Heo <htejun@gmail.com>, Glauber Costa <glommer@parallels.com>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [patch v2 4/6] memcg: simplify mem_cgroup_iter
References: <1353955671-14385-1-git-send-email-mhocko@suse.cz> <1353955671-14385-5-git-send-email-mhocko@suse.cz>
In-Reply-To: <1353955671-14385-5-git-send-email-mhocko@suse.cz>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/27 3:47), Michal Hocko wrote:
> Current implementation of mem_cgroup_iter has to consider both css and
> memcg to find out whether no group has been found (css==NULL - aka the
> loop is completed) and that no memcg is associated with the found node
> (!memcg - aka css_tryget failed because the group is no longer alive).
> This leads to awkward tweaks like tests for css && !memcg to skip the
> current node.
> 
> It will be much easier if we got rid off css variable altogether and
> only rely on memcg. In order to do that the iteration part has to skip
> dead nodes. This sounds natural to me and as a nice side effect we will
> get a simple invariant that memcg is always alive when non-NULL and all
> nodes have been visited otherwise.
> 
> We could get rid of the surrounding while loop but keep it in for now to
> make review easier. It will go away in the following patch.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

seems nice clean up. I'll ack when I ack 3/6 and we make agreement on that
iterator will skip dead node.

Thanks,
-Kame

