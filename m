Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab2IRC7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 22:59:08 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:63176 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab2IRC7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 22:59:05 -0400
Message-ID: <5057E375.2050103@gmail.com>
Date: Mon, 17 Sep 2012 21:59:01 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: arnd@arndb.de, linux@arm.linux.org.uk, linaro-dev@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, tim@xen.org,
        Ian.Campbell@citrix.com, konrad.wilk@oracle.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        David Vrabel <david.vrabel@citrix.com>,
        Dave Martin <dave.martin@linaro.org>
Subject: Re: [PATCH v5 06/17] docs: Xen ARM DT bindings
References: <alpine.DEB.2.02.1209171215490.29232@kaball.uk.xensource.com> <1347903543-2135-6-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1347903543-2135-6-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2012 12:38 PM, Stefano Stabellini wrote:
> Add a doc to describe the Xen ARM device tree bindings
> 
> 
> Changes in v5:
> 
> - add a comment about the size of the grant table memory region;
> - add a comment about the required presence of a GIC node;
> - specify that the described properties are part of a top-level
> "hypervisor" node;
> - specify #address-cells and #size-cells for the example.
> 
> 
> Changes in v4:
> 
> - "xen,xen" should be last as it is less specific;
> - update reg property using 2 address-cells and 2 size-cells.
> 
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> CC: devicetree-discuss@lists.ozlabs.org
> CC: David Vrabel <david.vrabel@citrix.com>
> CC: Rob Herring <robherring2@gmail.com>
> CC: Dave Martin <dave.martin@linaro.org>

This is so minimal now and it doesn't seem to have any overlap with kvm, so:

Acked-by: Rob Herring <rob.herring@calxeda.com>

> ---
>  Documentation/devicetree/bindings/arm/xen.txt |   25 +++++++++++++++++++++++++
>  1 files changed, 25 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/xen.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm/xen.txt b/Documentation/devicetree/bindings/arm/xen.txt
> new file mode 100644
> index 0000000..0f7b9c2
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/xen.txt
> @@ -0,0 +1,25 @@
> +* Xen hypervisor device tree bindings
> +
> +Xen ARM virtual platforms shall have a top-level "hypervisor" node with
> +the following properties:
> +
> +- compatible:
> +	compatible = "xen,xen-<version>", "xen,xen";
> +  where <version> is the version of the Xen ABI of the platform.
> +
> +- reg: specifies the base physical address and size of a region in
> +  memory where the grant table should be mapped to, using an
> +  HYPERVISOR_memory_op hypercall. The memory region is large enough to map
> +  the whole grant table (it is larger or equal to gnttab_max_grant_frames()).
> +
> +- interrupts: the interrupt used by Xen to inject event notifications.
> +  A GIC node is also required.
> +
> +
> +Example (assuming #address-cells = <2> and #size-cells = <2>):
> +
> +hypervisor {
> +	compatible = "xen,xen-4.3", "xen,xen";
> +	reg = <0 0xb0000000 0 0x20000>;
> +	interrupts = <1 15 0xf08>;
> +};
> 

