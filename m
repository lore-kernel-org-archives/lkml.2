Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab0F1BUl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 21:20:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56136 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab0F1BUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 21:20:39 -0400
Message-ID: <4C27F8D4.6020200@infradead.org>
Date: Sun, 27 Jun 2010 22:20:20 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>,
       Joel Becker <joel.becker@oracle.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [GIT PULL] Please pull fix patches sitting in linux-next
References: <20100628103715.594635f7.sfr@canb.auug.org.au>
In-Reply-To: <20100628103715.594635f7.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 27-06-2010 21:37, Stephen Rothwell escreveu:
> Hi Linus,
> 
> These patches have been sitting in my fixes tree (and thus in linux-next)
> for considerable time and the respective maintainers seem either unaware
> or unwilling to pick them up.  They are just fallout from Tejun's removal
> of slab.h from percpu.h changes that you merged back in April.
> 
> The following changes since commit b4322e7057ca851b0a3e15f29e26806efeada100:
> 
>   Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu (2010-06-27 11:33:44 -0700)
> 
> are available in the git repository at:
> 
>   ssh://master.kernel.org/~sfr/next-fixes.git fixes
> 
> Tejun Heo (5):
>       v4l-dvb: update gfp/slab.h includes

Hmm... it seems that I missed this one. The patch looks ok to me (yet, it would be a 
little better to add slab.h at tm6000.h, instead of adding it to all tm6000 files,
but a latter patch may do such cleanup).

Anyway,

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

>       arm: update gfp/slab.h includes
>       davinci: update gfp/slab.h includes
>       ocfs2: update gfp/slab.h includes
>       acpi: update gfp/slab.h includes
> 
>  arch/arm/mach-vexpress/ct-ca9x4.c     |    1 +
>  drivers/acpi/apei/apei-base.c         |    1 +
>  drivers/acpi/atomicio.c               |    1 +
>  drivers/rtc/rtc-davinci.c             |    1 +
>  drivers/staging/tm6000/tm6000-alsa.c  |    1 +
>  drivers/staging/tm6000/tm6000-cards.c |    1 +
>  drivers/staging/tm6000/tm6000-core.c  |    1 +
>  drivers/staging/tm6000/tm6000-dvb.c   |    1 +
>  fs/ocfs2/reservations.c               |    1 -
>  9 files changed, 8 insertions(+), 1 deletions(-)
> commit e0fb8c418520b41d57667befdb8861c46cdf69e0
> Author: Tejun Heo <tj@kernel.org>
> Date:   Tue Mar 30 02:52:44 2010 +0900
> 
>     acpi: update gfp/slab.h includes
>     
>     Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
>     gfp.h or slab.h is included as necessary.
>     
>     Signed-off-by: Tejun Heo <tj@kernel.org>
>     Cc: Stephen Rothwell <sfr@canb.auug.org.au>
>     Cc: Len Brown <lenb@kernel.org>
>     Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> diff --git a/drivers/acpi/apei/apei-base.c b/drivers/acpi/apei/apei-base.c
> index db3946e..216e1e9 100644
> --- a/drivers/acpi/apei/apei-base.c
> +++ b/drivers/acpi/apei/apei-base.c
> @@ -34,6 +34,7 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/acpi.h>
> +#include <linux/slab.h>
>  #include <linux/io.h>
>  #include <linux/kref.h>
>  #include <linux/rculist.h>
> diff --git a/drivers/acpi/atomicio.c b/drivers/acpi/atomicio.c
> index 814b192..8f8bd73 100644
> --- a/drivers/acpi/atomicio.c
> +++ b/drivers/acpi/atomicio.c
> @@ -31,6 +31,7 @@
>  #include <linux/kref.h>
>  #include <linux/rculist.h>
>  #include <linux/interrupt.h>
> +#include <linux/slab.h>
>  #include <acpi/atomicio.h>
>  
>  #define ACPI_PFX "ACPI: "
> 
> commit 327f935a9ef644c0ec3d050c94bce753756d60c0
> Author: Tejun Heo <tj@kernel.org>
> Date:   Tue Mar 30 02:52:32 2010 +0900
> 
>     ocfs2: update gfp/slab.h includes
>     
>     Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
>     gfp.h or slab.h is included as necessary.
>     
>     Signed-off-by: Tejun Heo <tj@kernel.org>
>     Cc: Stephen Rothwell <sfr@canb.auug.org.au>
>     Cc: Joel Becker <joel.becker@oracle.com>
>     Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
> index 4065002..d8b6e42 100644
> --- a/fs/ocfs2/reservations.c
> +++ b/fs/ocfs2/reservations.c
> @@ -26,7 +26,6 @@
>  
>  #include <linux/fs.h>
>  #include <linux/types.h>
> -#include <linux/slab.h>
>  #include <linux/highmem.h>
>  #include <linux/bitops.h>
>  #include <linux/list.h>
> 
> commit f244f31a0d31402c2c1b1950108e0013353cc3f3
> Author: Tejun Heo <tj@kernel.org>
> Date:   Tue Mar 30 02:52:36 2010 +0900
> 
>     davinci: update gfp/slab.h includes
>     
>     Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
>     gfp.h or slab.h is included as necessary.
>     
>     Signed-off-by: Tejun Heo <tj@kernel.org>
>     Cc: Stephen Rothwell <sfr@canb.auug.org.au>
>     Cc: Kevin Hilman <khilman@deeprootsystems.com>
>     Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> diff --git a/drivers/rtc/rtc-davinci.c b/drivers/rtc/rtc-davinci.c
> index 92a8f6c..34647fc 100644
> --- a/drivers/rtc/rtc-davinci.c
> +++ b/drivers/rtc/rtc-davinci.c
> @@ -29,6 +29,7 @@
>  #include <linux/bcd.h>
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
> +#include <linux/slab.h>
>  
>  /*
>   * The DaVinci RTC is a simple RTC with the following
> 
> commit 68aaae9e95199d2bc46a9e8e3670e403b4a3fe75
> Author: Tejun Heo <tj@kernel.org>
> Date:   Tue Mar 30 02:52:45 2010 +0900
> 
>     arm: update gfp/slab.h includes
>     
>     Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
>     gfp.h or slab.h is included as necessary.
>     
>     Signed-off-by: Tejun Heo <tj@kernel.org>
>     Cc: Stephen Rothwell <sfr@canb.auug.org.au>
>     Cc: Russell King <linux@arm.linux.org.uk>
>     Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> diff --git a/arch/arm/mach-vexpress/ct-ca9x4.c b/arch/arm/mach-vexpress/ct-ca9x4.c
> index e6f7303..9b11eed 100644
> --- a/arch/arm/mach-vexpress/ct-ca9x4.c
> +++ b/arch/arm/mach-vexpress/ct-ca9x4.c
> @@ -2,6 +2,7 @@
>   * Versatile Express Core Tile Cortex A9x4 Support
>   */
>  #include <linux/init.h>
> +#include <linux/gfp.h>
>  #include <linux/device.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/platform_device.h>
> 
> commit 4ef09889d7b4c7be2aa3e132efb77029f51c95b7
> Author: Tejun Heo <tj@kernel.org>
> Date:   Tue Mar 30 02:52:33 2010 +0900
> 
>     v4l-dvb: update gfp/slab.h includes
>     
>     Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
>     gfp.h or slab.h is included as necessary.
>     
>     Signed-off-by: Tejun Heo <tj@kernel.org>
>     Cc: Stephen Rothwell <sfr@canb.auug.org.au>
>     Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
>     Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
> index ce081cd..273e26e 100644
> --- a/drivers/staging/tm6000/tm6000-alsa.c
> +++ b/drivers/staging/tm6000/tm6000-alsa.c
> @@ -15,6 +15,7 @@
>  #include <linux/device.h>
>  #include <linux/interrupt.h>
>  #include <linux/usb.h>
> +#include <linux/slab.h>
>  
>  #include <asm/delay.h>
>  #include <sound/core.h>
> diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
> index cedd904..6a9ae40 100644
> --- a/drivers/staging/tm6000/tm6000-cards.c
> +++ b/drivers/staging/tm6000/tm6000-cards.c
> @@ -24,6 +24,7 @@
>  #include <linux/i2c.h>
>  #include <linux/usb.h>
>  #include <linux/version.h>
> +#include <linux/slab.h>
>  #include <media/v4l2-common.h>
>  #include <media/tuner.h>
>  #include <media/tvaudio.h>
> diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
> index 27f3f55..c3690e3 100644
> --- a/drivers/staging/tm6000/tm6000-core.c
> +++ b/drivers/staging/tm6000/tm6000-core.c
> @@ -22,6 +22,7 @@
>  
>  #include <linux/module.h>
>  #include <linux/kernel.h>
> +#include <linux/slab.h>
>  #include <linux/usb.h>
>  #include <linux/i2c.h>
>  #include "tm6000.h"
> diff --git a/drivers/staging/tm6000/tm6000-dvb.c b/drivers/staging/tm6000/tm6000-dvb.c
> index 261e66a..86c1c8b 100644
> --- a/drivers/staging/tm6000/tm6000-dvb.c
> +++ b/drivers/staging/tm6000/tm6000-dvb.c
> @@ -18,6 +18,7 @@
>   */
>  
>  #include <linux/kernel.h>
> +#include <linux/slab.h>
>  #include <linux/usb.h>
>  
>  #include "tm6000.h"
> 
> 

