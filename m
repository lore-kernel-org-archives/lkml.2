Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab1LIOs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:48:56 -0500
Received: from mx2.parallels.com ([64.131.90.16]:48535 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158Ab1LIOsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:48:54 -0500
Message-ID: <4EE21FB0.5090006@parallels.com>
Date: Fri, 9 Dec 2011 12:48:16 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <lizf@cn.fujitsu.com>,
        <ebiederm@xmission.com>, <davem@davemloft.net>, <gthelen@google.com>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>, <kirill@shutemov.name>,
        <avagin@parallels.com>, <devel@openvz.org>, <eric.dumazet@gmail.com>,
        <cgroups@vger.kernel.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH v8 1/9] Basic kernel memory functionality for the Memory
 Controller
References: <AE90C24D6B3A694183C094C60CF0A2F6D8AF0D@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6D8AF0D@saturn3.aculab.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2011 12:44 PM, David Laight wrote:
>
>> How about this?
>>
>>           val = !!val;
>>
>>           /*
>>            * This follows the same hierarchy restrictions than
>>            * mem_cgroup_hierarchy_write()
>>            */
>>           if (!parent || !parent->use_hierarchy) {
>>                   if (list_empty(&cgroup->children))
>>                           memcg->kmem_independent_accounting = val;
>>                   else
>>                           return -EBUSY;
>>           }
>>           else
>>                   return -EINVAL;
>>
>>           return 0;
>
> Inverting the tests gives easier to read code:
>
> 	if (parent&&  parent->user_hierarchy)
> 		return -EINVAL;
> 	if (!list_empty(&cgroup->children))
> 		return -EBUSY;
> 	memcg->kmem_independent_accounting = val != 0;
> 	return 0;

On the other hand, inconsistent with mem_cgroup_hierarchy_write(), which 
applies the logic in the same way I did here.

> NFI about the logic...
> On the face of it the tests don't seem related to each other
> or to the assignment!

How so?

If parent's use_hierarchy is set, we can't set this value (we need to 
have a parent for that to even matter).

We also can't set it if we already have any children - otherwise all the 
on-the-fly adjustments become hell-on-earth.

As for = val != 0, sorry, but I completely disagree this is easier than 
!!val. Not to mention the !!val notation is already pretty widespread in 
the kernel.

> 	David
>
> 	
>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email:<a href=ilto:"dont@kvack.org">  email@kvack.org</a>

