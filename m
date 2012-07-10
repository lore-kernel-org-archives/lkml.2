Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab2GJPIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:08:30 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55008 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab2GJPI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:08:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo7zprm-iHMRbCp0xh0so_ozqvN1uF8P4UhsDV5c0tu_nw@mail.gmail.com>
References: <20120709202308.28178.58942.stgit@bhelgaas.mtv.corp.google.com> <CAErSpo7zprm-iHMRbCp0xh0so_ozqvN1uF8P4UhsDV5c0tu_nw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 10 Jul 2012 09:08:04 -0600
Message-ID: <CAErSpo6nTKrgFbfyjy4ekXhC+_6HKPkTz9G4ihaKb+W2dxmObw@mail.gmail.com>
Subject: Re: [PATCH 0/3] PCI: P2P bridge window fixes
To: linux-pci@vger.kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 9:24 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Mon, Jul 9, 2012 at 2:31 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> Two fixes here:
>>
>> 1) Zero is a legal P2P bridge window base and BAR value and is likely to
>> occur when there is an offset between bus addresses and CPU addresses.
>> Stop disallowing it.
>>
>> 2) The Intel-specific 1K I/O window granularity for P2P bridges was
>> implemented in a way that precluded reassignment of the window after
>> FINAL quirks.  Fix that.
>>
>> And also replace the sparc pci_cfg_fake_ranges() with the functionally
>> equivalent generic version.
>>
>> ---
>>
>> Bjorn Helgaas (3):
>>       PCI: allow P2P bridge windows starting at PCI bus address zero
>>       PCI: reimplement P2P bridge 1K I/O windows (Intel P64H2)
>>       sparc/PCI: replace pci_cfg_fake_ranges() with pci_read_bridge_bases()
>>
>>
>>  arch/sparc/kernel/pci.c  |   89 +---------------------------------------------
>>  drivers/pci/probe.c      |   31 +++++++++-------
>>  drivers/pci/quirks.c     |   39 +-------------------
>>  drivers/pci/setup-bus.c  |   11 +++++-
>>  include/linux/pci.h      |    1 +
>>  include/linux/pci_regs.h |    3 +-
>>  6 files changed, 31 insertions(+), 143 deletions(-)
>
> I applied these, as well as Yinghai's patch for 1K support in
> pbus_size_io(), to my "next" branch.  Thanks, Yinghai!

FYI, I just rebased my "next" branch to fix the authorship of
Yinghai's patch.  Only the merge of these four patches (the most
recent merge) is affected.
