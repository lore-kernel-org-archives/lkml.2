Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab2JRIah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 04:30:37 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:8494 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab2JRIad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 04:30:33 -0400
Message-ID: <507FBE1B.4080906@huawei.com>
Date: Thu, 18 Oct 2012 16:30:19 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH 5/6] memcg: make mem_cgroup_reparent_charges non failing
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz> <1350480648-10905-6-git-send-email-mhocko@suse.cz>
In-Reply-To: <1350480648-10905-6-git-send-email-mhocko@suse.cz>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static int mem_cgroup_force_empty_write(struct cgroup *cont, unsigned int event)
> @@ -5013,13 +5011,9 @@ free_out:
>  static int mem_cgroup_pre_destroy(struct cgroup *cont)
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
> -	int ret;
>  
> -	css_get(&memcg->css);
> -	ret = mem_cgroup_reparent_charges(memcg);
> -	css_put(&memcg->css);
> -
> -	return ret;
> +	mem_cgroup_reparent_charges(memcg);
> +	return 0;
>  }
>  

Why don't you make pre_destroy() return void?

