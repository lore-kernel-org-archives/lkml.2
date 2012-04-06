Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab2DFSFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 14:05:49 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:45225 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757167Ab2DFSFr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 14:05:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWjLx8R_j5q1qF-NYLOmxV-TbmROUqcLMw-QMFE4rjkpw@mail.gmail.com>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
 <1332135996-13860-41-git-send-email-yinghai@kernel.org> <4F7F10C5.1050901@gmail.com>
 <CAE9FiQUEJ4Jvz0BHJ8LCBNpXWB3Cf6u3k9F1avAd4a-fkGOB=Q@mail.gmail.com>
 <CAErSpo6gitMTVXeMBOSJFRHvQT_iJ-RGmLduYsGEM+3YAPE2CQ@mail.gmail.com>
 <CAE9FiQUjsiEvGGZz4sPux5AM7ipDsqgqgh5bh2QA7GJVBTqDKw@mail.gmail.com> <CAE9FiQWjLx8R_j5q1qF-NYLOmxV-TbmROUqcLMw-QMFE4rjkpw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 6 Apr 2012 12:05:25 -0600
Message-ID: <CAErSpo4kd6Q=cNMp6GJV6MBN9uypRCJB0sNfrkq9vpXDTtqzAg@mail.gmail.com>
Subject: Re: [PATCH -v3 40/47] PCI: Add pci bus removal through /sys/.../pci_bus/.../remove
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 11:42 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> adding back the CC list
>
>
> ---------- Forwarded message ----------
> From: Yinghai Lu <yhlu.kernel@gmail.com>
> Date: Fri, Apr 6, 2012 at 9:24 AM
> Subject: Re: [PATCH -v3 40/47] PCI: Add pci bus removal through
> /sys/.../pci_bus/.../remove
> To: Bjorn Helgaas <bhelgaas@google.com>
>
>
> On Fri, Apr 6, 2012 at 9:07 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Fri, Apr 6, 2012 at 10:01 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>> On Fri, Apr 6, 2012 at 8:50 AM, Jiang Liu <liuj97@gmail.com> wrote:
>>>> Hi Yinghai,
>>>>        I found many other drivers assume that a pci bus won't disappear if
>>>> the corresponding PCI bridge device still exists. The sysfs interface proposed
>>>> here breaks that assumption and may cause many access-after-free issues.
>>>> So what's the purpose of this interface? Should we remove this interface or
>>>> enhance other drivers to avoid invalid memory access issues?
>>
>> Can you point out some of the specifics about drivers making this
>> assumption?  I'm not thrilled about the idea of removing a pci_bus
>> while the upstream bridge pci_dev still exists either.
>
> I noticed that too. some hotplug driver link to those child bus
> instead of bridge...
> So have prepared some local patches to handle them.

I know you sometimes send patches as attachments because gmail makes
it hard to send them inline.  Gmail also makes it a pain to *review*
things sent as attachments, so it's hard on both ends.  I wish I could
fix that, but I can't.  Attachments also don't show up in patchwork,
which I hope to use to help keep track of things.  Bottom line:
attachments get less attention than they probably deserve.

>>> ok, will make it only show up on root bus.
>>
>> OK.  I'm still interested in the specifics because I don't like the
>> way the pci_bus is exposed, even inside the kernel.  The bus itself is
>> not an active entity, and we can't really do anything with it except
>> by touching a device connected to it.
>
> I want to keep that to remove root bus that is not added acpi root.

What's the use case for this?  I understand there are systems where
you can physically add or remove host bridges by plugging or
unplugging cables.  But in that case, I expect the host bridges to be
ACPI devices, and I expect an ACPI hotplug flow.

But I'm not aware of cases where we can hotplug non-ACPI host bridges,
so I don't understand the value of supporting this.  Is this related
to the cases where we blindly probe and discover CPU memory
controllers and things that the BIOS decided not to expose to the OS?
