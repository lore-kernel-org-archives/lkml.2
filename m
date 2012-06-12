Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab2FLPcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:32:14 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49090 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab2FLPcK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:32:10 -0400
MIME-Version: 1.0
In-Reply-To: <20120612145441.400975347f06785d391d0f8f@canb.auug.org.au>
References: <20120612145441.400975347f06785d391d0f8f@canb.auug.org.au>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 12 Jun 2012 09:31:49 -0600
Message-ID: <CAErSpo6LxpYz_WK2mHPW3RWkOMPLar0KUp1Pgh7shhOdmT49kw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (pci tree related)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 10:54 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the final tree, today's linux-next build (sparc64 defconfig)
> failed like this:
>
> arch/sparc/kernel/pci.c: In function 'pci_scan_one_pbm':
> arch/sparc/kernel/pci.c:689:21: error: 'struct pci_pbm_info' has no member named 'pci_last_busn'
>
> Caused by commit 2c7f691b032b ("sparc/PCI: register busn_res for root buses").
>
> I have added the following patch for today:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 12 Jun 2012 14:48:39 +1000
> Subject: [PATCH] sparc/PCI: fix typo
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/sparc/kernel/pci.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
> index 74e4bf3..4f92a9a 100644
> --- a/arch/sparc/kernel/pci.c
> +++ b/arch/sparc/kernel/pci.c
> @@ -686,7 +686,7 @@ struct pci_bus * __devinit pci_scan_one_pbm(struct pci_pbm_info *pbm,
>        pci_add_resource_offset(&resources, &pbm->mem_space,
>                                pbm->mem_space.start);
>        pbm->busn.start = pbm->pci_first_busno;
> -       pbm->busn.end   = pbm->pci_last_busn;
> +       pbm->busn.end   = pbm->pci_last_busno;
>        pbm->busn.flags = IORESOURCE_BUS;
>        pci_add_resource(&resources, &pbm->busn);
>        bus = pci_create_root_bus(parent, pbm->pci_first_busno, pbm->pci_ops,

Thanks, I folded this typo fix into the relevant patch.  I'll rebase
"next" today.  Sorry for the trouble.

Bjorn
