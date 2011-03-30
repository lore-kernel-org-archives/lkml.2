Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab1C3LpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 07:45:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49355 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab1C3LpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 07:45:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Linn <john.linn@xilinx.com>
Subject: Re: [PATCH V5 3/4] ARM: Xilinx: base header files and assembly macros
Date: Wed, 30 Mar 2011 13:44:45 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, catalin.marinas@arm.com, glikely@secretlab.ca,
        jamie@jamieiles.com
References: <1301444651-18008-1-git-send-email-john.linn@xilinx.com> <1301444651-18008-3-git-send-email-john.linn@xilinx.com> <9ceff117-ad43-4513-bee0-153a93c379ce@VA3EHSMHS008.ehs.local>
In-Reply-To: <9ceff117-ad43-4513-bee0-153a93c379ce@VA3EHSMHS008.ehs.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103301344.45307.arnd@arndb.de>
X-Provags-ID: V02:K0:2ZdfMLaOvuFZiclMxc5BJ2RqZg/wnxk6PXmlakZX8/3
 cdmMtlD276vlyviLVw9hLnMliUvP87QFFKgEAOLd0nt5XxZPTI
 NpK1nvgHD3W2hqdcsysYdTX2Svrz4SWwb8w5r4hHdUOiUE2vo6
 s8M7OW5zAxuROI7uvwjTNm5Gsj9j5173n8XPkEZjUw5qEXlc/3
 O7wiWsQRNjWkM9dklKmSw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

I looked over the latest version of your patches, everything looks
good to me, but I found one problem that you have probably copied
from other platforms:

On Wednesday 30 March 2011, John Linn wrote:
> +
> +/* Allow IO space to be anywhere in the memory */
> +
> +#define IO_SPACE_LIMIT 0xffff
> +
> +/* IO address mapping macros, nothing special at this time but required */
> +
> +#ifdef __ASSEMBLER__
> +#define IOMEM(x)               (x)
> +#else
> +#define IOMEM(x)               ((void __force __iomem *)(x))
> +#endif
> +
> +#define __io(a)                        __typesafe_io(a)
> +#define __mem_pci(a)           (a)

The definition of __io() looks wrong, so any call to inb()/outb()
will be a wild pointer access when you add PCI support.

If you don't plan to support PCI in the future, there should
be no problem.

	Arnd
