Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab2B0WYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 17:24:36 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:61794 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab2B0WYc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 17:24:32 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bhelgaas@google.com designates 10.180.92.229 as permitted sender) smtp.mail=bhelgaas@google.com; dkim=pass header.i=bhelgaas@google.com
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUAp6kWT4DZvAKCBGhbGWMp2Q1hz_fuJKD0mS8BYzUb1g@mail.gmail.com>
References: <1330299202-3838-1-git-send-email-yinghai@kernel.org>
 <1330299202-3838-6-git-send-email-yinghai@kernel.org> <CAErSpo4PMzuPdCZvbYFiQRGjGuMg+KYk0ZxJH0xr-n6AfqBAnA@mail.gmail.com>
 <CAE9FiQUDtJc5uwPXkQ7T7zr8=xa=VnPuQT4Q87SXbynuCHQ2Zg@mail.gmail.com>
 <CAErSpo4pDOZ0FM_OQ7=X2iysfUy6pFyWvY5i7WX=5cdD2Tu9Ew@mail.gmail.com> <CAE9FiQUAp6kWT4DZvAKCBGhbGWMp2Q1hz_fuJKD0mS8BYzUb1g@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 27 Feb 2012 15:24:11 -0700
Message-ID: <CAErSpo5WUhbiGc6kexRKdwA4F-BqdT-9gZY2HZSaxiPm+ZfUtw@mail.gmail.com>
Subject: Re: [PATCH 5/8] PCI: add generic device into pci_host_bridge struct
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 1:49 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Feb 27, 2012 at 11:17 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Mon, Feb 27, 2012 at 12:08 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>
>>>> This doesn't feel right to me.  You're allocating a new struct device
>>>> here, but the arch likely already has one.  In fact, I think we even
>>>> passed it in to pci_create_root_bus().
>>>
>>> no.
>>>
>>> original pci_create_root_bus() will create one dummy struct device and
>>> use it as parent for bus->dev.
>>>
>>>>
>>>> On x86, we already have an ACPI device for the host bridge, and now
>>>> we'll have a second one.  (Actually a *third* one, because PNPACPI
>>>> also has one, but that's a long-standing problem.)
>>>
>>> not related.
>>
>> OK.  Can you educate me?  What is the device we pass in, what does the
>> dummy one correspond to, why do we have two, what's the difference,
>> etc., etc.?
>
> for every bus will have ->bridge, and that is device pointer. to  pci
> bridge dev.
>
> for root bus, there is not pci bridge for that. So create_root_bus
> allocate local dummy one.
>
> that dummy device will be bus->dev's parent.
>
> Now pci_host_bridge is added, and it is allocated, so just put the
> struct device into that pci_host_bridge.
>
> and use pci_host_bridge->dev as parent of root bus->dev's parent.

What's the device passed in to pci_create_root_bus()?  Why is that
different than the root bus dev's parent?
