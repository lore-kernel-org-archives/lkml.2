Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab1JHKYc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 06:24:32 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53500 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab1JHKY2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 06:24:28 -0400
MIME-Version: 1.0
In-Reply-To: <20111008102313.GA4464@gallagher>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
 <1317499438-14058-7-git-send-email-arnd@arndb.de> <CAMPhdO8FGTw7NzNNjK819zF3GjrRX0ybPyaSFR4U7oG8cGmDtQ@mail.gmail.com>
 <20111008080309.GD25689@n2100.arm.linux.org.uk> <20111008102313.GA4464@gallagher>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sat, 8 Oct 2011 18:24:07 +0800
Message-ID: <CAMPhdO9J54JusCHVTkQ6FNMcbRLmVFmJ_i-y5rWpWLAU1EHpqg@mail.gmail.com>
Subject: Re: [PATCH 06/26] ARM: pxa: add missing header inclusions
To: Jamie Iles <jamie@jamieiles.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 8, 2011 at 6:23 PM, Jamie Iles <jamie@jamieiles.com> wrote:
> On Sat, Oct 08, 2011 at 09:03:09AM +0100, Russell King - ARM Linux wrote:
>> On Fri, Oct 07, 2011 at 01:08:23PM +0800, Eric Miao wrote:
>> > On Sun, Oct 2, 2011 at 4:03 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > > These resulted in build breakage in some configurations:
>> > >
>> > > arch/arm/mach-pxa/irq.c:132:39: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'icip_handle_irq'
>> > >
>> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> > > ---
>> > >  arch/arm/mach-pxa/irq.c |    1 +
>> > >  1 files changed, 1 insertions(+), 0 deletions(-)
>> > >
>> > > diff --git a/arch/arm/mach-pxa/irq.c b/arch/arm/mach-pxa/irq.c
>> > > index b09e848..848e96d 100644
>> > > --- a/arch/arm/mach-pxa/irq.c
>> > > +++ b/arch/arm/mach-pxa/irq.c
>> > > @@ -16,6 +16,7 @@
>> > >  #include <linux/module.h>
>> > >  #include <linux/interrupt.h>
>> > >  #include <linux/syscore_ops.h>
>> > > +#include <linux/ftrace.h>
>> >
>> > It's actually __irq_entry being defined in <linux/ftrace.h> and in turn
>> > __exception_irq_entry being conditionally defined to that.
>> >
>> > I think it's better to fix this in <asm/system.h> instead of in the
>> > cases where this macro is referenced?
>> >
>> > Russell?
>>
>> There's a patch in the patch system which fixes this (7115/3) but I
>> can't apply it because it doesn't apply to anything in my for-next
>> tree (it applies to the obsolete 'devel' branch which is rather old
>> now.)
>
> OK, I wasn't aware that devel was obsolete (though I guess if I'd paid
> closer attention to the commit dates I'd have suspected something).
>
> Anyhow, new patch in the tracker as 7115/4 rebased onto for-next.

Thanks, Jamie.
