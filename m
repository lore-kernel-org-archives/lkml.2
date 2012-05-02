Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab2EBHWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 03:22:40 -0400
Received: from szxga03-in.huawei.com ([58.251.152.66]:59290 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab2EBHWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 03:22:39 -0400
Date: Wed, 02 May 2012 15:20:15 +0800
From: Jiang Liu <jiang.liu@huawei.com>
Subject: Re: [PATCH v2 04/19] PCI: serialize hotplug operations triggered by
 PCI hotplug sysfs interfaces
In-reply-to: <20120502050625.GB23579@kroah.com>
X-Originating-IP: [10.107.208.49]
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jiang Liu <liuj97@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Message-id: <4FA0E02F.5040901@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222
 Thunderbird/9.0.1
X-CFilter-Loop: Reflected
References: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
 <1335539820-11232-5-git-send-email-jiang.liu@huawei.com>
 <20120502050625.GB23579@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-5-2 13:06, Greg KH wrote:
> On Fri, Apr 27, 2012 at 11:16:45PM +0800, Jiang Liu wrote:
>> +	/* Avoid deadlock with pci_hp_deregister() */
>> +	while (!pci_hotplug_try_enter()) {
>> +		/* Check whether the slot has been deregistered. */
>> +		if (list_empty(&slot->slot_list)) {
>> +			retval = -ENODEV;
>> +			goto exit_put;
>> +		}
>> +		msleep(1);
>> +	}
>
> Oh my.
>
> Wow.
>
> {sigh}
>
> ick.
>
> My eyes hurt.
>
> And your cpu load just went crazy.
>
> You can now handle all of the nasty emails from sysadmins asking why
> their systems look like their load is high for no good reason.
My bad, should use schedule_timeout_interruptible() instead of
msleep(1) here to avoid busy waiting.

>
> Not to mention all of the other issues here.
>
> My statement about not inventing new lock types has now been proven
> true.
>
> The fact that this would even be a chunk of code that was proposed to be
> merged makes me weep.
>
> You owe me a bottle of whatever you are drinking if you expect me to
> continue to review these patch submissions.
>
> I'm stopping here in the series, please rework this whole thing in a
> major way.
>
> greg k-h
>
>


