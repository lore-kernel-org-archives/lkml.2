Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740Ab2COSBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 14:01:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57453 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900Ab2COSBN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 14:01:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo4KhQJOpKk8OOtcSxWc3wwkhLix8ECZhGtTnQ2WgQH7iw@mail.gmail.com>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
	<1331362837-10740-25-git-send-email-yinghai@kernel.org>
	<CAErSpo6g3pei2+oW0wLEpytBTh6wGTyzo28oVVzFECxZdta+FA@mail.gmail.com>
	<CAE9FiQWfYxD2OAmXF5UdQMkPt33xeoSu489N6KtU3k5VE3jUXw@mail.gmail.com>
	<CAErSpo4KhQJOpKk8OOtcSxWc3wwkhLix8ECZhGtTnQ2WgQH7iw@mail.gmail.com>
Date: Thu, 15 Mar 2012 11:01:12 -0700
X-Google-Sender-Auth: jqfm3MrXmYTK4-3963uUx57vCsw
Message-ID: <CAE9FiQV8XsLZfZLLWsdkQ+EVvPV7Z70Xaz_utOcaDBU8hm4gpg@mail.gmail.com>
Subject: Re: [PATCH v2 24/37] PCI, ACPI: Add pci_root_hp hot removal
 notification support.
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 10:53 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> Sure, the 'echo "\_SB.PCIB 3" > /proc/acpi/sci/notify' way looks more
> like physical hotadd/remove because it is basically injecting the
> notify event that the hardware/BIOS should be generating itself.  But
> it is platform-specific and therefore unacceptable as a general user
> interface.
>
> Using /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/remove would be a
> more generic way.  The PNP0A08:00/remove implementation would
> basically turn into an acpi_pci_root_remove() call, just like the
> 'echo "\_SB.PCIB 3" > /proc/acpi/sci/notify' does.

if the users can not find _SB.PCIB etc, they may not find
LNXSYSTM:00/device:00/PNP0A08:00.

so /sys/class/pci_bus/0000:80/remove is more easy for them?

Yinghai
