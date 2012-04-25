Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab2DYOkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 10:40:47 -0400
Received: from mx2.parallels.com ([64.131.90.16]:55818 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab2DYOkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 10:40:46 -0400
Message-ID: <4F980C81.5060802@parallels.com>
Date: Wed, 25 Apr 2012 11:38:57 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 09/23] kmem slab accounting basic infrastructure
References: <1334959051-18203-1-git-send-email-glommer@parallels.com> <1334959051-18203-10-git-send-email-glommer@parallels.com> <4F975430.4090107@jp.fujitsu.com>
In-Reply-To: <4F975430.4090107@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.19.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 10:32 PM, KAMEZAWA Hiroyuki wrote:
> (2012/04/21 6:57), Glauber Costa wrote:
> 
>> This patch adds the basic infrastructure for the accounting of the slab
>> caches. To control that, the following files are created:
>>
>>   * memory.kmem.usage_in_bytes
>>   * memory.kmem.limit_in_bytes
>>   * memory.kmem.failcnt
>>   * memory.kmem.max_usage_in_bytes
>>
>> They have the same meaning of their user memory counterparts. They reflect
>> the state of the "kmem" res_counter.
>>
>> The code is not enabled until a limit is set. This can be tested by the flag
>> "kmem_accounted". This means that after the patch is applied, no behavioral
>> changes exists for whoever is still using memcg to control their memory usage.
>>
> 
> Hmm, res_counter never goes naeative ?

Why would it?

This one has more or less the same logic as the sock buffers.

If we are not accounted, the caches don't get created. If the caches
don't get created, we don't release them. (this is modulo bugs, of course)
