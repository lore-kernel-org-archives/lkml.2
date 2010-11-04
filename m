Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab0KDS1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 14:27:16 -0400
Received: from mail4.comsite.net ([205.238.176.238]:63612 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab0KDS1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 14:27:15 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 1/1] PCI: xen-pcifront, fix PCI reference leak
In-Reply-To: <1288881090-27335-1-git-send-email-jslaby@suse.cz>
References: <1288881090-27335-1-git-send-email-jslaby@suse.cz>
Message-Id: <xenfront-reffix-fixreq@mdm.bga.com>
Date: Thu, 04 Nov 2010 12:27:07 -0600
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-04 at about 14:31:30 Jiri Slaby wrote:
> Stanse found that when pdev is found and has no driver a reference is
> leaked in pcifront_common_process. So add pci_dev_put there. For the
> pdev == NULL case, pci_dev_put(NULL) is fine.

While that may be true, the dev_err(&pcidev->dev ... is a NULL pointer
deref.

> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> ---
>  drivers/pci/xen-pcifront.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
> index a87c498..f9ffc05 100644
> --- a/drivers/pci/xen-pcifront.c
> +++ b/drivers/pci/xen-pcifront.c
> @@ -578,6 +578,7 @@  static pci_ers_result_t pcifront_common_process(int cmd,
>  	if (!pcidev || !pcidev->driver) {
>  		dev_err(&pcidev->dev,
>  			"device or driver is NULL\n");
> +		pci_dev_put(pcidev);
>  		return result;
>  	}
>  	pdrv = pcidev->driver;
> 

milton
