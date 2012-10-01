Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab2JAGzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 02:55:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49275 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab2JAGzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 02:55:08 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50693E30.3010006@jp.fujitsu.com>
Date: Mon, 1 Oct 2012 15:54:40 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: <wency@cn.fujitsu.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <rientjes@google.com>,
        <liuj97@gmail.com>, <len.brown@intel.com>, <benh@kernel.crashing.org>,
        <paulus@samba.org>, <minchan.kim@gmail.com>,
        <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] memory-hotplug: add node_device_release
References: <1348724705-23779-1-git-send-email-wency@cn.fujitsu.com> <1348724705-23779-3-git-send-email-wency@cn.fujitsu.com> <CAHGf_=rLMsmAxR5hrDVXjkHAxmupVrmtqE3iq2qu=O9Prp4nSg@mail.gmail.com> <5064EA5A.3080905@jp.fujitsu.com> <CAHGf_=qbBGjTL9oBHz7AM8BAosbzvn_WAGdAzJ8np-nDPN_KFQ@mail.gmail.com> <5064FDCA.1020504@jp.fujitsu.com> <CAHGf_=r+oz0GS137e81EySbN-3KVmQisF8sySiCUYUas1RZLtQ@mail.gmail.com> <5065740A.2000502@jp.fujitsu.com> <CAHGf_=o_FLsEULK3s1+zD-A0FL5QvKnX542Lz4vCwVVV2fYNRw@mail.gmail.com>
In-Reply-To: <CAHGf_=o_FLsEULK3s1+zD-A0FL5QvKnX542Lz4vCwVVV2fYNRw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kosaki-san,

2012/09/29 7:19, KOSAKI Motohiro wrote:
>>>> I don't understand it. How can we get rid of the warning?
>>>
>>> See cpu_device_release() for example.
>>
>> If we implement a function like cpu_device_release(), the warning
>> disappears. But the comment says in the function "Never copy this way...".
>> So I think it is illegal way.
>
> What does "illegal" mean?

The "illegal" means the code should not be mimicked.

> You still haven't explain any benefit of your code. If there is zero
> benefit, just kill it.
> I believe everybody think so.
>
> Again, Which benefit do you have?

The patch has a benefit to delets a warning message.

>
>>>>> Why do we need this node_device_release() implementation?
>>>>
>>>> I think that this is a manner of releasing object related kobject.
>>>
>>> No.  Usually we never call memset() from release callback.
>>
>> What we want to release is a part of array, not a pointer.
>> Therefore, there is only this way instead of kfree().
>
> Why? Before your patch, we don't have memset() and did work it.

If we does not apply the patch, a warning message is shown.
So I think it did not work well.

> I can't understand what mean "only way".

For deleting a warning message, I created a node_device_release().
In the manner of releasing kobject, the function frees a object related
to the kobject. So most functions calls kfree() for releasing it.
In node_device_release(), we need to free a node struct. If the node
struct is pointer, I can free it by kfree. But the node struct is a part
of node_devices[] array. I cannot free it. So I filled the node struct
with 0.

But you think it is not good. Do you have a good solution?

Thanks,
Yasuaki Ishimatsu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


