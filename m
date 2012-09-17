Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab2IQDGx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 23:06:53 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64004 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab2IQDGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 23:06:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQU4tNDot3J9EEwhd=YUfTSoojtreb2JFVn-=KUsq=W+ow@mail.gmail.com>
References: <CAE9FiQWBYmRj5--pg8eAwH_RKZsCWo+CVGN_KpeGXeE_3cSq9g@mail.gmail.com>
	<1347804577-23015-1-git-send-email-jiang.liu@huawei.com>
	<CAE9FiQUC9OyPQYDTC1xR45qd1an63H13LBKGaPueqihwq=yhSw@mail.gmail.com>
	<CAE9FiQU4tNDot3J9EEwhd=YUfTSoojtreb2JFVn-=KUsq=W+ow@mail.gmail.com>
Date: Sun, 16 Sep 2012 20:06:50 -0700
X-Google-Sender-Auth: Z3lGjXoVOmg4DhhN0sfh1oD6uio
Message-ID: <CAE9FiQXWzq+oA72pFAwkXwFAdnfJSwaMs0wtzOpKQU_xxNB=dg@mail.gmail.com>
Subject: Re: [PATCH v3] ACPI/pci-bind: remove bind/unbind callbacks from acpi_device_ops
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2012 at 11:02 AM, Yinghai Lu <yinghai@kernel.org> wrote:
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

please use this updated version.

Also you could add
Reviewed-by: Yinghai Lu <yinghai@kernel.org>

for your patch 1, 2, 4, 5.

Thanks

Yinghai
