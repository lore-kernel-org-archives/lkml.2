Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab1JHIDf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 04:03:35 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58086 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab1JHID2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 04:03:28 -0400
Date: Sat, 8 Oct 2011 09:03:09 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: Re: [PATCH 06/26] ARM: pxa: add missing header inclusions
Message-ID: <20111008080309.GD25689@n2100.arm.linux.org.uk>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-7-git-send-email-arnd@arndb.de> <CAMPhdO8FGTw7NzNNjK819zF3GjrRX0ybPyaSFR4U7oG8cGmDtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMPhdO8FGTw7NzNNjK819zF3GjrRX0ybPyaSFR4U7oG8cGmDtQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 01:08:23PM +0800, Eric Miao wrote:
> On Sun, Oct 2, 2011 at 4:03 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > These resulted in build breakage in some configurations:
> >
> > arch/arm/mach-pxa/irq.c:132:39: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'icip_handle_irq'
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  arch/arm/mach-pxa/irq.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/arm/mach-pxa/irq.c b/arch/arm/mach-pxa/irq.c
> > index b09e848..848e96d 100644
> > --- a/arch/arm/mach-pxa/irq.c
> > +++ b/arch/arm/mach-pxa/irq.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/module.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/syscore_ops.h>
> > +#include <linux/ftrace.h>
> 
> It's actually __irq_entry being defined in <linux/ftrace.h> and in turn
> __exception_irq_entry being conditionally defined to that.
> 
> I think it's better to fix this in <asm/system.h> instead of in the
> cases where this macro is referenced?
> 
> Russell?

There's a patch in the patch system which fixes this (7115/3) but I
can't apply it because it doesn't apply to anything in my for-next
tree (it applies to the obsolete 'devel' branch which is rather old
now.)
