Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab0GNMq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 08:46:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32819 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab0GNMq4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 08:46:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=C6IDYXqSbdeKbwBjV3RtfUR80OfM9/m1Ei9hRvEla8KlJHcrQZGN724bCBaIuYxdWt
         +xZGGCBcnGTatVZ3hKaxszaa6EZV9kVKWvFQ/uhbab9wC9Yf+Hb5ixbinwBYt4YiBJxa
         fxJVdL0pT1QFzdKUxk8KWIm0HhnVO+X000+4Y=
MIME-Version: 1.0
In-Reply-To: <29013fb6eab9e95e95d61df894797d2455dfa10c.1279110894.git.siccegge@cs.fau.de>
References: <cover.1279110894.git.siccegge@cs.fau.de> <29013fb6eab9e95e95d61df894797d2455dfa10c.1279110894.git.siccegge@cs.fau.de>
From: Luis Correia <luis.f.correia@gmail.com>
Date: Wed, 14 Jul 2010 13:46:34 +0100
Message-ID: <AANLkTinO32CIe0HBTXjP_bcAz0nMEw6wvcZwcob1fX3r@mail.gmail.com>
Subject: Re: [PATCH 01/11] Removing dead RT2800PCI_SOC
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 13:39, Christoph Egger <siccegge@cs.fau.de> wrote:
> While RT2800PCI_SOC exists in Kconfig, it depends on either
> RALINK_RT288X or RALINK_RT305X which are both not available in Kconfig
> so all Code depending on that can't ever be selected and, if there's
> no plan to add these options, should be cleaned up
>
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>

NAK,

this is not dead code, it is needed for the Ralink System-on-Chip
Platform devices.

While I can't fix Kconfig errors and the current KConfig file may be
wrong, this code cannot and will not be deleted.

Luis Correia
rt2x00 project admin



> ---
>  drivers/net/wireless/rt2x00/Kconfig     |    5 ----
>  drivers/net/wireless/rt2x00/rt2800pci.c |   39 -------------------------------
>  2 files changed, 0 insertions(+), 44 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
> index eea1ef2..d59195a 100644
> --- a/drivers/net/wireless/rt2x00/Kconfig
> +++ b/drivers/net/wireless/rt2x00/Kconfig
> @@ -58,11 +58,6 @@ config RT2800PCI_PCI
>        depends on PCI
>        default y
>
> -config RT2800PCI_SOC
> -       boolean
> -       depends on RALINK_RT288X || RALINK_RT305X
> -       default y
> -
>  config RT2800PCI
>        tristate "Ralink rt28xx/rt30xx/rt35xx (PCI/PCIe/PCMCIA) support (EXPERIMENTAL)"
>        depends on (RT2800PCI_PCI || RT2800PCI_SOC) && EXPERIMENTAL
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index b2f2327..1445038 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -85,18 +85,9 @@ static void rt2800pci_mcu_status(struct rt2x00_dev *rt2x00dev, const u8 token)
>        rt2800_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
>  }
>
> -#ifdef CONFIG_RT2800PCI_SOC
> -static void rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
> -{
> -       u32 *base_addr = (u32 *) KSEG1ADDR(0x1F040000); /* XXX for RT3052 */
> -
> -       memcpy_fromio(rt2x00dev->eeprom, base_addr, EEPROM_SIZE);
> -}
> -#else
>  static inline void rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
>  {
>  }
> -#endif /* CONFIG_RT2800PCI_SOC */
>
>  #ifdef CONFIG_RT2800PCI_PCI
>  static void rt2800pci_eepromregister_read(struct eeprom_93cx6 *eeprom)
> @@ -1160,25 +1151,6 @@ MODULE_DEVICE_TABLE(pci, rt2800pci_device_table);
>  #endif /* CONFIG_RT2800PCI_PCI */
>  MODULE_LICENSE("GPL");
>
> -#ifdef CONFIG_RT2800PCI_SOC
> -static int rt2800soc_probe(struct platform_device *pdev)
> -{
> -       return rt2x00soc_probe(pdev, &rt2800pci_ops);
> -}
> -
> -static struct platform_driver rt2800soc_driver = {
> -       .driver         = {
> -               .name           = "rt2800_wmac",
> -               .owner          = THIS_MODULE,
> -               .mod_name       = KBUILD_MODNAME,
> -       },
> -       .probe          = rt2800soc_probe,
> -       .remove         = __devexit_p(rt2x00soc_remove),
> -       .suspend        = rt2x00soc_suspend,
> -       .resume         = rt2x00soc_resume,
> -};
> -#endif /* CONFIG_RT2800PCI_SOC */
> -
>  #ifdef CONFIG_RT2800PCI_PCI
>  static struct pci_driver rt2800pci_driver = {
>        .name           = KBUILD_MODNAME,
> @@ -1194,17 +1166,9 @@ static int __init rt2800pci_init(void)
>  {
>        int ret = 0;
>
> -#ifdef CONFIG_RT2800PCI_SOC
> -       ret = platform_driver_register(&rt2800soc_driver);
> -       if (ret)
> -               return ret;
> -#endif
>  #ifdef CONFIG_RT2800PCI_PCI
>        ret = pci_register_driver(&rt2800pci_driver);
>        if (ret) {
> -#ifdef CONFIG_RT2800PCI_SOC
> -               platform_driver_unregister(&rt2800soc_driver);
> -#endif
>                return ret;
>        }
>  #endif
> @@ -1217,9 +1181,6 @@ static void __exit rt2800pci_exit(void)
>  #ifdef CONFIG_RT2800PCI_PCI
>        pci_unregister_driver(&rt2800pci_driver);
>  #endif
> -#ifdef CONFIG_RT2800PCI_SOC
> -       platform_driver_unregister(&rt2800soc_driver);
> -#endif
>  }
>
>  module_init(rt2800pci_init);
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
