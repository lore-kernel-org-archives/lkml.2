Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab1KPTvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 14:51:33 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46376 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1KPTvc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 14:51:32 -0500
MIME-Version: 1.0
In-Reply-To: <1321440940-20246-2-git-send-email-xsecute@googlemail.com>
References: <1321440940-20246-1-git-send-email-xsecute@googlemail.com> <1321440940-20246-2-git-send-email-xsecute@googlemail.com>
From: Manuel Lauss <manuel.lauss@googlemail.com>
Date: Wed, 16 Nov 2011 20:50:51 +0100
Message-ID: <CAOLZvyENpkRs7RtsUkeBHb-JdYTq1gV3D0m82ukH1m6SGcaT8w@mail.gmail.com>
Subject: Re: [PATCH 1/2] Initial PCI support for Atheros 724x SoCs.
To: Rene Bolldorf <xsecute@googlemail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Howdy,

On Wed, Nov 16, 2011 at 11:55 AM, Rene Bolldorf <xsecute@googlemail.com> wrote:
> Signed-off-by: Rene Bolldorf <xsecute@googlemail.com>
> ---
>  arch/mips/pci/Makefile      |    1 +
>  arch/mips/pci/ops-ath724x.c |  109 +++++++++++++++++++++++++++++++++++++++++++
>  arch/mips/pci/pci-ath724x.c |   45 ++++++++++++++++++

Why don't you just merge ops-ath724x.c into pci-ath724x.c?  (the only
place where its
contents are referenced)


> diff --git a/arch/mips/pci/ops-ath724x.c b/arch/mips/pci/ops-ath724x.c
> new file mode 100644
> index 0000000..bd3cf15
> --- /dev/null
> +++ b/arch/mips/pci/ops-ath724x.c
> @@ -0,0 +1,109 @@
[...]
> +static int ath724x_pci_read(struct pci_bus *bus, unsigned int devfn, int where,
> +                           int size, uint32_t *value)
> +{
> +       unsigned long flags, addr, tval, mask;
> +
> +       if(devfn)
> +               return PCIBIOS_DEVICE_NOT_FOUND;
> +
> +       if(where & (size - 1))
> +               return PCIBIOS_BAD_REGISTER_NUMBER;

Please run both patches through checkpatch once and fix up the
codingstyle issues it
will complain about (like the two above).


Thanks,
        Manuel Lauss
