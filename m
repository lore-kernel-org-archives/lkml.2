Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161161Ab2JXU6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 16:58:06 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:35386 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374Ab2JXU6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 16:58:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Huang Ying <ying.huang@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [BUGFIX 2/2] PCI/PM: Resume device before shutdown
Date: Wed, 24 Oct 2012 23:01:55 +0200
Message-ID: <3990336.eisiEt4Bt9@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1351061654-8339-2-git-send-email-ying.huang@intel.com>
References: <1351061654-8339-1-git-send-email-ying.huang@intel.com> <1351061654-8339-2-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 of October 2012 14:54:14 Huang Ying wrote:
> Some actions during shutdown need device to be in D0 state, such as
> MSI shutdown etc, so resume device before shutdown.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  drivers/pci/pci-driver.c |   12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -398,6 +398,8 @@ static void pci_device_shutdown(struct d
>  	struct pci_dev *pci_dev = to_pci_dev(dev);
>  	struct pci_driver *drv = pci_dev->driver;
>  
> +	pm_runtime_resume(dev);
> +
>  	if (drv && drv->shutdown)
>  		drv->shutdown(pci_dev);
>  	pci_msi_shutdown(pci_dev);
> @@ -408,16 +410,6 @@ static void pci_device_shutdown(struct d
>  	 * continue to do DMA
>  	 */
>  	pci_disable_device(pci_dev);
> -
> -	/*
> -	 * Devices may be enabled to wake up by runtime PM, but they need not
> -	 * be supposed to wake up the system from its "power off" state (e.g.
> -	 * ACPI S5).  Therefore disable wakeup for all devices that aren't
> -	 * supposed to wake up the system at this point.  The state argument
> -	 * will be ignored by pci_enable_wake().
> -	 */
> -	if (!device_may_wakeup(dev))
> -		pci_enable_wake(pci_dev, PCI_UNKNOWN, false);
>  }
>  
>  #ifdef CONFIG_PM
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
