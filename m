Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab1HXWli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:41:38 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:33453 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750915Ab1HXWlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:41:37 -0400
Subject: Re: [PATCH 1/5] xen-pcifront: Update warning comment to use
 'e820_host' option.
From: Joe Perches <joe@perches.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        JBeulich@novell.com, jeremy@goop.org, ian.campbell@citrix.com,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        stable@kernel.org
In-Reply-To: <1314225096-4861-2-git-send-email-konrad.wilk@oracle.com>
References: <1314225096-4861-1-git-send-email-konrad.wilk@oracle.com>
	 <1314225096-4861-2-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Aug 2011 15:41:33 -0700
Message-ID: <1314225693.15882.13.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-24 at 18:31 -0400, Konrad Rzeszutek Wilk wrote:
> With Xen changeset 23428 "libxl: Add 'e820_host' option to config file"
> the E820 as seen from the host can now be passed into the guest.
> This means that a PV guest can now:
>  - Use the correct PCI I/O gap. Before these patches, Linux guest would
>    boot up and would tell:
>    [    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:c0000000)
>    while in actuality the PCI I/O gap should have been:
>    [    0.000000] Allocating PCI resources starting at b0000000 (gap: b0000000:4c000000)
>  - The PV domain with PCI devices was limited to 3GB. It now can be booted
>    with 4GB, 8GB, or whatever number you want. The PCI devices will now _not_ conflict
>    with System RAM. Meaning the drivers can load.
[]
> diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
[]
> @@ -401,8 +401,8 @@ static int pcifront_claim_resource(struct pci_dev *dev, void *data)
>  				pci_name(dev), i);
>  			if (pci_claim_resource(dev, i)) {
>  				dev_err(&pdev->xdev->dev, "Could not claim "
> -					"resource %s/%d! Device offline. Try "
> -					"giving less than 4GB to domain.\n",
> +					"resource %s/%d! Device offline. Try"
> +					"using e820_host=1 in the guest config.\n",

Trivia: You lost the space after "Try".

It's generally better not to split format strings into
multiple pieces.

Perhaps:
 				dev_err(&pdev->xdev->dev, "Could not claim resource %s/%d! Device offline. Try using e820_host=1 in the guest config.\n",

or
 				dev_err(&pdev->xdev->dev, "Could not claim resource %s/%d! "
					"Device offline. Try using e820_host=1 in the guest config.\n",


