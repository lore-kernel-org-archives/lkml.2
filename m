Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab1GNPWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 11:22:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59168 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab1GNPWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 11:22:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v3 0/6] ARM: make mach/hardware.h optional
Date: Thu, 14 Jul 2011 17:22:19 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>, nico@fluxnic.net,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>
References: <1310489612-8625-1-git-send-email-robherring2@gmail.com>
In-Reply-To: <1310489612-8625-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107141722.19407.arnd@arndb.de>
X-Provags-ID: V02:K0:c2M3m5mMlK/GzdEgCJNLQYhWFtH2/BXL+Lg2pZ4TxkZ
 Xo50be/GLsmSWEMCYXlgWFTTKjzl3E3D1QAIRuNNpJTJEKniJ8
 y9WUtY1Ugk8rloQauMf6PFLNppjyXNe9GZrPP0IOY3lZTRB25y
 ccxSa5qIS0f+mk/jpttq5u7f9iuOAqFj/WKT97ww3FaUwBDOm+
 q0DtKeid+P+pbI5uTtgpw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 July 2011, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Currently, all ARM platforms must have a mach/hardware.h include. This is
> because it is ultimately included by linux/pci.h which is included in many
> places even for !CONFIG_PCI.
> 
> This could be fixed simply with an ifdef around the include of mach/hardware.h
> in asm/pci.h. However, in the interest of fixing this for single kernel
> binary builds, this series removes the include of mach/hardware.h outside of
> mach-* and plat-*. What's used from hardware.h is a couple of PCI defines. 
> Converting them to variables allows each platform to set the values as needed.
> 
> This does not address the inclusion of mach/hardware.h under drivers/*. This
> appears to be mostly older platforms. There could also be some indirect
> inclusions from other mach/* headers.
> 
> I've compile tested on most affected ARM platforms. 
> 
> Changes from v2:
> - Incorporated compile fixes for microblaze from Michal Simek.
> - Added conversion of powerpc to generic pci flag functions.
> - Combined powerpc and microblaze conversion to use 
>   asm-generic/pci-bridge.h into one commit. Renaming of powerpc pci
>   flags functions is separate commit.
> - Changed defaults for PCIBIOS_MIN_IO and PCIBIOS_MIN_MEM to 0x1000 and
>   0x1000000, respectively.
> - Dropped commit moving ARCH_HAS_DMA_SET_COHERENT_MASK defines into 
>   memory.h. This conflicts with other clean-up work by Nicolas Pitre.

Looks good to me, I'll apply it as soon as I hear back from Russell.

Russell, do you have an opinion on the changes to arch/arm/{include,lib} ?

	Arnd
