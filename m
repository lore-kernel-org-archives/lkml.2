Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab0J3VR4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:17:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37460 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab0J3VRu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:17:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=NAWDSPHLaz7AQXwm2Q3VBBUI4YbTZZC6sEdul8lCP9+uPnlbjP7Xl64rbY29QYaeQx
         hrr7XToPwz7v06iZK5rv6aivB08OhIpvxAf+7/NcFS4rFascCajsAkgzQvcYQJnN0iW1
         Y0fzzzdC9sg8++J8ky58gK8zLwAk2LRRYvQhI=
MIME-Version: 1.0
In-Reply-To: <517a3d5c620dd4843a35a05c9a1c123b4b936cd9.1288471898.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com> <517a3d5c620dd4843a35a05c9a1c123b4b936cd9.1288471898.git.joe@perches.com>
From: Matt Turner <mattst88@gmail.com>
Date: Sat, 30 Oct 2010 17:17:28 -0400
Message-ID: <AANLkTi=Po5RaY-mL62trrVm+kuK=0JV7z2oQcDJek4kE@mail.gmail.com>
Subject: Re: [PATCH 02/39] arch/alpha: Update WARN uses
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 30, 2010 at 5:08 PM, Joe Perches <joe@perches.com> wrote:
> Coalesce long formats.
> Align arguments.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/alpha/kernel/pci-sysfs.c |   14 ++++++--------
>  1 files changed, 6 insertions(+), 8 deletions(-)
>
> diff --git a/arch/alpha/kernel/pci-sysfs.c b/arch/alpha/kernel/pci-sysfs.c
> index b899e95..6f30ac3 100644
> --- a/arch/alpha/kernel/pci-sysfs.c
> +++ b/arch/alpha/kernel/pci-sysfs.c
> @@ -44,10 +44,9 @@ static int __pci_mmap_fits(struct pci_dev *pdev, int num,
>
>        if (start < size && size - start >= nr)
>                return 1;
> -       WARN(1, "process \"%s\" tried to map%s 0x%08lx-0x%08lx on %s BAR %d "
> -               "(size 0x%08lx)\n",
> -               current->comm, sparse ? " sparse" : "", start, start + nr,
> -               pci_name(pdev), num, size);
> +       WARN(1, "process \"%s\" tried to map%s 0x%08lx-0x%08lx on %s BAR %d (size 0x%08lx)\n",
> +            current->comm, sparse ? " sparse" : "", start, start + nr,
> +            pci_name(pdev), num, size);
>        return 0;
>  }
>
> @@ -261,10 +260,9 @@ static int __legacy_mmap_fits(struct pci_controller *hose,
>
>        if (start < size && size - start >= nr)
>                return 1;
> -       WARN(1, "process \"%s\" tried to map%s 0x%08lx-0x%08lx on hose %d "
> -               "(size 0x%08lx)\n",
> -               current->comm, sparse ? " sparse" : "", start, start + nr,
> -               hose->index, size);
> +       WARN(1, "process \"%s\" tried to map%s 0x%08lx-0x%08lx on hose %d (size 0x%08lx)\n",
> +            current->comm, sparse ? " sparse" : "", start, start + nr,
> +            hose->index, size);
>        return 0;
>  }
>
> --
> 1.7.3.1.g432b3.dirty

What's accomplished here? It looks like you joined two strings (which
were separated as to not overflow the 80-char limit) and spaced a
couple lines over.

I don't see how this makes anything clearer.

Matt
