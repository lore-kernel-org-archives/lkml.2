Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab2FZEjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 00:39:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:41325 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab2FZEjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 00:39:44 -0400
Message-ID: <1340685471.3732.4.camel@pasglop>
Subject: Re: [PATCH 08/16] powerpc/PCI: Factor 'pcibios_setup()' out of
 powerpc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Myron Stowe <myron.stowe@redhat.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org, rth@twiddle.net,
        ink@jurassic.park.msu.ru, mattst88@gmail.com, linux@arm.linux.org.uk,
        starvik@axis.com, jesper.nilsson@axis.com, tony.luck@intel.com,
        fenghua.yu@intel.com, monstr@monstr.eu, ralf@linux-mips.org,
        yasutake.koichi@jp.panasonic.com, jejb@parisc-linux.org, deller@gmx.de,
        paulus@samba.org, lethal@linux-sh.org, davem@davemloft.net,
        cmetcalf@tilera.com, gxt@mprc.pku.edu.cn, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, chris@zankel.net,
        linux-kernel@vger.kernel.org
Date: Tue, 26 Jun 2012 14:37:51 +1000
In-Reply-To: <20120626033151.16434.33099.stgit@amt.stowe>
References: <20120626033045.16434.17412.stgit@amt.stowe>
	 <20120626033151.16434.33099.stgit@amt.stowe>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-25 at 21:31 -0600, Myron Stowe wrote:
> The PCI core provides a generic (__weak) 'pcibios_setup()' routine
> that can be used by all architectures as a default.  Drop powerpc's
> architecture specific version in favor of that as it does not need to be
> over-ridden.
> 
> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---

>  arch/powerpc/kernel/pci-common.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
> index 8e78e93..bf2306b 100644
> --- a/arch/powerpc/kernel/pci-common.c
> +++ b/arch/powerpc/kernel/pci-common.c
> @@ -200,11 +200,6 @@ int pcibios_add_platform_entries(struct pci_dev *pdev)
>  	return device_create_file(&pdev->dev, &dev_attr_devspec);
>  }
>  
> -char __devinit *pcibios_setup(char *str)
> -{
> -	return str;
> -}
> -
>  /*
>   * Reads the interrupt pin to determine if interrupt is use by card.
>   * If the interrupt is used, then gets the interrupt line from the
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


