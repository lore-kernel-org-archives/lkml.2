Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab2KUEA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 23:00:29 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:40236 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752748Ab2KUEA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 23:00:28 -0500
X-IronPort-AV: E=Sophos;i="4.83,290,1352044800"; 
   d="scan'208";a="6243549"
Message-ID: <50AC4A1B.9020908@cn.fujitsu.com>
Date: Wed, 21 Nov 2012 11:27:23 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Rob Landley <rob@landley.net>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PART4 Patch v2 1/2] numa: add CONFIG_MOVABLE_NODE for movable-dedicated
 node
References: <1353067090-19468-1-git-send-email-wency@cn.fujitsu.com>	<1353067090-19468-2-git-send-email-wency@cn.fujitsu.com> <20121120142550.5c126194.akpm@linux-foundation.org>
In-Reply-To: <20121120142550.5c126194.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/21 11:20:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/21 11:20:51,
	Serialize complete at 2012/11/21 11:20:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 11/21/2012 06:25 AM, Andrew Morton Wrote:
> On Fri, 16 Nov 2012 19:58:09 +0800
> Wen Congyang <wency@cn.fujitsu.com> wrote:
> 
>> From: Lai Jiangshan <laijs@cn.fujitsu.com>
>>
>> All are prepared, we can actually introduce N_MEMORY.
>> add CONFIG_MOVABLE_NODE make we can use it for movable-dedicated node
> 
> This description is far too short on details.
> 
> I grabbed this from the [0/n] email:
> 
> : We need a node which only contains movable memory.  This feature is very
> : important for node hotplug.  If a node has normal/highmem, the memory may
> : be used by the kernel and can't be offlined.  If the node only contains
> : movable memory, we can offline the memory and the node.
> 
> which helps a bit, but it's still pretty thin.
> 
> Why is this option made configurable?  Why not enable it unconditionally?
> 
> Please send a patch which adds the Kconfig help text for
> CONFIG_MOVABLE_NODE.  Let's make that text nice and detailed.
> 
> The name MOVABLE_NODE is not a good one.  It means "a node which is
> movable", whereas the concept is actually "a node whcih contains only
> movable memory".  I suppose we could change it to something like
> CONFIG_MOVABLE_MEMORY_ONLY_NODE or similar.  But I suppose that
> CONFIG_MOVABLE_NODE is good enough, as long as it is well-described in
> associated comments or help text.  This is not the case at present.
> 
>> +#ifdef CONFIG_MOVABLE_NODE
>> +	N_MEMORY,		/* The node has memory(regular, high, movable) */
>> +#else
> 
> I think the comment should be "The node has only movable memory"?

No, the comment is right. In the kernel, we need the following two
mask:
1. the node contains memory that the kernel can use(N_HIGH_MEMORY)
2. the node contains memory (N_MEMORY)

There is no code need the mask: the node contains only movable memory
now.

Thanks
Wen Congyang

> 
> 
> 

