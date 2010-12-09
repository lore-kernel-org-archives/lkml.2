Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab0LIVMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 16:12:12 -0500
Received: from claw.goop.org ([74.207.240.146]:53945 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab0LIVML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 16:12:11 -0500
Message-ID: <4D01462A.4010808@goop.org>
Date: Thu, 09 Dec 2010 13:12:10 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH] Fix when booting Xen+Linux under QEMU.
References: <1291928497-5599-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1291928497-5599-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2010 01:01 PM, Konrad Rzeszutek Wilk wrote:
> Please take a look. The first patch just cleans up the find_unbound_irq
> so it is easier to understand what it does.
>
> The second patch hardness the Xen IRQ (event channels) allocation finder
> if you try to boot a minimalistic 32-bit Linux kernel along with a
> Xen hypervisor under QEMU.
>
> We end up with a weird scenario where the nr_irq_gsi was greater than nr_irq
> by 16. This code hardness it by pointing out the issue to the user and tries
> to continue - BUT this might impact the PCI device allocation.
>
> Tested also on normal machine with no regressions found.

I think I'd prefer to:

   1. move to using all dynamic irqs, and use the core kernel irq
      allocator (ie, resurrect IanC's patches)
   2. kill the ioapic dummy page hack (I'm assuming that would be
      trivial - at least to make it all zero - because the kernel won't
      care about the number of GSIs at that point)

    J
