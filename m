Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab2JLAOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 20:14:35 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48003 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab2JLAOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 20:14:34 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <507760BE.4060906@jp.fujitsu.com>
Date: Fri, 12 Oct 2012 09:13:50 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <liuj97@gmail.com>,
        <minchan.kim@gmail.com>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <wency@cn.fujitsu.com>
Subject: Re: [PATCH 2/2]suppress "Device nodeX does not have a release() function"
 warning
References: <507656D1.5020703@jp.fujitsu.com> <50765896.4000300@jp.fujitsu.com> <alpine.DEB.2.00.1210111326000.28062@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1210111326000.28062@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/12 5:31, David Rientjes wrote:
> On Thu, 11 Oct 2012, Yasuaki Ishimatsu wrote:
>
>> When calling unregister_node(), the function shows following message at
>> device_release().
>>
>> "Device 'node2' does not have a release() function, it is broken and must
>> be fixed."
>>
>> The reason is node's device struct does not have a release() function.
>>
>> So the patch registers node_device_release() to the device's release()
>> function for suppressing the warning message. Additionally, the patch adds
>> memset() to initialize a node struct into register_node(). Because the node
>> struct is part of node_devices[] array and it cannot be freed by
>> node_device_release(). So if system reuses the node struct, it has a garbage.
>>
>
> Nice catch on reuse of the statically allocated node_devices[] for node
> hotplug.
>
>> CC: David Rientjes <rientjes@google.com>
>> CC: Jiang Liu <liuj97@gmail.com>
>> Cc: Minchan Kim <minchan.kim@gmail.com>
>> CC: Andrew Morton <akpm@linux-foundation.org>
>> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
>
> Can register_node() be made static in drivers/base/node.c and its
> declaration removed from linux/node.h?

Yah. I'll fix it.

Thanks,
Yasuaki Ishimatsu

>
> Acked-by: David Rientjes <rientjes@google.com>
>


