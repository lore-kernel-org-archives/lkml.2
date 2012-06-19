Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab2FSMgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 08:36:44 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35102 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab2FSMgm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 08:36:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVzKr+nyBh=8-v+HEDF=7JqN2CqdTNx1=LHTq=c_OyZvg@mail.gmail.com>
References: <CAOPLpQfUm-2ENkbnYfXEn1nf9FHnaRk3aqQTSTBWb-CsfCUCFA@mail.gmail.com>
 <CAE9FiQU=Uvj_OFYQLdddf8j59vE7D0aE9cdNZv7P8_Rn7=MmUQ@mail.gmail.com>
 <CAErSpo57H_ZD_-Z8z9vD3c50My4Rejtc9gXXrxGxDtQomYmrSA@mail.gmail.com>
 <CAOPLpQeJTfB2UNy3O9FgRCyZb=LyMqd0SOsz7qDM0Ur_sfeNhg@mail.gmail.com> <CAE9FiQVzKr+nyBh=8-v+HEDF=7JqN2CqdTNx1=LHTq=c_OyZvg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 19 Jun 2012 06:36:20 -0600
Message-ID: <CAErSpo40SDii6PTNisAnsn6SoB7SzPUGztWAg9vaZZv+ByQsPw@mail.gmail.com>
Subject: Re: SNB PCI root information
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ulrich Drepper <drepper@gmail.com>, jbarnes@virtuousgeek.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lenb@kernel.org, x86@kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 5:40 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Jun 18, 2012 at 3:30 PM, Ulrich Drepper <drepper@gmail.com> wrote:
>> On Sat, Jun 16, 2012 at 5:56 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>> If ACPI provides a perfectly usable generic way to describe this
>>> topology and the vendor BIOS doesn't bother to use it, I'm not very
>>> interested in trying to compensate for that BIOS deficiency by adding
>>> a bunch of non-portable CPU-specific gunk to Linux.
>>
>> The problem is that all machines get this wrong.  I've tested varies
>> models from Dell and HP and none of them have the _PXM entry and the
>> local_cpus fields are wrong.  If there is a reasonably sane way to
>> compensate for broken BIOSes it should be considered.  We all know how
>> good BIOS authors are...
>
> please check attached one. and  you may append "pci=busnum_node=00:00,80:01"
> to change node for root bus.
> assume you have two root bus: 00, 80

I'm not opposed to something like this, if people think it's useful.

This patch sets the node quite early, before we even look at the _PXM
information in pci_acpi_scan_root().  That means if the BIOS does
supply a _PXM method and the user gives this argument, the
user-supplied info is silently overwritten.  To me it would make more
sense to handle an option like this *after* we look for _PXM info.
That way it could be used to compensate for both missing and incorrect
_PXM info.
