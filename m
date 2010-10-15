Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab0JOUK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:10:58 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:35507 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756947Ab0JOUK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:10:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=WAaJHW3DCNJcdmlY5EXDtrPcitHzV45Hy5WSManJKz4buqZnVk8H/xLJPeMcXg6Zjf7toWXAzA39CHvm6/jULe3s2C2MfHuslwZ1rBwGpoZqZaLYKfZ/TTuO4ZgUEBGz;
Date: Fri, 15 Oct 2010 13:10:33 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/5] pci: Export some PCI PM functionality
Message-ID: <20101015131033.141ba0e9@jbarnes-desktop>
In-Reply-To: <1286216549-5438-3-git-send-email-mjg@redhat.com>
References: <1286216549-5438-1-git-send-email-mjg@redhat.com>
	<1286216549-5438-3-git-send-email-mjg@redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  4 Oct 2010 14:22:26 -0400
Matthew Garrett <mjg@redhat.com> wrote:

> It's helpful to have some extra PCI power management functions available to
> platform code, so move the declarations to an exported header.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
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

Applied, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
