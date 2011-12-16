Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760167Ab1LPITj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 03:19:39 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:49046 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab1LPITh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 03:19:37 -0500
Date: Fri, 16 Dec 2011 16:18:45 +0800
From: Zang Hongyong <zanghongyong@huawei.com>
Subject: Re: [PATCH 0/2] vhot-net: Use kvm_memslots instead of vhost_memory to
 translate GPA to HVA
In-reply-to: <1324022358.4496.25.camel@lappy>
X-Originating-IP: [10.166.80.127]
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        xiaowei.yang@huawei.com, hanweidong@huawei.com, wusongwei@huawei.com
Message-id: <4EEAFEE5.3000406@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-2022-JP
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
X-CFilter-Loop: Reflected
References: <1324013528-3663-1-git-send-email-zanghongyong@huawei.com>
 <1324019151.4496.9.camel@lappy> <4EEAF5D1.2080805@huawei.com>
 <1324022358.4496.25.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011/12/16,星期五 15:59, Sasha Levin 写道:
> On Fri, 2011-12-16 at 15:40 +0800, Zang Hongyong wrote:
>> 于 2011/12/16,星期五 15:05, Sasha Levin 写道:
>>> On Fri, 2011-12-16 at 13:32 +0800, zanghongyong@huawei.com wrote:
>>>> From: Hongyong Zang<zanghongyong@huawei.com>
>>>>
>>>> Vhost-net uses its own vhost_memory, which results from user space (qemu) info,
>>>> to translate GPA to HVA. Since kernel's kvm structure already maintains the
>>>> address relationship in its member *kvm_memslots*, these patches use kernel's
>>>> kvm_memslots directly without the need of initialization and maintenance of
>>>> vhost_memory.
>>> Conceptually, vhost isn't aware of KVM - it's just a driver which moves
>>> data from vq to a tap device and back. You can't simply add KVM specific
>>> code into vhost.
>>>
>>> Whats the performance benefit?
>>>
>> But vhost-net is only used in virtualization situation. vhost_memory is 
>> maintained
>> by user space qemu.
>> In this way, the memory relationship can be accquired from kernel 
>> without the
>> need of maintainence of vhost_memory from qemu.
> You can't assume that vhost-* is used only along with qemu/kvm. Just as
> virtio has more uses than just virtualization (heres one:
> https://lkml.org/lkml/2011/10/25/139 ), there are more uses for vhost as
> well.
>
> There has been a great deal of effort to keep vhost and kvm untangled.
> One example is the memory translation it has to do, another one is the
> eventfd/irqfd thing it does just so it could signal an IRQ in the guest
> instead of accessing the guest directly.
>
> If you do see a great performance increase when tying vhost and KVM
> together, it may be worth it to create some sort of an in-kernel
> vhost-kvm bridging thing, but if the performance isn't noticeable we're
> better off just leaving it as is and keeping the vhost code general.
>
Thanks for your explanation.
Since memory layout is seldom changed after guest boots, the situation
manily occurs during initialization. There's no need for vhost-kvm
bridge now.

