Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab2HTHrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 03:47:43 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:6230 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622Ab2HTHrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 03:47:40 -0400
Message-ID: <5031EB66.50307@huawei.com>
Date: Mon, 20 Aug 2012 15:46:46 +0800
From: Hanjun Guo <guohanjun@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: "Luck, Tony" <tony.luck@intel.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, Jianguo Wu <wujianguo@huawei.com>
Subject: Re: [BUGFIX PATCH][RESEND] kexec & iosapic: kexec oops when iosapic
 was removed
References: <1344583395-9128-1-git-send-email-guohanjun@huawei.com>  <5025CD41.2030502@huawei.com>  <3908561D78D1C84285E8C5FCA982C28F19375F30@ORSMSX104.amr.corp.intel.com>  <502CCB38.1030705@huawei.com> <1345145597.4732.21.camel@misato.fc.hp.com>
In-Reply-To: <1345145597.4732.21.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.25]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/8/17 3:33, Toshi Kani wrote:
> On Thu, 2012-08-16 at 18:28 +0800, Hanjun Guo wrote:
>> On 2012/8/13 10:54, Luck, Tony wrote:
>>>> 		vec = irq_to_vector(irq);
>>>> 		list_for_each_entry(rte, &info->rtes,
>>>> 				rte_list) {
>>>> +			if (rte->refcnt == NO_REF_RTE)
>>>> +				continue;
>>>> +
>>>> 			iosapic_write(rte->iosapic,
>>>> 					IOSAPIC_RTE_LOW(rte->rte_index),
>>>> 					IOSAPIC_MASK|vec);
>>>
>>> This will work - but is it papering over a problem when you removed the
>>> iosapic? Should we really have removed this "rte" from rte_list when the
>>> iosapic was removed?
>>>
>>> -Tony
>>>
>>
>> Hi Tony,
>>     Thanks for your comments, and sorry for the late reply.
>>
>> We only set rte->refcnt to NO_REF_RTE if no device attach to this RTE when
>> unregister a GSI, and increase the rte->refcnt if the RTE is already existing
>> when register a GSI, so "rte" will not removed from rte_list when the
>> iosapic is removed.
> 
> Hi Hanjun,
> 
> I think updating rte->refcnt makes sense as long as rte->iosapic points
> to a valid iosapic entry.  It looks odd to me that rte->iosapic is left
> pointing an invalid iosapic entry after this iosapic is removed.  So, I
> agree with Tony's concern.

Hi Toshi,

I agree with you and Tony.
I will find a better solution and do some clean up, and then send another patch.

Thanks
Hanjun Guo




