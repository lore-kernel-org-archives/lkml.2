Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab2DPHxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 03:53:40 -0400
Received: from mail.southpole.se ([193.12.106.18]:58012 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab2DPHxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 03:53:39 -0400
Message-ID: <1334562822.2953.45.camel@crucifix>
Subject: Re: [ORLinux] [PATCH] gpiolib/arches: Centralise bolierplate
 asm/gpio.h
From: Jonas Bonn <jonas@southpole.se>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arch@vger.kernel.org, Grant Likely <grant@secretlab.ca>,
        linux-ia64@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Chris Zankel <chris@zankel.net>, microblaze-uclinux@itee.uq.edu.au,
        linux@openrisc.net, linux-kernel@vger.kernel.org,
        linux-alpha@vger.kernel.org, sparclinux@vger.kernel.org,
        "linuxppc-dev@lists.ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>
Date: Mon, 16 Apr 2012 09:53:42 +0200
In-Reply-To: <CACRpkdZ8yH1ZSG-nQ9dLm0TipHS-jZDuxwqohUC=LGH9V-5q4w@mail.gmail.com>
References: <1334483574-3997-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <CACRpkdZ8yH1ZSG-nQ9dLm0TipHS-jZDuxwqohUC=LGH9V-5q4w@mail.gmail.com>
Organization: South Pole AB
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu5 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 62815-02262
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Jonas Bonn <jonas@southpole.se> (for OpenRISC)

On Mon, 2012-04-16 at 09:21 +0200, Linus Walleij wrote:
> On Sun, Apr 15, 2012 at 11:52 AM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
> 
> > Rather than requiring architectures that use gpiolib but don't have any
> > need to define anything custom to copy an asm/gpio.h provide a Kconfig
> > symbol which architectures must select in order to include gpio.h and
> > for other architectures just provide the trivial implementation directly.
> >
> > This makes it much easier to do gpiolib updates and is also a step towards
> > making gpiolib APIs available on every architecture.
> >
> > For architectures with existing boilerplate code leave a stub header in
> > place which warns on direct inclusion of asm/gpio.h and includes
> > linux/gpio.h to catch code that's doing this.  Direct inclusion of
> > asm/gpio.h has long been deprecated.
> >
> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > ---
> >  arch/alpha/include/asm/gpio.h      |   59 ++----------------------------
> >  arch/arm/Kconfig                   |    1 +
> >  arch/avr32/Kconfig                 |    1 +
> >  arch/blackfin/Kconfig              |    1 +
> >  arch/ia64/include/asm/gpio.h       |   59 ++----------------------------
> >  arch/m68k/Kconfig.cpu              |    1 +
> >  arch/microblaze/include/asm/gpio.h |   57 ++---------------------------
> >  arch/mips/Kconfig                  |    1 +
> >  arch/openrisc/include/asm/gpio.h   |   69 ++---------------------------------
> >  arch/powerpc/include/asm/gpio.h    |   57 ++---------------------------
> >  arch/sh/Kconfig                    |    1 +
> >  arch/sparc/include/asm/gpio.h      |   40 ++-------------------
> >  arch/unicore32/Kconfig             |    1 +
> >  arch/x86/include/asm/gpio.h        |   57 ++---------------------------
> >  arch/xtensa/include/asm/gpio.h     |   60 ++-----------------------------
> >  drivers/gpio/Kconfig               |    8 ++++
> >  include/linux/gpio.h               |   34 +++++++++++++++++
> >  17 files changed, 81 insertions(+), 426 deletions(-)
> 
> This looks good but I think we need to page the alpha, ia64, m68k, microblaze,
> openrisc etc subarch maintainers on this patch so they have their say.
> 
> Yours,
> Linus Walleij
> _______________________________________________
> Linux mailing list
> Linux@lists.openrisc.net
> http://lists.openrisc.net/listinfo/linux


