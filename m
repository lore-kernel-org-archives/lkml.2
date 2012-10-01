Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab2JAOEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 10:04:09 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:41352 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab2JAOEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 10:04:06 -0400
Date: Mon, 1 Oct 2012 09:52:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, arnd@arndb.de
Subject: Re: [GIT PULL] Xen on ARM
Message-ID: <20121001135222.GG4099@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1210011112230.29232@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1210011112230.29232@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 11:20:03AM +0100, Stefano Stabellini wrote:
> Hi Konrad,
> please pull the following changes, based on your branch
> stable/for-linus-3.7 (ecc635f90adfe1b7cd5fd354f49edfbf24aa4e3e):

Pulled (to be truthful I actually pulled it on Wednesday and have
had it running over the last couple of days to make sure there are no
regressions).

Will send it to Linus on Wed or Thursday as my branch also has some
things from the tip branch.


> 
> 
> git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git xenarm-for-linus
> 
> 
> Stefano Stabellini (18):
>       arm: initial Xen support
>       xen/arm: hypercalls
>       xen/arm: page.h definitions
>       xen/arm: sync_bitops
>       xen/arm: empty implementation of grant_table arch specific functions
>       docs: Xen ARM DT bindings
>       xen/arm: Xen detection and shared_info page mapping
>       xen/arm: Introduce xen_ulong_t for unsigned long
>       xen: do not compile manage, balloon, pci, acpi, pcpu and cpu_hotplug on ARM
>       xen/arm: introduce CONFIG_XEN on ARM
>       xen/arm: get privilege status
>       xen/arm: initialize grant_table on ARM
>       xen/arm: receive Xen events on ARM
>       xen/arm: implement alloc/free_xenballooned_pages with alloc_pages/kfree
>       xen/arm: compile blkfront and blkback
>       xen/arm: compile netback
>       MAINTAINERS: add myself as Xen ARM maintainer
>       arm: introduce a DTS for Xen unprivileged virtual machines
> 
>  Documentation/devicetree/bindings/arm/xen.txt |   25 ++++
>  MAINTAINERS                                   |    7 +
>  arch/arm/Kconfig                              |   10 ++
>  arch/arm/Makefile                             |    1 +
>  arch/arm/boot/dts/xenvm-4.2.dts               |   68 ++++++++++
>  arch/arm/include/asm/hypervisor.h             |    6 +
>  arch/arm/include/asm/sync_bitops.h            |   27 ++++
>  arch/arm/include/asm/xen/events.h             |   18 +++
>  arch/arm/include/asm/xen/hypercall.h          |   69 ++++++++++
>  arch/arm/include/asm/xen/hypervisor.h         |   19 +++
>  arch/arm/include/asm/xen/interface.h          |   73 +++++++++++
>  arch/arm/include/asm/xen/page.h               |   82 ++++++++++++
>  arch/arm/mach-vexpress/Makefile.boot          |    3 +-
>  arch/arm/mach-vexpress/v2m.c                  |    1 +
>  arch/arm/xen/Makefile                         |    1 +
>  arch/arm/xen/enlighten.c                      |  168 +++++++++++++++++++++++++
>  arch/arm/xen/grant-table.c                    |   53 ++++++++
>  arch/arm/xen/hypercall.S                      |  106 ++++++++++++++++
>  arch/ia64/include/asm/xen/interface.h         |    1 +
>  arch/x86/include/asm/xen/interface.h          |    1 +
>  arch/x86/xen/enlighten.c                      |    1 +
>  arch/x86/xen/irq.c                            |    1 +
>  arch/x86/xen/xen-ops.h                        |    1 -
>  drivers/block/xen-blkback/blkback.c           |    1 +
>  drivers/net/xen-netback/netback.c             |    1 +
>  drivers/net/xen-netfront.c                    |    1 +
>  drivers/xen/Makefile                          |   13 ++-
>  drivers/xen/events.c                          |   17 ++-
>  include/xen/events.h                          |    2 +
>  include/xen/interface/features.h              |    3 +
>  include/xen/interface/io/protocols.h          |    3 +
>  include/xen/interface/memory.h                |   12 +-
>  include/xen/interface/physdev.h               |    2 +-
>  include/xen/interface/version.h               |    2 +-
>  include/xen/xen.h                             |    2 +-
>  35 files changed, 783 insertions(+), 18 deletions(-)
> 
> Cheers,
> 
> Stefano
