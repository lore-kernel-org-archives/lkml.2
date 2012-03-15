Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031661Ab2COVJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:09:13 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43777 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031575Ab2COVJG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 17:09:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120313081235.GC15333@redhat.com>
References: <CANHD2=rF6dBkLLkWAj8uS3nq0B1wCt7Uvu=HzO84UNz2kuiaFg@mail.gmail.com>
 <20120313081235.GC15333@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 15 Mar 2012 15:08:43 -0600
Message-ID: <CAErSpo6t-cVBdJfyARi3ifEuBUvopbG5GQSP5YywrvumDK8HFA@mail.gmail.com>
Subject: Re: Initializing iwl3945 error
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Kamil Grzebien <ciptok@gmail.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 2:12 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Sun, Mar 11, 2012 at 05:43:26PM +0000, Kamil Grzebien wrote:
>> I've initialisation problem with my iwl3945 network card in Dell XPS
>> M1530 laptop. The issue is known and described in couple of bug
>> reports (eg. http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2143).
>> There are workarounds but I'd like to solve the problem permanently.
>> Basically when initializing I get:
>>
>> iwl3945 0000:0b:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ
>> iwl3945 0000:0b:00.0: setting latency timer to 64
>> iwl3945 0000:0b:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
>> iwl3945 0000:0b:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
>> ....
>> iwl3945 0000:0b:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
>> iwl3945 0000:0b:00.0: bad EEPROM signature,EEPROM_GP=0x00000007
>> iwl3945 0000:0b:00.0: EEPROM not found, EEPROM_GP=0xffffffff
> It's worth to mansion that this problem happen after wakeup from suspend
> to ram.
>
>> 1. Driver can't initialize card as all ioread32/iowrite32 seems to not
>> do their job. All reads finalize with 0xffffffff.
>>
>> However I can see that:
>> - pci_iomap(pdev, 0, 0) doesn't return error,
>> - pci_resource_start(pdev, 0) seems gives correct address (I can
>> compare it with the one I can see in /proc/iomem).
>>
>> If I access the memory directly, not by mapping, I can write and read
>> pci memory but driver load fails anyway. I don't understand why can't
>> access using mapped memory.
> How do you access memory directly ?
>
>> 2. If I check BASE_ADDRESS with setpci it doesn't give correct values:
>>
>> # setpci -v -s 0b:00.0 BASE_ADDRESS_0 BASE_ADDRESS_1
>> 0000:0b:00.0 @10 = 00000000
>> 0000:0b:00.0 @14 = 00000000
>>
>> Not sure if it's done by driver itself or it should point correct
>> values even if the driver wasn't fully loaded.
>>
>> Have you got any idea of:
>> - why IO memory isn't accessible? what could cause that?
>> - how APIC could change the load process in this particular case? (if
>> I boot with noapic kernel option it usually works fine)
> Is this really noapic or maybe noacpi ? ACPI manage PCIe devices.
>
>> This issue is reproducible in 100% on my system when I turn on the
>> machine. It doesn't occur after some work on it. I'd be very happy to
>> get rid of the issue.
>>
>> Could you point some ideas that might be worth checking in driver or
>> kernel please? I've tried couple of ideas but none worked for me.
>
> Would be good to check if pcie bridge is configured correctly after
> suspend to ram. But I don't know how to do this, that's why we are
> on linux-pci mailing list :-)
>
> Note we have similar bug report, which was actual regression and
> that problem is already fixed by PCI patch:
> http://marc.info/?l=linux-kernel&m=132577331232330&w=2

The bug report (http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2143)
has a lot of logs, but they're pretty old and I can't tell how
applicable they are to your situation.

It would be useful to see a complete dmesg log, /proc/iomem, and
"lspci -vv" output from your machine after the problem occurs, and
also the same information when it works (when using the noapic flag).

Bjorn
