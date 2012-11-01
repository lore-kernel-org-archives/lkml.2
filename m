Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab2KAFqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 01:46:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:39799 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab2KAFqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 01:46:17 -0400
X-IronPort-AV: E=Sophos;i="4.80,691,1344182400"; 
   d="scan'208";a="6114144"
Message-ID: <50920E01.6060708@cn.fujitsu.com>
Date: Thu, 01 Nov 2012 13:52:01 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Yinghai Lu <yinghai@kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: Re: [PART2 Patch] node: cleanup node_state_attr
References: <1351666528-8226-1-git-send-email-wency@cn.fujitsu.com> <1351666528-8226-2-git-send-email-wency@cn.fujitsu.com> <alpine.DEB.2.00.1210311128570.8809@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1210311128570.8809@chino.kir.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/01 13:45:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/01 13:45:29,
	Serialize complete at 2012/11/01 13:45:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 11/01/2012 02:29 AM, David Rientjes Wrote:
> On Wed, 31 Oct 2012, Wen Congyang wrote:
> 
>> diff --git a/drivers/base/node.c b/drivers/base/node.c
>> index af1a177..5d7731e 100644
>> --- a/drivers/base/node.c
>> +++ b/drivers/base/node.c
>> @@ -614,23 +614,23 @@ static ssize_t show_node_state(struct device *dev,
>>  	{ __ATTR(name, 0444, show_node_state, NULL), state }
>>  
>>  static struct node_attr node_state_attr[] = {
>> -	_NODE_ATTR(possible, N_POSSIBLE),
>> -	_NODE_ATTR(online, N_ONLINE),
>> -	_NODE_ATTR(has_normal_memory, N_NORMAL_MEMORY),
>> -	_NODE_ATTR(has_cpu, N_CPU),
>> +	[N_POSSIBLE] = _NODE_ATTR(possible, N_POSSIBLE),
>> +	[N_ONLINE] = _NODE_ATTR(online, N_ONLINE),
>> +	[N_NORMAL_MEMORY] = _NODE_ATTR(has_normal_memory, N_NORMAL_MEMORY),
>>  #ifdef CONFIG_HIGHMEM
>> -	_NODE_ATTR(has_high_memory, N_HIGH_MEMORY),
>> +	[N_HIGH_MEMORY] = _NODE_ATTR(has_high_memory, N_HIGH_MEMORY),
>>  #endif
>> +	[N_CPU] = _NODE_ATTR(has_cpu, N_CPU),
>>  };
>>  
> 
> Why change the index for N_CPU?

N_CPU > N_HIGH_MEMORY

We use this array to create attr file in sysfs. So changing the index for N_CPU
doesn't cause any other problem.

Thanks
Wen Congyang

> 
>>  static struct attribute *node_state_attrs[] = {
>> -	&node_state_attr[0].attr.attr,
>> -	&node_state_attr[1].attr.attr,
>> -	&node_state_attr[2].attr.attr,
>> -	&node_state_attr[3].attr.attr,
>> +	&node_state_attr[N_POSSIBLE].attr.attr,
>> +	&node_state_attr[N_ONLINE].attr.attr,
>> +	&node_state_attr[N_NORMAL_MEMORY].attr.attr,
>>  #ifdef CONFIG_HIGHMEM
>> -	&node_state_attr[4].attr.attr,
>> +	&node_state_attr[N_HIGH_MEMORY].attr.attr,
>>  #endif
>> +	&node_state_attr[N_CPU].attr.attr,
>>  	NULL
>>  };
>>  
> 

