Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab1BIQns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 11:43:48 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40438 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab1BIQnr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 11:43:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZLwSjVE3UmQEOn1s/WK7WT1DMOkfCNqc68gFeK0r63AwePp5sSWIHFIJPe3OyNAMNZ
         jf1JS7Ds2Jb/gYdW5oI95Z8PhtzoaAfkRZe1SNrZC1oDCWG+/K2Bi4/ClEhcHWKKnGnC
         +4hxpknMmfVLofXPhSBzW7bC7AQVrSeidkoNc=
MIME-Version: 1.0
In-Reply-To: <4D52AF15.5070705@pavlinux.ru>
References: <4D52AF15.5070705@pavlinux.ru>
Date: Wed, 9 Feb 2011 08:43:46 -0800
X-Google-Sender-Auth: NX4h5BWynJc-o4CpKgM5zaTUr8M
Message-ID: <AANLkTindvfxRfgRbLprzX5b2u-4P-XZmycV=ai9ez6H1@mail.gmail.com>
Subject: Re: [PATCH]: Not PCI_PROBE_MMCONF by default
From: Yinghai Lu <yinghai@kernel.org>
To: pavel@pavlinux.ru
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 9, 2011 at 7:13 AM, Pavel Vasilyev <pavel@pavlinux.ru> wrote:
> Hi All!
>
> Do not set PCI_PROBE_MMCONF flag by default, and enable
> only if configured with  CONFIG_PCI_MMCONFIG
>
> Signed-off-by: Pavel Vasilyev <pavel@pavlinux.ru>
> ---
>  arch/x86/pci/common.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
> index 5fe7502..625b477 100644
> --- a/arch/x86/pci/common.c
> +++ b/arch/x86/pci/common.c
> @@ -17,8 +17,7 @@
>  #include <asm/smp.h>
>  #include <asm/pci_x86.h>
>
> -unsigned int pci_probe = PCI_PROBE_BIOS | PCI_PROBE_CONF1 | PCI_PROBE_CONF2 |
> -                               PCI_PROBE_MMCONF;
> +unsigned int pci_probe = PCI_PROBE_BIOS | PCI_PROBE_CONF1 | PCI_PROBE_CONF2;
>
>  unsigned int pci_early_dump_regs;
>  static int pci_bf_sort;
> @@ -535,6 +534,9 @@ char * __devinit  pcibios_setup(char *str)
>        }
>  #endif
>  #ifdef CONFIG_PCI_MMCONFIG
> +
> +       pci_probe |= PCI_PROBE_MMCONF;
> +
>        else if (!strcmp(str, "nommconf")) {
>                pci_probe &= ~PCI_PROBE_MMCONF;
>                return NULL;
>

did you try to do the compile test with CONFIG_PCI_MMCONFIG?

Yinghai
