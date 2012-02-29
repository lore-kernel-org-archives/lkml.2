Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab2B2Xh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:37:56 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33399 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab2B2Xhy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:37:54 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of yhlu.kernel@gmail.com designates 10.236.155.6 as permitted sender) smtp.mail=yhlu.kernel@gmail.com; dkim=pass header.i=yhlu.kernel@gmail.com
MIME-Version: 1.0
In-Reply-To: <CAErSpo63hAtPMFdSEuVCcgw5ERMkiKx2Z8pREc2PdiCwmWpvkg@mail.gmail.com>
References: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
	<1330556858-11768-40-git-send-email-yinghai@kernel.org>
	<CAErSpo63hAtPMFdSEuVCcgw5ERMkiKx2Z8pREc2PdiCwmWpvkg@mail.gmail.com>
Date: Wed, 29 Feb 2012 15:37:53 -0800
X-Google-Sender-Auth: nrngeVrvUUr24W8gT1jZqUufgOs
Message-ID: <CAE9FiQUeRno4ZCy37XQ+cwrFYG-XoDq7q=XjKrOVy5E85bS-ig@mail.gmail.com>
Subject: Re: [PATCH 39/39] x86, PCI: kill busn in acpi pci_root_info
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 3:32 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Wed, Feb 29, 2012 at 4:07 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> Bjorn thought that we should just use that in acpi_root.
>>
>> Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  arch/x86/pci/acpi.c |   19 ++++++-------------
>>  1 files changed, 6 insertions(+), 13 deletions(-)
>>
>> diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
>> index ff5243e..5178917 100644
>> --- a/arch/x86/pci/acpi.c
>> +++ b/arch/x86/pci/acpi.c
>> @@ -12,7 +12,6 @@ struct pci_root_info {
>>        char name[16];
>>        unsigned int res_num;
>>        struct resource *res;
>> -       struct resource busn;
>>        struct pci_sysdata sd;
>>  };
>>
>> @@ -283,9 +282,6 @@ static void add_resources(struct pci_root_info *info,
>>        int i;
>>        struct resource *res, *root, *conflict;
>>
>> -       if (info->busn.flags & IORESOURCE_BUS)
>> -               pci_add_resource(resources, &info->busn);
>> -
>>        coalesce_windows(info, IORESOURCE_MEM);
>>        coalesce_windows(info, IORESOURCE_IO);
>>
>> @@ -346,16 +342,12 @@ static void release_pci_root_info(struct pci_host_bridge *bridge)
>>
>>  static void
>>  probe_pci_root_info(struct pci_root_info *info, struct acpi_device *device,
>> -                   int busnum, int busmax, int domain)
>> +                   int busnum, int domain)
>>  {
>>        size_t size;
>>
>>        sprintf(info->name, "PCI Bus %04x:%02x", domain, busnum);
>>        info->bridge = device;
>> -       info->busn.name = info->name;
>> -       info->busn.start = busnum;
>> -       info->busn.end = busmax;
>> -       info->busn.flags = IORESOURCE_BUS;
>
> You just *added* this stuff in a prior patch that hasn't been merged
> yet.  Why can't you just fix that series rather than doing the
> add/remove churn?

as i said before, I'm not quite sure about the life cycle about that object.

still need to wait some months to verify that on system that does
support pci root bus hot plug etc.

or we can just this patch for now.

Yinghai
