Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab2IIQy6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 12:54:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46668 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab2IIQy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 12:54:56 -0400
MIME-Version: 1.0
In-Reply-To: <1346621844-31211-1-git-send-email-minipli@googlemail.com>
References: <1346621844-31211-1-git-send-email-minipli@googlemail.com>
Date: Sun, 9 Sep 2012 18:54:56 +0200
Message-ID: <CA+rthh-nAf8jejcfqjT+uBSVNjpv4y_+tzUD4P7p9TcW1furHA@mail.gmail.com>
Subject: Re: [PATCH] PCI: drop duplicate const in DECLARE_PCI_FIXUP_SECTION
From: Mathias Krause <minipli@googlemail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 2, 2012 at 11:37 PM, Mathias Krause <minipli@googlemail.com> wrote:
> It's redundant and makes sparse complain about it.
>
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> ---
>  include/linux/pci.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 5faa831..aee24a8 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1472,7 +1472,7 @@ enum pci_fixup_pass {
>  /* Anonymous variables would be nice... */
>  #define DECLARE_PCI_FIXUP_SECTION(section, name, vendor, device, class,        \
>                                   class_shift, hook)                    \
> -       static const struct pci_fixup const __pci_fixup_##name __used   \
> +       static const struct pci_fixup __pci_fixup_##name __used         \
>         __attribute__((__section__(#section), aligned((sizeof(void *)))))    \
>                 = { vendor, device, class, class_shift, hook };
>
> --
> 1.7.10.4
>

Ping? It's janitor work, but hey, it fixes a sparse warning.

Mathias
