Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab1LIOiM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:38:12 -0500
Received: from mx2.parallels.com ([64.131.90.16]:47944 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab1LIOiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:38:11 -0500
Message-ID: <4EE21D23.4000309@parallels.com>
Date: Fri, 9 Dec 2011 12:37:23 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <lizf@cn.fujitsu.com>,
        <ebiederm@xmission.com>, <davem@davemloft.net>, <gthelen@google.com>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>, <kirill@shutemov.name>,
        <avagin@parallels.com>, <devel@openvz.org>, <eric.dumazet@gmail.com>,
        <cgroups@vger.kernel.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH v8 1/9] Basic kernel memory functionality for the Memory
 Controller
References: <1323120903-2831-1-git-send-email-glommer@parallels.com> <1323120903-2831-2-git-send-email-glommer@parallels.com> <20111209102113.cdb85da8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111209102113.cdb85da8.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2011 11:21 PM, KAMEZAWA Hiroyuki wrote:
> Hm, why you check val != parent->kmem_independent_accounting ?
>
> 	if (parent&&  parent->use_hierarchy)
> 		return -EINVAL;
> ?
>
> BTW, you didn't check this cgroup has children or not.
> I think
>
> 	if (this_cgroup->use_hierarchy&&
>               !list_empty(this_cgroup->childlen))
> 		return -EINVAL;

How about this?

         val = !!val;

         /*
          * This follows the same hierarchy restrictions than
          * mem_cgroup_hierarchy_write()
          */
         if (!parent || !parent->use_hierarchy) {
                 if (list_empty(&cgroup->children))
                         memcg->kmem_independent_accounting = val;
                 else
                         return -EBUSY;
         }
         else
                 return -EINVAL;

         return 0;

