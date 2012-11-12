Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab2KLUoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 15:44:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56993 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab2KLUoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 15:44:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH] ARM: integrator: use BUG_ON where possible
Date: Mon, 12 Nov 2012 20:44:13 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Rob Herring <rob.herring@calxeda.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@stericsson.com>
References: <1352406191-14303-1-git-send-email-sasha.levin@oracle.com> <1352406191-14303-6-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1352406191-14303-6-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211122044.13663.arnd@arndb.de>
X-Provags-ID: V02:K0:4lxG+DOZoAPOqdKDueFTerz9/sc/G954CMxB+eoqtil
 3G+CJ9kpj+abU7nU6Ebn8FmNKGk7QmJyvgBA4llpQmCscX//Na
 2WjemXvj7kcQdbk8QoQKKfFZqMLO78oi/ECWyBDDzf68TWgpQ6
 cIquI10QIG4/jRP0zl6LRGG/SoRbdmvSArp2w9wAcXAHhg8OBx
 JDP5Tn+KUH3zbyobw5bbtJPVLc0sy5tRZHWT9hT8JSbGM96de7
 5s7zOa/KitWgVm2Q40RjJ+0mq+0yAXdRHBej/PPxG8bHfLlOIf
 CTUg4iPqZYhQSMcYO7fpbWLh19l4maKSi4dkmdmGEmzfyYQ7KF
 TD0tp7x0GXq8GFWDlKMQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 November 2012, Sasha Levin wrote:
> Just use BUG_ON() instead of constructions such as:
> 
> 	if (...)
> 		BUG()
> 
> A simplified version of the semantic patch that makes this transformation
> is as follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e;
> @@
> - if (e) BUG();
> + BUG_ON(e);
> // </smpl>
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Linus Walleij is doing most of the integrator work these days, maybe he
wants to apply the patch.

Acked-by: Arnd Bergmann <arnd@arndb.de>

>  arch/arm/mach-integrator/pci_v3.c |    9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/mach-integrator/pci_v3.c b/arch/arm/mach-integrator/pci_v3.c
> index bbeca59..85938de 100644
> --- a/arch/arm/mach-integrator/pci_v3.c
> +++ b/arch/arm/mach-integrator/pci_v3.c
> @@ -191,12 +191,9 @@ static void __iomem *v3_open_config_window(struct pci_bus *bus,
>  	/*
>  	 * Trap out illegal values
>  	 */
> -	if (offset > 255)
> -		BUG();
> -	if (busnr > 255)
> -		BUG();
> -	if (devfn > 255)
> -		BUG();
> +	BUG_ON(offset > 255);
> +	BUG_ON(busnr > 255);
> +	BUG_ON(devfn > 255);
>  
>  	if (busnr == 0) {
>  		int slot = PCI_SLOT(devfn);
> -- 
> 1.7.10.4
> 
> 

