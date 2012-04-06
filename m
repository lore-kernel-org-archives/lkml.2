Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab2DFQWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 12:22:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43937 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab2DFQWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 12:22:44 -0400
Message-ID: <4F7F184A.3080001@gmail.com>
Date: Sat, 07 Apr 2012 00:22:34 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH -v3 40/47] PCI: Add pci bus removal through /sys/.../pci_bus/.../remove
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org> <1332135996-13860-41-git-send-email-yinghai@kernel.org> <4F7F10C5.1050901@gmail.com> <CAE9FiQUEJ4Jvz0BHJ8LCBNpXWB3Cf6u3k9F1avAd4a-fkGOB=Q@mail.gmail.com> <CAErSpo6gitMTVXeMBOSJFRHvQT_iJ-RGmLduYsGEM+3YAPE2CQ@mail.gmail.com>
In-Reply-To: <CAErSpo6gitMTVXeMBOSJFRHvQT_iJ-RGmLduYsGEM+3YAPE2CQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2012 12:07 AM, Bjorn Helgaas wrote:
> On Fri, Apr 6, 2012 at 10:01 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> On Fri, Apr 6, 2012 at 8:50 AM, Jiang Liu <liuj97@gmail.com> wrote:
>>> Hi Yinghai,
>>>        I found many other drivers assume that a pci bus won't disappear if
>>> the corresponding PCI bridge device still exists. The sysfs interface proposed
>>> here breaks that assumption and may cause many access-after-free issues.
>>> So what's the purpose of this interface? Should we remove this interface or
>>> enhance other drivers to avoid invalid memory access issues?
> 
> Can you point out some of the specifics about drivers making this
> assumption?  I'm not thrilled about the idea of removing a pci_bus
> while the upstream bridge pci_dev still exists either.
According to my understanding, following drivers may have such an assumption:
acpiphp, pciehp, shpcphp, acpi/pci_slot, acpi/pci_bind.
I suspect there are still other drivers have such issues.

> 
>> ok, will make it only show up on root bus.
> 
> OK.  I'm still interested in the specifics because I don't like the
> way the pci_bus is exposed, even inside the kernel.  The bus itself is
> not an active entity, and we can't really do anything with it except
> by touching a device connected to it.
> 
> Bjorn

