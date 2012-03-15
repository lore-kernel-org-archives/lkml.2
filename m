Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031074Ab2COSKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 14:10:19 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48902 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755516Ab2COSKO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 14:10:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQV8XsLZfZLLWsdkQ+EVvPV7Z70Xaz_utOcaDBU8hm4gpg@mail.gmail.com>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
 <1331362837-10740-25-git-send-email-yinghai@kernel.org> <CAErSpo6g3pei2+oW0wLEpytBTh6wGTyzo28oVVzFECxZdta+FA@mail.gmail.com>
 <CAE9FiQWfYxD2OAmXF5UdQMkPt33xeoSu489N6KtU3k5VE3jUXw@mail.gmail.com>
 <CAErSpo4KhQJOpKk8OOtcSxWc3wwkhLix8ECZhGtTnQ2WgQH7iw@mail.gmail.com> <CAE9FiQV8XsLZfZLLWsdkQ+EVvPV7Z70Xaz_utOcaDBU8hm4gpg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 15 Mar 2012 12:09:53 -0600
Message-ID: <CAErSpo5ekRrLbs_53rvV4=7qKBucR0K-1hPqEHQG=Abau5A6XQ@mail.gmail.com>
Subject: Re: [PATCH v2 24/37] PCI, ACPI: Add pci_root_hp hot removal
 notification support.
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 12:01 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Thu, Mar 15, 2012 at 10:53 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> Sure, the 'echo "\_SB.PCIB 3" > /proc/acpi/sci/notify' way looks more
>> like physical hotadd/remove because it is basically injecting the
>> notify event that the hardware/BIOS should be generating itself.  But
>> it is platform-specific and therefore unacceptable as a general user
>> interface.
>>
>> Using /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/remove would be a
>> more generic way.  The PNP0A08:00/remove implementation would
>> basically turn into an acpi_pci_root_remove() call, just like the
>> 'echo "\_SB.PCIB 3" > /proc/acpi/sci/notify' does.
>
> if the users can not find _SB.PCIB etc, they may not find
> LNXSYSTM:00/device:00/PNP0A08:00.
>
> so /sys/class/pci_bus/0000:80/remove is more easy for them?

I don't think so.  LNXSYSTM:00/... is the canonical machine
description on x86.  I think there should probably be a link from the
PCI device to the upstream bridge.  The upstream bridge could be
either a P2P bridge or a host bridge.

Bjorn
