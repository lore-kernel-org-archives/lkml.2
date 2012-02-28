Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab2B1EjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 23:39:03 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40913 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235Ab2B1EjA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 23:39:00 -0500
MIME-Version: 1.0
In-Reply-To: <20120228142909.48fa1eea6980eaffa27abfdc@canb.auug.org.au>
References: <20120228142909.48fa1eea6980eaffa27abfdc@canb.auug.org.au>
Date: Mon, 27 Feb 2012 20:39:00 -0800
X-Google-Sender-Auth: liDr06lJBAEMgSUaQZx7gXbLe-k
Message-ID: <CAE9FiQXSoo4=4czdpPuz=txbyyG+sfJTvE-oAf3c5Z81oR2ing@mail.gmail.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the pci tree
From: Yinghai Lu <yinghai@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 7:29 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Greg,
>
> Today's linux-next merge of the driver-core tree got a conflict in
> include/linux/pci.h between commit 6754b9e9c335 ("PCI: Rename
> pci_remove_behind_bridge to pci_stop_and_remove_behind_bridge") from the
> pci tree and commit aad4f4000cec ("PCI: Add helper macro for
> pci_register_driver boilerplate") from the driver-core tree.
>
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc include/linux/pci.h
> index 5584aac,d4afd70..0000000
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@@ -947,7 -946,20 +947,20 @@@ int __must_check __pci_register_driver(
>        __pci_register_driver(driver, THIS_MODULE, KBUILD_MODNAME)
>
>  void pci_unregister_driver(struct pci_driver *dev);
> +
> + /**
> +  * module_pci_driver() - Helper macro for registering a PCI driver
> +  * @__pci_driver: pci_driver struct
> +  *
> +  * Helper macro for PCI drivers which do not do anything special in module
> +  * init/exit. This eliminates a lot of boilerplate. Each module may only
> +  * use this macro once, and calling it replaces module_init() and module_exit()
> +  */
> + #define module_pci_driver(__pci_driver) \
> +       module_driver(__pci_driver, pci_register_driver, \
> +                      pci_unregister_driver)
> +
>  -void pci_remove_behind_bridge(struct pci_dev *dev);
>  +void pci_stop_and_remove_behind_bridge(struct pci_dev *dev);
>  struct pci_driver *pci_dev_driver(const struct pci_dev *dev);
>  int pci_add_dynid(struct pci_driver *drv,
>                  unsigned int vendor, unsigned int device,


yes. we rename pci_remove_* to pci_stop_and_remove_*.

BTW, include/linux/pci.h looks like a mess. We should tidy it up

Thanks

Yinghai
