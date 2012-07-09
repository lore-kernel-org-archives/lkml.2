Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab2GIVLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 17:11:38 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50820 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab2GIVLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 17:11:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120709203203.28178.15800.stgit@bhelgaas.mtv.corp.google.com>
References: <20120709202308.28178.58942.stgit@bhelgaas.mtv.corp.google.com>
	<20120709203203.28178.15800.stgit@bhelgaas.mtv.corp.google.com>
Date: Mon, 9 Jul 2012 14:11:35 -0700
X-Google-Sender-Auth: uYyuV_gbqUj4srlcr7H2Fcc3vFU
Message-ID: <CAE9FiQW-6x_HrZQLmfw22Temvma7rd12qR3QfKj-Eh1tqWHHNQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] PCI: allow P2P bridge windows starting at PCI bus
 address zero
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, Daniel Yeisley <dan.yeisley@unisys.com>,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 1:32 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> cd81e1ea1a4c added checks that prevent us from using P2P bridge windows
> that start at PCI bus address zero.  The reason was to "prevent us from
> overwriting resources that are unassigned."
>
> But generic code should allow address zero in both BARs and bridge
> windows, so I think that commit was a mistake.
>
> Windows at bus address zero are legal and likely to exist on machines with
> an offset between bus addresses and CPU addresses.  For example, in the
> following hypothetical scenario, the bridge at 00:01.0 has a window at bus
> address zero and the device at 01:00.0 has a BAR at bus address zero, and
> I think both are perfectly valid:
>
>     PCI host bridge to bus 0000:00
>     pci_bus 0000:00: root bus resource [mem 0x100000000-0x1ffffffff] (bus address [0x00000000-0xffffffff])
>     pci 0000:00:01.0: PCI bridge to [bus 01]
>     pci 0000:00:01.0:   bridge window [mem 0x100000000-0x100ffffff]
>     pci 0000:01:00.0: reg 10: [mem 0x100000000-0x100ffffff]
>
> CC: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Acked-by: Yinghai Lu <yinghai@kernel.org>
