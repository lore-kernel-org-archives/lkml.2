Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab2IGIAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 04:00:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:58284 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657Ab2IGIAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 04:00:03 -0400
Message-ID: <1347004781.2385.54.camel@pasglop>
Subject: Re: [PATCH] powerpc/powernv: move the dereference below the NULL
 test
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: paulus@samba.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        yongjun_wei@trendmicro.com.cn, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Fri, 07 Sep 2012 17:59:41 +1000
In-Reply-To: <CAPgLHd_w9B8sHg9i9msFLx8FVBypqTtDEVOt1-VBNTW4zwHTMQ@mail.gmail.com>
References: <CAPgLHd_w9B8sHg9i9msFLx8FVBypqTtDEVOt1-VBNTW4zwHTMQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 14:45 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> The dereference should be moved below the NULL test.
> 
> spatch with a semantic match is used to found this.
> (http://coccinelle.lip6.fr/)

I haven't applied this patch yet (there was a similar one recently from
another semantic checker I believe) because that code is about to be
deeply reworked (waiting for some dependencies to get in), so this will
just make the patch harder to apply, and the stuff should never be NULL
in the first place anyway.

So let's leave that aside for a bit.

Cheers,
Ben.

> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  arch/powerpc/platforms/powernv/pci.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
> index be3cfc5..4ba89c1 100644
> --- a/arch/powerpc/platforms/powernv/pci.c
> +++ b/arch/powerpc/platforms/powernv/pci.c
> @@ -287,13 +287,15 @@ static int pnv_pci_read_config(struct pci_bus *bus,
>  			       int where, int size, u32 *val)
>  {
>  	struct pci_controller *hose = pci_bus_to_host(bus);
> -	struct pnv_phb *phb = hose->private_data;
> +	struct pnv_phb *phb;
>  	u32 bdfn = (((uint64_t)bus->number) << 8) | devfn;
>  	s64 rc;
>  
>  	if (hose == NULL)
>  		return PCIBIOS_DEVICE_NOT_FOUND;
>  
> +	phb = hose->private_data;
> +
>  	switch (size) {
>  	case 1: {
>  		u8 v8;
> @@ -331,12 +333,14 @@ static int pnv_pci_write_config(struct pci_bus *bus,
>  				int where, int size, u32 val)
>  {
>  	struct pci_controller *hose = pci_bus_to_host(bus);
> -	struct pnv_phb *phb = hose->private_data;
> +	struct pnv_phb *phb;
>  	u32 bdfn = (((uint64_t)bus->number) << 8) | devfn;
>  
>  	if (hose == NULL)
>  		return PCIBIOS_DEVICE_NOT_FOUND;
>  
> +	phb = hose->private_data;
> +
>  	cfg_dbg("pnv_pci_write_config bus: %x devfn: %x +%x/%x -> %08x\n",
>  		bus->number, devfn, where, size, val);
>  	switch (size) {


