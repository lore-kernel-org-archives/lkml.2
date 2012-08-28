Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194Ab2H1A5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 20:57:05 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:20980 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab2H1A5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 20:57:03 -0400
Message-ID: <503C1679.4020008@huawei.com>
Date: Tue, 28 Aug 2012 08:53:13 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Jiang Liu <liuj97@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        PCI <linux-pci@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND BUGFIX PATCH 1/3] PCI/AER: fix pci_ops return NULL when
 hotplug a pci bus which was doing aer error inject
References: <1344685946-8172-1-git-send-email-wangyijing@huawei.com>   <5038A210.4030005@huawei.com> <1346030599.6279.315.camel@yhuang-dev>  <503B8CD4.8070802@gmail.com> <1346114304.6279.341.camel@yhuang-dev>
In-Reply-To: <1346114304.6279.341.camel@yhuang-dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.84]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/8/28 8:38, Huang Ying wrote:
> On Mon, 2012-08-27 at 23:05 +0800, Jiang Liu wrote:
>> Is it ok to ignore such a case? After all, aer_inject is just a test tool:)
>> It's not worth to change the core logic for such a corner case.
>> --Gerry
> 
> Why ignore?  At least you can prevent aer_inject from unload if
> something special happened.
> 

Hi Huang Ying,
   Thanks for your comments. It's my negligence. I will add some protection code when do #rmmod aer_inject(a race condition window about bus_ops),
I will correct it in the new version patch.

----------
Thanks!
Yijing


>> On 08/27/2012 09:23 AM, Huang Ying wrote:
>>> On Sat, 2012-08-25 at 17:59 +0800, Yijing Wang wrote:
>>>> When we inject aer errors to the target pci device by aer_inject module, the pci_ops of pci
>>>> bus which the target device is on will be assign to pci_ops_aer.So if the target pci device
>>>> is a bridge, once we hotplug the pci bus(child bus) which the target device bridges to, child
>>>> bus's pci_ops will be assigned to pci_ops_aer too.Now every access to the child bus's device
>>>> will result to system panic, because it return NULL pci_ops in pci_read_aer.
>>>> This patch fix this.



