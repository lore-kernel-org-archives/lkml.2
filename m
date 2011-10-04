Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933778Ab1JDXJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 19:09:39 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:43460 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933158Ab1JDXJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 19:09:38 -0400
Message-ID: <4E8B9230.5070608@xenotime.net>
Date: Tue, 04 Oct 2011 16:09:36 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Johann Felix Soden <johfel@gmx.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix file references in the whole tree
References: <1317683499.5990.2.camel@LAPJFS>
In-Reply-To: <1317683499.5990.2.camel@LAPJFS>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/11 16:11, Johann Felix Soden wrote:
> From: Johann Felix Soden <johfel@users.sourceforge.net>
> 
> There are a lot of file references to now moved or deleted files in the
> whole tree, especially in documentation and Kconfig files. This patch
> fixes most of them.
> 
> Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
> ---
>  Documentation/PCI/pci.txt                          |    2 +-
>  Documentation/block/biodoc.txt                     |    4 +-
>  Documentation/bus-virt-phys-mapping.txt            |    2 +-
>  Documentation/filesystems/locks.txt                |   11 +++++----
>  Documentation/filesystems/nfs/idmapper.txt         |    2 +-
>  .../filesystems/pohmelfs/design_notes.txt          |    5 ++-
>  Documentation/input/input.txt                      |    2 +-
>  Documentation/kernel-parameters.txt                |    8 +++---
>  Documentation/laptops/00-INDEX                     |    2 -
>  Documentation/laptops/thinkpad-acpi.txt            |    6 ++--
>  Documentation/memory-barriers.txt                  |    2 +-
>  Documentation/timers/highres.txt                   |    2 +-
>  Documentation/usb/dma.txt                          |    8 +++---
>  arch/arm/Kconfig                                   |    2 +-
>  arch/arm/include/asm/io.h                          |    2 +-
>  arch/cris/Kconfig                                  |    4 +-
>  arch/cris/arch-v10/Kconfig                         |   12 +++++-----
>  arch/ia64/hp/common/sba_iommu.c                    |   12 +++++-----
>  arch/m68k/q40/README                               |    2 +-
>  arch/microblaze/include/asm/dma-mapping.h          |    2 +-
>  arch/mn10300/Kconfig                               |    2 +-
>  arch/parisc/include/asm/dma-mapping.h              |    2 +-
>  arch/parisc/kernel/pci-dma.c                       |    2 +-
>  arch/powerpc/include/asm/qe.h                      |    2 +-
>  arch/powerpc/sysdev/qe_lib/qe.c                    |    2 +-
>  arch/unicore32/include/asm/io.h                    |    2 +-
>  arch/x86/Kconfig                                   |    2 +-
>  arch/x86/Kconfig.debug                             |    2 +-
>  arch/x86/boot/header.S                             |    2 +-
>  arch/x86/include/asm/dma-mapping.h                 |    2 +-
>  arch/x86/kernel/amd_gart_64.c                      |    2 +-
>  arch/x86/kernel/pci-dma.c                          |    4 +-
>  drivers/ide/Kconfig                                |   24 ++++++++++----------
>  drivers/leds/Kconfig                               |    2 +-
>  drivers/net/Kconfig                                |    4 +-
>  drivers/net/irda/Kconfig                           |    2 +-
>  drivers/parisc/sba_iommu.c                         |   16 ++++++------
>  drivers/platform/x86/Kconfig                       |    3 --
>  drivers/staging/cxt1e1/Kconfig                     |    2 +-
>  drivers/video/igafb.c                              |    3 +-
>  fs/squashfs/Kconfig                                |    6 ++--
>  include/media/videobuf-dma-sg.h                    |    2 +-
>  net/netfilter/Kconfig                              |    2 +-
>  sound/oss/Kconfig                                  |    4 +--
>  44 files changed, 92 insertions(+), 96 deletions(-)


Hi,

All of the Documentation/x86/* changes look good to me.

Personally I would prefer to see all of the PCI*.txt and DMA*.txt changes
in one patch separate from the others.

Dave Miller (or Jiri) could apply all of the drivers/ide/Kconfig changes
immediately IMO.

> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index a44874e..53ed3f4 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -1064,8 +1064,8 @@ config SMSC911X
>  	  of ethernet controllers.
>  
>  	  To compile this driver as a module, choose M here and read
> -	  <file:Documentation/networking/net-modules.txt>. The module
> -	  will be called smsc911x.
> +	  <file:Documentation/kbuild/modules.txt>. The module will be
> +	  called smsc911x.

Just drop the reference to modules.txt completely.

>  
>  config SMSC911X_ARCH_HOOKS
>  	def_bool n


Any other changes that I didn't mention also look OK to me.

thanks,
-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
