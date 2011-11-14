Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449Ab1KNVD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 16:03:59 -0500
Received: from lo.gmane.org ([80.91.229.12]:60150 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756293Ab1KNVD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 16:03:59 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andres Salomon <dilinger@queued.net>
Subject: Re: [PATCH] cs5535-mfd: fix section mismatch
Date: Mon, 14 Nov 2011 13:03:43 -0800
Message-ID: <20111114130343.0f96beaf@queued.net>
References: <4772540.dYKFp8bB6F@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: c-67-171-33-194.hsd1.wa.comcast.net
In-Reply-To: <4772540.dYKFp8bB6F@localhost>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Andres Salomon <dilinger@queued.net>

On Mon, 14 Nov 2011
20:12:24 +0000 Christian Gmeiner <christian.gmeiner@gmail.com> wrote:

> Silence following warnings:
> WARNING: drivers/mfd/cs5535-mfd.o(.data+0x20): Section mismatch in
> reference from the variable cs5535_mfd_drv to the
> function .devinit.text:cs5535_mfd_probe() The variable cs5535_mfd_drv
> references the function __devinit cs5535_mfd_probe() If the reference
> is valid then annotate the variable with __init* or __refdata (see
> linux/init.h) or name the variable: *driver, *_template, *_timer,
> *_sht, *_ops, *_probe, *_probe_one, *_console
> 
> WARNING: drivers/mfd/cs5535-mfd.o(.data+0x28): Section mismatch in
> reference from the variable cs5535_mfd_drv to the
> function .devexit.text:cs5535_mfd_remove() The variable
> cs5535_mfd_drv references the function __devexit cs5535_mfd_remove()
> If the reference is valid then annotate the variable with __exit*
> (see linux/init.h) or name the variable: *driver, *_template,
> *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
> 
> Rename the variable from *_drv to *_driver so
> modpost ignore the OK references to __devinit/__devexit
> functions.
> 
> Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
> --
> diff --git a/drivers/mfd/cs5535-mfd.c b/drivers/mfd/cs5535-mfd.c
> index 155fa04..e488a78 100644
> --- a/drivers/mfd/cs5535-mfd.c
> +++ b/drivers/mfd/cs5535-mfd.c
> @@ -179,7 +179,7 @@ static struct pci_device_id cs5535_mfd_pci_tbl[]
> = { };
>  MODULE_DEVICE_TABLE(pci, cs5535_mfd_pci_tbl);
>  
> -static struct pci_driver cs5535_mfd_drv = {
> +static struct pci_driver cs5535_mfd_driver = {
>         .name = DRV_NAME,
>         .id_table = cs5535_mfd_pci_tbl,
>         .probe = cs5535_mfd_probe,
> @@ -188,12 +188,12 @@ static struct pci_driver cs5535_mfd_drv = {
>  
>  static int __init cs5535_mfd_init(void)
>  {
> -       return pci_register_driver(&cs5535_mfd_drv);
> +       return pci_register_driver(&cs5535_mfd_driver);
>  }
>  
>  static void __exit cs5535_mfd_exit(void)
>  {
> -       pci_unregister_driver(&cs5535_mfd_drv);
> +       pci_unregister_driver(&cs5535_mfd_driver);
>  }
>  
>  module_init(cs5535_mfd_init);
> --
> 1.7.3.1


