Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab2EKSBH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:01:07 -0400
Received: from mx2.parallels.com ([64.131.90.16]:44974 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932949Ab2EKSBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:01:03 -0400
Message-ID: <4FAD531D.6030007@parallels.com>
Date: Fri, 11 May 2012 14:57:49 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <devel@openvz.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2 04/29] slub: always get the cache from its page in
 kfree
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-5-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205111251420.31049@router.home>
In-Reply-To: <alpine.DEB.2.00.1205111251420.31049@router.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.105.248.83]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 02:53 PM, Christoph Lameter wrote:
> On Fri, 11 May 2012, Glauber Costa wrote:
>
>> struct page already have this information. If we start chaining
>> caches, this information will always be more trustworthy than
>> whatever is passed into the function
>
> Other allocators may not have that information and this patch may
> cause bugs to go unnoticed if the caller specifies the wrong slab cache.
>
> Adding a VM_BUG_ON may be useful to make sure that kmem_cache_free is
> always passed the correct slab cache.

Well, problem is , it isn't always passed the "correct" slab cache.
At least not after this series, since we'll have child caches associated 
with the main cache.

So we'll pass, for instance, kmem_cache_free(dentry_cache...), but will 
in fact free from the memcg copy of the dentry cache.

We can, of course, verify if the cache at least belongs to the same 
"family". But that's quite expensive.
