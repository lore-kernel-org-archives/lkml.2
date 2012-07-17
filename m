Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab2GQUR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 16:17:56 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54158 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab2GQURx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 16:17:53 -0400
MIME-Version: 1.0
In-Reply-To: <1341902726-22580-1-git-send-email-devendra.aaru@gmail.com>
References: <1341902726-22580-1-git-send-email-devendra.aaru@gmail.com>
Date: Tue, 17 Jul 2012 17:17:52 -0300
Message-ID: <CADThq4Jist-h4UdNTEtmktt0NzibZSZnHrW4qaAM_g2xrzBaCw@mail.gmail.com>
Subject: Re: [PATCH 5/6] staging/media/solo6x10: use module_pci_driver macro
From: Ismael Luceno <ismael.luceno@gmail.com>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: Ben Collins <bcollins@bluecherry.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Miller <amiller@amilx.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 3:45 AM, Devendra Naga <devendra.aaru@gmail.com> wrote:
> the driver duplicates the module_pci_driver code,
> how?
>         module_pci_driver is used for those drivers whose
>         init and exit paths does only register and unregister
>         to pci API and nothing else.
>
> so use the module_pci_driver macro instead
>
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> ---
>  drivers/staging/media/solo6x10/core.c |   13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
>
> diff --git a/drivers/staging/media/solo6x10/core.c b/drivers/staging/media/solo6x10/core.c
> index d2fd842..3ee9b12 100644
> --- a/drivers/staging/media/solo6x10/core.c
> +++ b/drivers/staging/media/solo6x10/core.c
> @@ -318,15 +318,4 @@ static struct pci_driver solo_pci_driver = {
>         .remove = solo_pci_remove,
>  };
>
> -static int __init solo_module_init(void)
> -{
> -       return pci_register_driver(&solo_pci_driver);
> -}
> -
> -static void __exit solo_module_exit(void)
> -{
> -       pci_unregister_driver(&solo_pci_driver);
> -}
> -
> -module_init(solo_module_init);
> -module_exit(solo_module_exit);
> +module_pci_driver(solo_pci_driver);

Acked-by: Ismael Luceno <ismael.luceno@gmail.com>
