Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab2DPWUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 18:20:46 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40610 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2DPWUo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 18:20:44 -0400
MIME-Version: 1.0
In-Reply-To: <4F8C780D.9010702@xenotime.net>
References: <20120416161121.261ba4e7e38989173accfb16@canb.auug.org.au> <4F8C780D.9010702@xenotime.net>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Mon, 16 Apr 2012 18:20:12 -0400
X-Google-Sender-Auth: Z3_PX0yXNuUArxtttIODN_ngURQ
Message-ID: <CAP=VYLr6TtABMNz1EBY2T6vYdhpR5X6S3yQTtvvqV0D7c9U5Lw@mail.gmail.com>
Subject: Re: [PATCH -next] mtd: fix sbc2_flash build when PCI is not enabled
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Tim Hockin <thockin@sun.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 3:50 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>
> sbc2_flash.c is a PCI driver, but its build fails when CONFIG_PCI

Minor nit -- above line and subject reference sbc2, when fail comes
from scb2 source module.

Paul.
--

> is not enabled, so make it depend on PCI.
>
> drivers/mtd/maps/scb2_flash.c:237:1: warning: data definition has no type or storage class
> drivers/mtd/maps/scb2_flash.c:237:1: warning: type defaults to 'int' in declaration of 'module_pci_driver'
> drivers/mtd/maps/scb2_flash.c:237:1: warning: parameter names (without types) in function declaration
>
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc:     David Woodhouse <dwmw2@infradead.org>
> Cc:     linux-mtd@lists.infradead.org
> ---
>  drivers/mtd/maps/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-next-20120416.orig/drivers/mtd/maps/Kconfig
> +++ linux-next-20120416/drivers/mtd/maps/Kconfig
> @@ -224,7 +224,7 @@ config MTD_CK804XROM
>
>  config MTD_SCB2_FLASH
>        tristate "BIOS flash chip on Intel SCB2 boards"
> -       depends on X86 && MTD_JEDECPROBE
> +       depends on X86 && MTD_JEDECPROBE && PCI
>        help
>          Support for treating the BIOS flash chip on Intel SCB2 boards
>          as an MTD device - with this you can reprogram your BIOS.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
