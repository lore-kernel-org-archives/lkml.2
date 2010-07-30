Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab0G3Qsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 12:48:42 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:51624 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754149Ab0G3Qsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 12:48:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=NV5+NT4DRZWzZw+7WMkRz6WYBPlnMCDh6/ri30fw8r+JALUGW568Xsdgun60AZrI2QJVf04bUXCYgpgxz8xgC2393xmGvhNYzr+QfKuof7dLlQleLSWKHxVMVKddH0nA;
Date: Fri, 30 Jul 2010 09:48:33 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/19] drivers/pci: use for_each_pci_dev()
Message-ID: <20100730094833.47a3e638@virtuousgeek.org>
In-Reply-To: <1278173080-11983-1-git-send-email-segooon@gmail.com>
References: <1278173080-11983-1-git-send-email-segooon@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  3 Jul 2010 20:04:39 +0400
Kulikov Vasiliy <segooon@gmail.com> wrote:

> Use for_each_pci_dev() to simplify the code.
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/pci/setup-irq.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/setup-irq.c b/drivers/pci/setup-irq.c
> index aa795fd..eec9738 100644
> --- a/drivers/pci/setup-irq.c
> +++ b/drivers/pci/setup-irq.c
> @@ -59,7 +59,6 @@ pci_fixup_irqs(u8 (*swizzle)(struct pci_dev *, u8 *),
>  	       int (*map_irq)(struct pci_dev *, u8, u8))
>  {
>  	struct pci_dev *dev = NULL;
> -	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
> +	for_each_pci_dev(dev)
>  		pdev_fixup_irq(dev, swizzle, map_irq);
> -	}
>  }

Applied all of these to my linux-next branch.  I squashed all the PCI
ones into a single commit, keeping only the x86 one separate.

-- 
Jesse Barnes, Intel Open Source Technology Center
