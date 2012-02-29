Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab2B2AXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 19:23:12 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62090 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116Ab2B2AXI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 19:23:08 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bhelgaas@google.com designates 10.216.139.25 as permitted sender) smtp.mail=bhelgaas@google.com; dkim=pass header.i=bhelgaas@google.com
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWBvYZO-D+Z2zwdd0a-bkatF-0YPtmxKP4Se75vccgPrA@mail.gmail.com>
References: <1330466863-28469-1-git-send-email-yinghai@kernel.org>
 <1330466863-28469-13-git-send-email-yinghai@kernel.org> <CAErSpo66PD3+E3ZFqp73XHabL+8GavpX97pUkd28T6KWTBH-aA@mail.gmail.com>
 <CAE9FiQWBvYZO-D+Z2zwdd0a-bkatF-0YPtmxKP4Se75vccgPrA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 28 Feb 2012 17:22:46 -0700
Message-ID: <CAErSpo5NOqnqWxCBV+NecA34z0YJHP7FCy6mNd5GUJ8q__CZHw@mail.gmail.com>
Subject: Re: [PATCH 12/24] PCI, ia64: Register busn_res for root buses
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 5:12 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, Feb 28, 2012 at 4:01 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Tue, Feb 28, 2012 at 3:07 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>> Cc: Tony Luck <tony.luck@intel.com>
>>> Cc: Fenghua Yu <fenghua.yu@intel.com>
>>> Cc: linux-ia64@vger.kernel.org
>>> ---
>>>  arch/ia64/include/asm/pci.h |    1 +
>>>  arch/ia64/pci/pci.c         |    5 +++++
>>>  2 files changed, 6 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/arch/ia64/include/asm/pci.h b/arch/ia64/include/asm/pci.h
>>> index b22e5f5..6e54220 100644
>>> --- a/arch/ia64/include/asm/pci.h
>>> +++ b/arch/ia64/include/asm/pci.h
>>> @@ -94,6 +94,7 @@ struct pci_controller {
>>>
>>>        unsigned int windows;
>>>        struct pci_window *window;
>>> +       struct resource busn;
>>
>> Why do you add a new struct resource here?  Can't you just use the one
>> passed in from acpi_pci_root_add()?
>
> not quite sure about the life cycle for that object.

The struct acpi_pci_root is allocated in acpi_pci_root_add() and freed
in acpi_pci_root_remove(), so it should be safe for PCI to use.

Same thing applies for x86, of course.

Bjorn
