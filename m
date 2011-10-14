Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab1JNErQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:47:16 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60088 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab1JNErL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:47:11 -0400
Date: Fri, 14 Oct 2011 00:46:54 -0400 (EDT)
Message-Id: <20111014.004654.210648346142583443.davem@davemloft.net>
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 14/29] sparc/PCI: convert to pci_create_root_bus()
 for correct root bus resources
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111014042818.23504.61318.stgit@bhelgaas.mtv.corp.google.com>
References: <20111014042142.23504.70417.stgit@bhelgaas.mtv.corp.google.com>
	<20111014042818.23504.61318.stgit@bhelgaas.mtv.corp.google.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 13 Oct 2011 21:47:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 13 Oct 2011 22:28:18 -0600

> Convert from pci_create_bus() to pci_create_root_bus().  This way the root
> bus resources are correct immediately.  This patch doesn't fix anything
> because sparc fixed them before scanning the bus, but it makes it more
> consistent with other architectures.
> 
> I didn't work out where pcibios_fixup_bus() is called.  I don't see a
> use of pci_scan_bus(), pci_scan_bus_parented(), or pci_scan_child_bus().
> 
> CC: David S. Miller <davem@davemloft.net>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

The pcibios_fixup_bus() case here (sparc64) is an artifact from when
we actually probed the PCI config space for device probing on sparc64,
and pci_bus_probe() would invoke it.

Unfortunately we can't delete this function now even though it's empty
with your changes, because drivers/pci/probe.o is unconditionally
linked into the kernel when CONFIG_PCI even when an architecture
(such as sparc64) doesn't use the majority of the code in it.

