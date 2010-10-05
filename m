Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840Ab0JEXU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 19:20:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48385 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756452Ab0JEXU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 19:20:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 2/5] pci: Export some PCI PM functionality
Date: Wed, 6 Oct 2010 01:20:18 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <1286216549-5438-1-git-send-email-mjg@redhat.com> <1286216549-5438-3-git-send-email-mjg@redhat.com>
In-Reply-To: <1286216549-5438-3-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201010060120.19048.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 04, 2010, Matthew Garrett wrote:
> It's helpful to have some extra PCI power management functions available to
> platform code, so move the declarations to an exported header.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  drivers/pci/pci.h   |    3 ---
>  include/linux/pci.h |    3 +++
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index 6beb11b..f5c7c38 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -63,11 +63,8 @@ struct pci_platform_pm_ops {
>  extern int pci_set_platform_pm(struct pci_platform_pm_ops *ops);
>  extern void pci_update_current_state(struct pci_dev *dev, pci_power_t state);
>  extern void pci_disable_enabled_device(struct pci_dev *dev);
> -extern bool pci_check_pme_status(struct pci_dev *dev);
>  extern int pci_finish_runtime_suspend(struct pci_dev *dev);
> -extern void pci_wakeup_event(struct pci_dev *dev);
>  extern int __pci_pme_wakeup(struct pci_dev *dev, void *ign);
> -extern void pci_pme_wakeup_bus(struct pci_bus *bus);
>  extern void pci_pm_init(struct pci_dev *dev);
>  extern void platform_pci_wakeup_init(struct pci_dev *dev);
>  extern void pci_allocate_cap_save_buffers(struct pci_dev *dev);
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index c8d95e3..af03f47 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -819,6 +819,9 @@ pci_power_t pci_target_state(struct pci_dev *dev);
>  int pci_prepare_to_sleep(struct pci_dev *dev);
>  int pci_back_from_sleep(struct pci_dev *dev);
>  bool pci_dev_run_wake(struct pci_dev *dev);
> +bool pci_check_pme_status(struct pci_dev *dev);
> +void pci_wakeup_event(struct pci_dev *dev);
> +void pci_pme_wakeup_bus(struct pci_bus *bus);
>  
>  static inline int pci_enable_wake(struct pci_dev *dev, pci_power_t state,
>  				  bool enable)
> 

