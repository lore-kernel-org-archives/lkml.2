Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab2FNCJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 22:09:28 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36312 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab2FNCJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 22:09:27 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FD94738.6030500@jp.fujitsu.com>
Date: Thu, 14 Jun 2012 11:06:48 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Bjorn Helgaas <bhelgaas@google.com>, Wen Congyang <wency@cn.fujitsu.com>,
        tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] x86: add max_addr boot option
References: <4FD5AFF2.3040306@cn.fujitsu.com> <CAErSpo6EnHFFPwcPhWy=ACTn5+7i72fUR+1jjZrpfEMQp1zv0A@mail.gmail.com> <4FD6E1DA.2090700@cn.fujitsu.com> <CAErSpo6UwL6kY4rHeYQbn1kghJH-kQDeat7VXp95JE2pGER5ZA@mail.gmail.com> <4FD7F329.1000203@jp.fujitsu.com> <4FD81E27.4000006@landley.net>
In-Reply-To: <4FD81E27.4000006@landley.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/13 13:59), Rob Landley wrote:
> On 06/12/2012 08:55 PM, Kamezawa Hiroyuki wrote:
>>>> Currently, I only need to ignore the memory. If we need to ignore a
>>>> node,
>>>> "numa_node=" or similar parameter is a better choice.
>>>
>>> Doesn't the end user have to know the memory map of the system to use
>>> "max_addr="?  How do you know what value to supply?  Do you have to
>>> attempt a boot once to discover the highest address on node 0?  What
>>> if node 0 and node 1 memory are interleaved, so there's some node 1
>>> memory below the highest node 0 address?
>>
>> Current our plan is to avoid asking end-user to fix their boot option by
>> hand even if memory size per node is changed. We'll ship a  hardware, which has
>> _fixed_ physical address range per each node regardless of equipped
>> memory size.
>
> I.E. you'll be configuring this yourself when you ship hardware.
>

yes.

> You're adding an option because you consider it less confusing for your
> end users who are digging into kernel parameters, but you will set this
> new option for your users because they haven't got the information to
> set it themselves?
>

My users don't need to know about hardware settings and the meaning of
kernel params. They'll just do as we ask to do.


>> Problem happens =>  reboot (disable some DIMM) =>  remove memmap= option
>> for avoiding
>> trouble =>  check memory layout again =>fix mem_map= =>  reboot again.
>> This reboot takes much time because the system which have
>> Dynamic-partitioning tends to
>> be big....so, we'd like to have some _relaxed_ way to specify the region
>> of memory.
>>
>> Problem happens =>  reboot (disable some DIMM) =>  no changes required
>> (because we have enough memory hole between Node0 and Node1.)
>
> I'm guessing the above means "or you'll be providing some tool that does
> it when they install/remove memory in the hardware"...
>
>> BTW, how do you think about mem= boot option which works as max_addr=,
>> now ?
>> This caused troubles some times on our support-desk, saying
>> Q. I specified mem=8G boot option but it seems the system has only 7GB....
>> A. it's because of PCI configuration area on 3G-4G address range...
>
> So you're saying there are already two ways to do this, but you want to
> add a third to be less confusing for end users who are modifying the
> linux kernel boot parameters by hand using information only you can
> supply to them?
>
> I'm confused...
>

I'm just saying current mem= implemenation seems buggy because spec. and
impl. doesn't match. So, we're just afraid that someone other than us
will fix it and break our assumption how mem= works. It's dangerous to
build a production on a feature where spec. and impl. doesn't match.
So, we proposed to add max_addr= option for avoiding that situation.

Reading threads, it seems Maintainers says that current 'mem=' have been working
for many years and it's not buggy, it works as expected. It seems no one
will be able to change the implementation. Then, we're okay with using mem=.
We'll just implement mem= option for efi environment. And try to fix the spec.
if possible.

Thanks,
-Kame









