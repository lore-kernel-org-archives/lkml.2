Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab2FZIbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 04:31:24 -0400
Received: from mx2.parallels.com ([64.131.90.16]:34357 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758525Ab2FZIbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 04:31:20 -0400
Message-ID: <4FE972B2.1020509@parallels.com>
Date: Tue, 26 Jun 2012 12:28:34 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        <devel@openvz.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 03/11] memcg: change defines to an enum
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-4-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1206252110470.26640@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1206252110470.26640@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 08:11 AM, David Rientjes wrote:
> On Mon, 25 Jun 2012, Glauber Costa wrote:
>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 8e601e8..9352d40 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -387,9 +387,12 @@ enum charge_type {
>>   };
>>
>>   /* for encoding cft->private value on file */
>> -#define _MEM			(0)
>> -#define _MEMSWAP		(1)
>> -#define _OOM_TYPE		(2)
>> +enum res_type {
>> +	_MEM,
>> +	_MEMSWAP,
>> +	_OOM_TYPE,
>> +};
>> +
>>   #define MEMFILE_PRIVATE(x, val)	((x) << 16 | (val))
>>   #define MEMFILE_TYPE(val)	((val) >> 16 & 0xffff)
>>   #define MEMFILE_ATTR(val)	((val) & 0xffff)
>
> Shouldn't everything that does MEMFILE_TYPE() now be using type
> enum res_type rather than int?
>
If you mean the following three fields, no, since they are masks and 
operations.

If you mean something else, what do you mean ?

