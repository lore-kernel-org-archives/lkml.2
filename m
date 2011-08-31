Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab1HaEvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 00:51:23 -0400
Received: from dns1.mips.com ([12.201.5.69]:36524 "EHLO dns1.mips.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab1HaEvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 00:51:19 -0400
Message-ID: <4E5DBDB0.4070505@mips.com>
Date: Wed, 31 Aug 2011 12:50:56 +0800
From: Deng-Cheng Zhu <dczhu@mips.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <jbarnes@virtuousgeek.org>, <ralf@linux-mips.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mips@linux-mips.org>, <eyal@mips.com>, <zenon@mips.com>,
        <dengcheng.zhu@gmail.com>
Subject: Re: [PATCH v3 0/2] Pass resources to pci_create_bus() and fix MIPS
 PCI resources
References: <1314349633-13155-1-git-send-email-dczhu@mips.com> <CAErSpo5PgXs4tuihh_JZCePzD8FWWzwp=-VHxFGCCuRKRKOYFQ@mail.gmail.com> <CAErSpo506Mz3QSxxdpbxyCUuZvqMTNL+fT5R81ivoj7cDTFyJg@mail.gmail.com>
In-Reply-To: <CAErSpo506Mz3QSxxdpbxyCUuZvqMTNL+fT5R81ivoj7cDTFyJg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EMS-Proccessed: 6LP3oGfGVdcdb8o1aBnt6w==
X-EMS-STAMP: PMtX6M7dXgAgJc+1chgFwQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Bjorn


Thanks for your constructive review.

> One logistical issue here is that the first patch touches several
> architectures at once, which puts Jesse in a bit of a pinch.  If he
> applies it, there's always the possibility that an arch patch will
> conflict with it, which makes merging harder.

In case the conflicts happen, the effort to resolve them should be
trivial (a matter of an extra NULL argument), I suppose. Also, the odds
of other incoming arch patches making a reference to pci_create_bus()
should not be great.

> It might be easier if, instead of changing the pci_create_bus()
> interface, you added a new one (it could call pci_create_bus() then
> replace the resources, so the implementation could still be mostly
> shared.)  We already have a plethora of "create bus" methods
> (pci_create_bus(), pci_scan_bus_parented(), pci_scan_bus()), but if
> you added a pci_create_root_bus() or something similar, maybe we could
> try to converge on it and obsolete the others.
>
> Then the first patch would touch only the PCI core, and the second
> would touch only MIPS, which would make merging more straightforward.
>

Hmm.. Adding a wrapper of pci_create_bus() does leave other
architectures alone for this merging. But before all of them converge on
it (a long way to go), the wrapper is adding naming confusion to the
PCI core. Personally I think the current low-level transparent change to
pci_create_bus() is appropriate enough. Does anybody have comments?


Deng-Cheng
