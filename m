Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443Ab2GKXNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 19:13:18 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37451 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab2GKXNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 19:13:15 -0400
MIME-Version: 1.0
In-Reply-To: <1340222160.77018.19.camel@localhost.localdomain>
References: <1340222160.77018.19.camel@localhost.localdomain>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 11 Jul 2012 17:12:53 -0600
Message-ID: <CAErSpo5wdxqc7w0Zn-Z9-Uog8GyDqJytV5a5Uxdf39BwaXF2Hw@mail.gmail.com>
Subject: Re: [PATCH] pci: 64bit resource fix in setup-res.c
To: Nikhil P Rao <nikhil.rao@intel.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 1:56 PM, Nikhil P Rao <nikhil.rao@intel.com> wrote:
> size parameter of _pci_assign_resource() needs to be
> of type resource_size_t rather than int
>
> Signed-off-by: Nikhil P Rao <nikhil.rao@intel.com>
> ---
>  drivers/pci/setup-res.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
> index eea85da..9f6bbec 100644
> --- a/drivers/pci/setup-res.c
> +++ b/drivers/pci/setup-res.c
> @@ -206,7 +206,8 @@ static int pci_revert_fw_address(struct resource *res, struct pci_dev *dev,
>         return ret;
>  }
>
> -static int _pci_assign_resource(struct pci_dev *dev, int resno, int size, resource_size_t min_align)
> +static int _pci_assign_resource(struct pci_dev *dev, int resno,
> +               resource_size_t size, resource_size_t min_align)
>  {
>         struct resource *res = dev->resource + resno;
>         struct pci_bus *bus;

I applied this, thanks!  Sorry it took so long.

Bjorn
