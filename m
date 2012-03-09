Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336Ab2CIAoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:44:00 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:41503 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759255Ab2CIAn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:43:57 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVNYWnZzfdNsW38P4vsD1ZpXeA+SwqqDK45SZAAphz_6A@mail.gmail.com>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
 <CABhMZUU_YNMXAU0Mr5zQMzxrk_XkFzk1HrwAN0SQxDf8n+F9kA@mail.gmail.com> <CAE9FiQVNYWnZzfdNsW38P4vsD1ZpXeA+SwqqDK45SZAAphz_6A@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 8 Mar 2012 17:43:36 -0700
Message-ID: <CAErSpo7W_2skcxsgFia+4caf1MgXCt3jqXCrKdX7q3EZ-KLP2Q@mail.gmail.com>
Subject: Re: [PATCH 00/23] PCI, x86: pci root bus hotplug support
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bjorn.helgaas@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 11:58 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, Mar 6, 2012 at 8:44 PM, Bjorn Helgaas <bjorn.helgaas@gmail.com> wrote:
>> On Tue, Mar 6, 2012 at 12:13 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> Does this series support hot-add, too, or just removal?
>>
>> If it is intended to support hot-add, I didn't see any support for
>> _CBA, which I *think* is the way hotplug-capable host bridges are
>> required to report MMCONFIG areas.
>
> to make the whole hotplug working with intel new cpus with IIO,
> in addition to physical cpu and memory hotplug, will still need
> a. ioapic controller hotplug
> b. intr-remapping hotplug
> c. intel-iommu hotplug
> d. mmconf support.
> e. root bus hotplug
>
> this patch set is only involved with partitally root bus removal/add back.
> and assume ioapic, intr-remap, intel-iommu, and mmconf related are
> working from early initialization.
>
> that will help us to help to fix bugs like devices refcount leaking.

OK, so this series only supports host bridge removal.  There are some
situations where it allows a bridge to be added, but only if the other
things you mentioned (ioapic, intr-remapping, etc.) are already
present, probably because we didn't remove them when removing the host
bridge.

In the case of MMCONFIG in particular, I think this should be moved
into the host bridge add path, e.g., in acpi_pci_root_add().  The fact
that it's totally separate today is a mistake.  But that can be fixed
later.

Overall nits, because kernel development is obsessive by nature:
Please format your changelogs with textwidth=75, so that when you read
them with "git log" in an 80-column terminal, the normal text doesn't
wrap across a line ending.

Please make your subject lines lines consistent in style and
capitalization.  Sometimes you have "PCI", sometimes "pci".  Sometimes
the first word after "PCI: " is capitalized, sometimes not.  One of
your intel-iommu.c patches is "IOMMU:"; the other is "pci, dmar:" (and
these patches are not adjacent in the series, even though they could
be).  This is just sloppy and distracting.

In English, the first word of a sentence is capitalized.  Words in the
middle are not, unless they are acronyms or proper nouns.  It would be
helpful if you could follow these conventions in your changelogs,
because I expect to be reading them for years to come, and I'm easily
distracted.

The notes about "-v2, -v3, -v4, etc." are not really useful in the
commit changelogs.  They're helpful in the [00/] message, but not in
the changelogs.

I appreciate the effort you're making to write changelogs.  They're
definitely starting to contain some useful information.

Bjorn
