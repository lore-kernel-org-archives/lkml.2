Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab2KTBaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 20:30:22 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:36956 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab2KTBaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 20:30:21 -0500
Message-ID: <50AADCDE.1010301@huawei.com>
Date: Tue, 20 Nov 2012 09:29:02 +0800
From: Jiang Liu <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tang Chen <tangchen@cn.fujitsu.com>, <wency@cn.fujitsu.com>,
        <linfeng@cn.fujitsu.com>, <rob@landley.net>,
        <isimatu.yasuaki@jp.fujitsu.com>, <laijs@cn.fujitsu.com>,
        <kosaki.motohiro@jp.fujitsu.com>, <minchan.kim@gmail.com>,
        <mgorman@suse.de>, <rientjes@google.com>, <yinghai@kernel.org>,
        <rusty@rustcorp.com.au>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 0/5] Add movablecore_map boot option.
References: <1353335246-9127-1-git-send-email-tangchen@cn.fujitsu.com> <20121119125325.ed1abba0.akpm@linux-foundation.org>
In-Reply-To: <20121119125325.ed1abba0.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-20 4:53, Andrew Morton wrote:
> On Mon, 19 Nov 2012 22:27:21 +0800
> Tang Chen <tangchen@cn.fujitsu.com> wrote:
> 
>> This patchset provide a boot option for user to specify ZONE_MOVABLE memory
>> map for each node in the system.
>>
>> movablecore_map=nn[KMG]@ss[KMG]
>>
>> This option make sure memory range from ss to ss+nn is movable memory.
>> 1) If the range is involved in a single node, then from ss to the end of
>>    the node will be ZONE_MOVABLE.
>> 2) If the range covers two or more nodes, then from ss to the end of
>>    the node will be ZONE_MOVABLE, and all the other nodes will only
>>    have ZONE_MOVABLE.
>> 3) If no range is in the node, then the node will have no ZONE_MOVABLE
>>    unless kernelcore or movablecore is specified.
>> 4) This option could be specified at most MAX_NUMNODES times.
>> 5) If kernelcore or movablecore is also specified, movablecore_map will have
>>    higher priority to be satisfied.
>> 6) This option has no conflict with memmap option.
> 
> This doesn't describe the problem which the patchset solves.  I can
> kinda see where it's coming from, but it would be nice to have it all
> spelled out, please.
> 
> - What is wrong with the kernel as it stands?
> - What are the possible ways of solving this?
> - Describe the chosen way, explain why it is superior to alternatives
> 
> The amount of manual system configuration in this proposal looks quite
> high.  Adding kernel boot parameters really is a last resort.  Why was
> it unavoidable here?
Agree, manual configuration should be last resort.
We should ask help from BIOS to provide more help about hotplug functionality,
and it should work out of box on platforms with hotplug capabilities.
For CPU/memory/node hotplug, I feel the backward compatibility burden on OS
should be minor, so why don't ask help from BIOS to better support hotplug?
We could shape the interfaces between BIOS and OS to support system device
hotplug.
Thanks
Gerry

