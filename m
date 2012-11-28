Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab2K1IjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 03:39:13 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38858 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab2K1IjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 03:39:08 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50B5CD94.5020105@jp.fujitsu.com>
Date: Wed, 28 Nov 2012 17:38:44 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Tejun Heo <htejun@gmail.com>, Glauber Costa <glommer@parallels.com>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [patch v2 2/6] memcg: keep prev's css alive for the whole mem_cgroup_iter
References: <1353955671-14385-1-git-send-email-mhocko@suse.cz> <1353955671-14385-3-git-send-email-mhocko@suse.cz>
In-Reply-To: <1353955671-14385-3-git-send-email-mhocko@suse.cz>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/27 3:47), Michal Hocko wrote:
> css reference counting keeps the cgroup alive even though it has been
> already removed. mem_cgroup_iter relies on this fact and takes a
> reference to the returned group. The reference is then released on the
> next iteration or mem_cgroup_iter_break.
> mem_cgroup_iter currently releases the reference right after it gets the
> last css_id.
> This is correct because neither prev's memcg nor cgroup are accessed
> after then. This will change in the next patch so we need to hold the
> group alive a bit longer so let's move the css_put at the end of the
> function.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


