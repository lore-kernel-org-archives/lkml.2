Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353Ab2K0KA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 05:00:29 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49539 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933260Ab2K0KAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 05:00:25 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50B48F0B.60704@jp.fujitsu.com>
Date: Tue, 27 Nov 2012 18:59:39 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Tang Chen <tangchen@cn.fujitsu.com>
CC: Bob Liu <lliubbo@gmail.com>, <akpm@linux-foundation.org>,
        <rob@landley.net>, <laijs@cn.fujitsu.com>, <wency@cn.fujitsu.com>,
        <linfeng@cn.fujitsu.com>, <jiang.liu@huawei.com>, <yinghai@kernel.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <minchan.kim@gmail.com>,
        <mgorman@suse.de>, <rientjes@google.com>, <rusty@rustcorp.com.au>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] Add movablecore_map boot option
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com> <CAA_GA1d7CxHvmZELvD_DO6u5tu1WBqfmLiuEzeFo=xMzuW50Tg@mail.gmail.com> <50B479FA.6010307@cn.fujitsu.com> <50B47EB7.20000@zytor.com>
In-Reply-To: <50B47EB7.20000@zytor.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi HPA and Tang,

2012/11/27 17:49, H. Peter Anvin wrote:
> On 11/27/2012 12:29 AM, Tang Chen wrote:
>> Another approach is like the following:
>> movable_node = 1,3-5,8
>> This could set all the memory on the nodes to be movable. And the rest
>> of memory works as usual. But movablecore_map is more flexible.
>
> ... but *much* harder for users, so movable_node is better in most cases.

It seems that movable_node is easier to use than movablecore_map.
But I do not think movable_node is better because the node number is set
by OS and changed easily.


For exmaple:
If system has 4 nodes and we set moveble_node=2, we can hot remove node2.

    node0   node1   node2   node3
   +-----+ +-----+ +-----+ +-----+
   |     | |     | |/////| |     |
   |     | |     | |/////| |     |
   |     | |     | |/////| |     |
   |     | |     | |/////| |     |
   +-----+ +-----+ +-----+ +-----+
                   movable
                    node

But if we hot remove node2 and reboot the system, node3 is changed to node2
and set to movable node.

    node0   node1           node2
   +-----+ +-----+         +-----+
   |     | |     |         |/////|
   |     | |     |         |/////|
   |     | |     |         |/////|
   |     | |     |         |/////|
   +-----+ +-----+         +-----+
                           movable
                            node

Originally, node3 is not movable node. Changing the node attribution to
movable node is not intended. So if user uses movable_node,
user must confirm whether boot option is correctly set at hotplug.

But memory range is set by firmware and not changed. So if we set node2
as movable node by movablecore_map, the issue does not occur.

Thanks,
Yasuaki Ishimatsu

>
> 	-hpa
>


