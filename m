Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760886Ab2CNMBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 08:01:08 -0400
Received: from mx2.parallels.com ([64.131.90.16]:60767 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758660Ab2CNMBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 08:01:05 -0400
Message-ID: <4F608820.8080006@parallels.com>
Date: Wed, 14 Mar 2012 15:59:28 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Suleiman Souhlal <suleiman@google.com>
CC: Suleiman Souhlal <ssouhlal@freebsd.org>, <cgroups@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <penberg@kernel.org>, <cl@linux.com>,
        <yinghan@google.com>, <hughd@google.com>, <gthelen@google.com>,
        <peterz@infradead.org>, <dan.magenheimer@oracle.com>,
        <hannes@cmpxchg.org>, <mgorman@suse.de>,
        <James.Bottomley@hansenpartnership.com>, <linux-mm@kvack.org>,
        <devel@openvz.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 03/13] memcg: Uncharge all kmem when deleting a cgroup.
References: <1331325556-16447-1-git-send-email-ssouhlal@FreeBSD.org> <1331325556-16447-4-git-send-email-ssouhlal@FreeBSD.org> <4F5C602B.4050806@parallels.com> <CABCjUKBUQ7QS-pJbzrN=8_AFj20uP+dgOH44AWfK4ZecpprybA@mail.gmail.com>
In-Reply-To: <CABCjUKBUQ7QS-pJbzrN=8_AFj20uP+dgOH44AWfK4ZecpprybA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>> @@ -3719,6 +3721,8 @@ move_account:
>>>                 /* This is for making all *used* pages to be on LRU. */
>>>                 lru_add_drain_all();
>>>                 drain_all_stock_sync(memcg);
>>> +               if (!free_all)
>>> +                       memcg_kmem_move(memcg);
>>
>> Any reason we're not moving kmem charges when free_all is set as well?
>
> Because the slab moving code expects to be synchronized with
> allocations (and itself). We can't call it when there are still tasks
> in the cgroup.

Ok.

Please add an explanation about that.
Oh boy, reading it all now, I started to believe that "free_all" is a 
really poor name =(


