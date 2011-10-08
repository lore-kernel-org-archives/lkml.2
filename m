Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab1JHKXX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 06:23:23 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:61304 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab1JHKXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 06:23:21 -0400
Date: Sat, 8 Oct 2011 11:23:13 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Eric Miao <eric.y.miao@gmail.com>, Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/26] ARM: pxa: add missing header inclusions
Message-ID: <20111008102313.GA4464@gallagher>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
 <1317499438-14058-7-git-send-email-arnd@arndb.de>
 <CAMPhdO8FGTw7NzNNjK819zF3GjrRX0ybPyaSFR4U7oG8cGmDtQ@mail.gmail.com>
 <20111008080309.GD25689@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111008080309.GD25689@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 08, 2011 at 09:03:09AM +0100, Russell King - ARM Linux wrote:
> On Fri, Oct 07, 2011 at 01:08:23PM +0800, Eric Miao wrote:
> > On Sun, Oct 2, 2011 at 4:03 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > > These resulted in build breakage in some configurations:
> > >
> > > arch/arm/mach-pxa/irq.c:132:39: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'icip_handle_irq'
> > >
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > ---
> > >  arch/arm/mach-pxa/irq.c |    1 +
> > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/arch/arm/mach-pxa/irq.c b/arch/arm/mach-pxa/irq.c
> > > index b09e848..848e96d 100644
> > > --- a/arch/arm/mach-pxa/irq.c
> > > +++ b/arch/arm/mach-pxa/irq.c
> > > @@ -16,6 +16,7 @@
> > >  #include <linux/module.h>
> > >  #include <linux/interrupt.h>
> > >  #include <linux/syscore_ops.h>
> > > +#include <linux/ftrace.h>
> > 
> > It's actually __irq_entry being defined in <linux/ftrace.h> and in turn
> > __exception_irq_entry being conditionally defined to that.
> > 
> > I think it's better to fix this in <asm/system.h> instead of in the
> > cases where this macro is referenced?
> > 
> > Russell?
> 
> There's a patch in the patch system which fixes this (7115/3) but I
> can't apply it because it doesn't apply to anything in my for-next
> tree (it applies to the obsolete 'devel' branch which is rather old
> now.)

OK, I wasn't aware that devel was obsolete (though I guess if I'd paid 
closer attention to the commit dates I'd have suspected something).

Anyhow, new patch in the tracker as 7115/4 rebased onto for-next.

Jamie
