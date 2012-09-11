Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab2IKO3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:29:05 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58867 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab2IKO3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:29:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120911112924.c2206bc738a2c29259f6e2d8@canb.auug.org.au>
References: <20120911112924.c2206bc738a2c29259f6e2d8@canb.auug.org.au>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 11 Sep 2012 08:28:39 -0600
Message-ID: <CAErSpo5Qoq6J7gB3o7Oc_YwfBXkXy8vHvbBXHkvb93CHYGHb4g@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the pci tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        Yijing Wang <wangyijing@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 7:29 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Bjorn,
>
> After merging the pci tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> arch/powerpc/platforms/powernv/pci-ioda.c: In function 'pnv_pci_window_alignment':
> arch/powerpc/platforms/powernv/pci-ioda.c:1163:13: error: 'struct pci_dev' has no member named 'pcie_type'
>
> Caused by commit ac161fbfdaa2 ("powerpc/powernv: I/O and memory alignment
> for P2P bridges").  pcie_type was removed in commit b2ef39be5744 ("PCI:
> Remove unused field pcie_type from struct pci_dev") (also in the pci
> tree).
>
> I have used the pci tree from next-20120910 for today.

Thanks.

Gavin, Ben, I folded in the trivial fix and updated both my
pci/gavin-window-alignment and next branches.

Ben, I think you'll need to pull in pci/jiang-pcie-cap before
pci/gavin-window-alignment to get both pieces.

Bjorn
