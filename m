Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab2IQP0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:26:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40020 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab2IQP0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:26:44 -0400
Message-ID: <5057412B.6040402@gmail.com>
Date: Mon, 17 Sep 2012 23:26:35 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3] ACPI/pci-bind: remove bind/unbind callbacks from acpi_device_ops
References: <CAE9FiQWBYmRj5--pg8eAwH_RKZsCWo+CVGN_KpeGXeE_3cSq9g@mail.gmail.com> <1347804577-23015-1-git-send-email-jiang.liu@huawei.com> <CAE9FiQUC9OyPQYDTC1xR45qd1an63H13LBKGaPueqihwq=yhSw@mail.gmail.com> <CAE9FiQU4tNDot3J9EEwhd=YUfTSoojtreb2JFVn-=KUsq=W+ow@mail.gmail.com>
In-Reply-To: <CAE9FiQU4tNDot3J9EEwhd=YUfTSoojtreb2JFVn-=KUsq=W+ow@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2012 02:02 AM, Yinghai Lu wrote:
> On Sun, Sep 16, 2012 at 9:49 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Sun, Sep 16, 2012 at 7:09 AM, Jiang Liu <liuj97@gmail.com> wrote:
>>> @@ -160,10 +160,13 @@ static int acpi_bind_one(struct device *dev, acpi_handle handle)
>>>         }
>>>         dev->archdata.acpi_handle = handle;
>>>
>>> -       acpi_pci_bind_notify(dev->archdata.acpi_handle, dev, true);
>>> -
>>>         status = acpi_bus_get_device(handle, &acpi_dev);
>>> -       if (!ACPI_FAILURE(status)) {
>>> +       if (!ACPI_FAILURE(status))
>>> +               acpi_dev = NULL;
>>> +
>>> +       acpi_pci_bind_notify(dev->archdata.acpi_handle, acpi_dev, dev, true);
>>
>> It seems you can do
>>     acpi_pci_bind_notify(acpi_dev, dev, true);
>> instead.
>>
>> aka:
>> Do you have test case acpi_dev is not created before pci device?
>>
> 
> updated your patch, and retrieve handle if needed from acpi_dev->handle or
> pci_dev->dev.archdata.acpi_handle.
Hi Yinghai,
	Thanks for your review. I have made some changes to the attached patch
to better support bisect. But the final result should be the same.
	--Gerry

> 
> Thanks
> 
> Yinghai
> 

