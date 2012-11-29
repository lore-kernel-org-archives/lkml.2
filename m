Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab2K2KjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 05:39:19 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40255 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2K2KjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 05:39:17 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50B73B22.90500@jp.fujitsu.com>
Date: Thu, 29 Nov 2012 19:38:26 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Jiang Liu <jiang.liu@huawei.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rob@landley.net" <rob@landley.net>,
        "laijs@cn.fujitsu.com" <laijs@cn.fujitsu.com>,
        "wency@cn.fujitsu.com" <wency@cn.fujitsu.com>,
        "linfeng@cn.fujitsu.com" <linfeng@cn.fujitsu.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "rientjes@google.com" <rientjes@google.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, "Wang, Frank" <frank.wang@intel.com>
Subject: Re: [PATCH v2 0/5] Add movablecore_map boot option
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com> <50B5CFAE.80103@huawei.com> <3908561D78D1C84285E8C5FCA982C28F1C95EDCE@ORSMSX108.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1C95EDCE@ORSMSX108.amr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

2012/11/29 6:34, Luck, Tony wrote:
>> 1. use firmware information
>>    According to ACPI spec 5.0, SRAT table has memory affinity structure
>>    and the structure has Hot Pluggable Filed. See "5.2.16.2 Memory
>>    Affinity Structure". If we use the information, we might be able to
>>    specify movable memory by firmware. For example, if Hot Pluggable
>>    Filed is enabled, Linux sets the memory as movable memory.
>>
>> 2. use boot option
>>    This is our proposal. New boot option can specify memory range to use
>>    as movable memory.
>
> Isn't this just moving the work to the user? To pick good values for the

Yes.

> movable areas, they need to know how the memory lines up across
> node boundaries ... because they need to make sure to allow some
> non-movable memory allocations on each node so that the kernel can
> take advantage of node locality.

There is no problem.
Linux has already two boot options, kernelcore= and movablecore=.
So if we use them, non-movable memory is divided into each node evenly.

But there is no way to specify a node used as movable currently. So
we proposed the new boot option.

> So the user would have to read at least the SRAT table, and perhaps
> more, to figure out what to provide as arguments.
>

> Since this is going to be used on a dynamic system where nodes might
> be added an removed - the right values for these arguments might
> change from one boot to the next. So even if the user gets them right
> on day 1, a month later when a new node has been added, or a broken
> node removed the values would be stale.

I don't think so. Even if we hot add/remove node, the memory range of
each memory device is not changed. So we don't need to change the boot
option.

Thanks,
Yasuaki Ishimatsu

>
> -Tony
>


