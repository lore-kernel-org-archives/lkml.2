Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab2ITT1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 15:27:16 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36798 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093Ab2ITT1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 15:27:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC 2/3] PCI/PM: Make PCI devices notified when its power resource turned on
Date: Thu, 20 Sep 2012 21:33:44 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org
References: <1347872076-5260-1-git-send-email-ying.huang@intel.com> <1347872076-5260-3-git-send-email-ying.huang@intel.com>
In-Reply-To: <1347872076-5260-3-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201209202133.44738.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 17, 2012, Huang Ying wrote:
> A set of power resources may be shared by multiple devices.  When all
> devices share one set of power resources is put into D3_COLD state,
> the power resources will be turned off.  When one of the device is
> waked, the power resource will be turned on and all devices share it
> will be powered on to D0uninitialized state.  These devices should be
> resumed, so that they can get opportunity to go to low power state
> later.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Makes sense.

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  drivers/acpi/pci_bind.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- a/drivers/acpi/pci_bind.c
> +++ b/drivers/acpi/pci_bind.c
> @@ -45,6 +45,7 @@ static int acpi_pci_unbind(struct acpi_d
>  
>  	device_set_run_wake(&dev->dev, false);
>  	pci_acpi_remove_pm_notifier(device);
> +	acpi_power_resource_unregister_device(dev, device->handle);
>  
>  	if (!dev->subordinate)
>  		goto out;
> @@ -71,6 +72,7 @@ static int acpi_pci_bind(struct acpi_dev
>  		return 0;
>  
>  	pci_acpi_add_pm_notifier(device, dev);
> +	acpi_power_resource_register_device(dev, device->handle);
>  	if (device->wakeup.flags.run_wake)
>  		device_set_run_wake(&dev->dev, true);
>  
> 
> 

