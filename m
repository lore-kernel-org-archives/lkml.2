Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab1BQR2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:28:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:56375 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab1BQR2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:28:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCHv2 06/11] unicore32 core architecture: mm related: generic codes
Date: Thu, 17 Feb 2011 18:28:15 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "'Greg KH'" <greg@kroah.com>
References: <02ed01cbcb48$3e3781a0$baa684e0$@mprc.pku.edu.cn>
In-Reply-To: <02ed01cbcb48$3e3781a0$baa684e0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102171828.15482.arnd@arndb.de>
X-Provags-ID: V02:K0:FEZpz2ZUWAUmo3uVOnljZhWaAJo7Ltar5smLpMgh2Np
 uJcEGg36SiR6lfbHJpfCGDIhQOhwcjl/Pech2IrwCvF4rDDy/k
 H65b5KZd+Kg1/XmLizNBODfHumOVWD3TABEkEiJ323es0iq6vm
 HlsfeXWenwv6h0Yl0UL8s4Xd2//exVeFz67nCBxEeezWgTNl2e
 s34Kb/TiPI1B50Q3PDo1g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 February 2011, Guan Xuetao wrote:
> This patch includes generic codes for memory management.
> 
> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

> +#ifdef __io
> +void __iomem *ioport_map(unsigned long port, unsigned int nr)
> +{
> +       /* we map PC lagcy 64K IO port to PCI IO space 0x80030000 */
> +       return (void __iomem *) (unsigned long)
> +                       io_p2v((port & 0xffff) + PKUNITY_PCILIO_BASE);
> +}

Interestingly, this function looks completely correct, but I don't see
the definition for __io, so I suspect that the function is not actually
getting used.

Best make this unconditional. The code is obviously derived from the
ARM version, which uses a macro called __io, but you don't need this
macro because you only support one SoC platform.

	Arnd
