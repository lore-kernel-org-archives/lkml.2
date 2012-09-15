Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab2IOHcQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 03:32:16 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:55248 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab2IOHcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 03:32:12 -0400
MIME-Version: 1.0
In-Reply-To: <1347655456-2542-2-git-send-email-thierry.reding@avionic-design.de>
References: <1347655456-2542-1-git-send-email-thierry.reding@avionic-design.de>
	<1347655456-2542-2-git-send-email-thierry.reding@avionic-design.de>
Date: Sat, 15 Sep 2012 09:32:10 +0200
X-Google-Sender-Auth: CKlwSCtI1vW5-tlPeb5XFNsfC2c
Message-ID: <CAMuHMdWuR_tdMw9iVkaQ3D9p1HVU_L05ap=MzBuo1jLD6YdHHw@mail.gmail.com>
Subject: Re: [PATCH 2/2] PCI: Provide a default pcibios_update_irq()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Chris Zankel <chris@zankel.net>, Greg Ungerer <gerg@uclinux.org>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linux-m68k@vger.kernel.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 10:44 PM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> --- a/drivers/pci/setup-irq.c
> +++ b/drivers/pci/setup-irq.c
> @@ -17,6 +17,14 @@
>  #include <linux/ioport.h>
>  #include <linux/cache.h>
>
> +void __devinit __weak pcibios_update_irq(struct pci_dev *dev, int irq)
> +{
> +#ifdef CONFIG_PCI_DEBUG
> +       printk(KERN_DEBUG "PCI: Assigning IRQ %02d to %s\n", irq,
> +              pci_name(dev));

pr_debug()?
Or even better, dev_dbg()?

> +#endif
> +       pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
> +}

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
