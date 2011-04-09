Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab1DILex (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 07:34:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38306 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab1DILev convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 07:34:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PAb65SfakdyliRO0uBECS2lyUC3AXrs4uSwx7Ddo4Ps43OJ2rGFaR28FGt7F2k1lem
         01AHA0bF6q4A3JNearvOW8xfNYj63p0rMR9uTPpNBVun1NSgxym/Gob4sK7837AFzMM8
         EcVttCM6fJCOu7VNVMun0xebmEE3jS6E67K3M=
MIME-Version: 1.0
In-Reply-To: <20110408083215.6b3b0bfe.randy.dunlap@oracle.com>
References: <20110408083215.6b3b0bfe.randy.dunlap@oracle.com>
Date: Sat, 9 Apr 2011 13:34:49 +0200
X-Google-Sender-Auth: mrMoqaKHetHcls9AoJQWVnwXGMs
Message-ID: <BANLkTikX_rG+6Eg4owary1YRGRG8NzyrGQ@mail.gmail.com>
Subject: Re: [PATCH -next reresend] i2c: designware-pcidrv depends on PCI
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Baruch Siach <baruch@tkos.co.il>,
        linux-i2c@vger.kernel.org, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, khali@linux-fr.org,
        ben-linux@fluff.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 8, 2011 at 17:32, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> i2c-designware-pcidrv is a PCI driver and should depend on PCI.
> Fixes these build errors:
>
> drivers/i2c/busses/i2c-designware-pcidrv.c:256: error: implicit declaration of function 'pci_request_region'
> drivers/i2c/busses/i2c-designware-pcidrv.c:338: error: implicit declaration of function 'pci_release_region'
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Baruch Siach <baruch@tkos.co.il>
> ---
>  drivers/i2c/busses/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
>
> Does anybody merge i2c patches???

Yes please, it's been there since Mar 17, reported several times, and probably
masking other build failures.

> --- linux-next-20110316.orig/drivers/i2c/busses/Kconfig
> +++ linux-next-20110316/drivers/i2c/busses/Kconfig
> @@ -359,6 +359,7 @@ config I2C_DESIGNWARE_PLATFORM
>
>  config I2C_DESIGNWARE_PCI
>        tristate "Synopsys DesignWare PCI"
> +       depends on PCI
>        help
>          If you say yes to this option, support will be included for the
>          Synopsys DesignWare I2C adapter. Only master mode is supported.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
