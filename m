Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab2I1Jz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:55:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39024 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab2I1Jz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:55:57 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5065740A.2000502@jp.fujitsu.com>
Date: Fri, 28 Sep 2012 18:55:22 +0900
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
References: <1348724705-23779-1-git-send-email-wency@cn.fujitsu.com> <1348724705-23779-3-git-send-email-wency@cn.fujitsu.com> <CAHGf_=rLMsmAxR5hrDVXjkHAxmupVrmtqE3iq2qu=O9Prp4nSg@mail.gmail.com> <5064EA5A.3080905@jp.fujitsu.com> <CAHGf_=qbBGjTL9oBHz7AM8BAosbzvn_WAGdAzJ8np-nDPN_KFQ@mail.gmail.com> <5064FDCA.1020504@jp.fujitsu.com> <CAHGf_=r+oz0GS137e81EySbN-3KVmQisF8sySiCUYUas1RZLtQ@mail.gmail.com>
In-Reply-To: <CAHGf_=r+oz0GS137e81EySbN-3KVmQisF8sySiCUYUas1RZLtQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kosaki-san,

2012/09/28 10:37, KOSAKI Motohiro wrote:
>>> Moreover, your explanation is still insufficient. Even if
>>> node_device_release() is empty function, we can get rid of the
>>> warning.
>>
>>
>> I don't understand it. How can we get rid of the warning?
>
> See cpu_device_release() for example.

If we implement a function like cpu_device_release(), the warning
disappears. But the comment says in the function "Never copy this way...".
So I think it is illegal way.

>
>
>
>>> Why do we need this node_device_release() implementation?
>>
>> I think that this is a manner of releasing object related kobject.
>
> No.  Usually we never call memset() from release callback.
>

What we want to release is a part of array, not a pointer.
Therefore, there is only this way instead of kfree().

Thanks,
Yasuaki Ishimatsu


