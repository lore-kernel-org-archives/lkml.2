Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab0JTRC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 13:02:59 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:57561 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100Ab0JTRC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 13:02:58 -0400
Date: Wed, 20 Oct 2010 10:02:54 -0700
From: Andres Salomon <dilinger@queued.net>
To: Daniel Drake <dsd@laptop.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, randy.dunlap@oracle.com
Subject: Re: [PATCH v2] OLPC: Add XO-1 suspend/resume support
Message-ID: <20101020100254.7da34acc@queued.net>
In-Reply-To: <20101020090613.2e969a6f@queued.net>
References: <20101020151723.9F6F89D401B@zog.reactivated.net>
	<20101020090613.2e969a6f@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Oct 2010 09:06:13 -0700
Andres Salomon <dilinger@queued.net> wrote:

> On Wed, 20 Oct 2010 16:17:23 +0100 (BST)
> Daniel Drake <dsd@laptop.org> wrote:
> 
> > Add code needed for basic suspend/resume of the XO-1 laptop.
> > 
> > Signed-off-by: Daniel Drake <dsd@laptop.org>
> > ---
> >  arch/x86/Kconfig                  |    2 +-
> >  arch/x86/include/asm/olpc.h       |    5 +-
> >  arch/x86/kernel/Makefile          |    2 +-
> >  arch/x86/kernel/olpc-xo1-wakeup.S |  133
> > +++++++++++++++++++++++++++++++++++++
> > arch/x86/kernel/olpc-xo1.c        |   79 ++++++++++++++++++++++ 5
> > files changed, 218 insertions(+), 3 deletions(-) create mode 100644
> > arch/x86/kernel/olpc-xo1-wakeup.S
> > 
> > v2: add dependency on CONFIG_PM_SLEEP (thanks Randy), avoid
> > requirement on hacking swsusp_pg_dir by switching to
> > initial_page_table Depends on the following patch:
> > x86-32, mm: Add an initial page table for core bootstrapping
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 6a81891..581abc7 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -2036,7 +2036,7 @@ config OLPC
> >  
> >  config OLPC_XO1
> >  	tristate "OLPC XO-1 support"
> > -	depends on OLPC && PCI
> > +	depends on OLPC && PCI && PM_SLEEP
> >  	---help---
> 
> 
> My suggestion would be:
> 
> config OLPC_XO1_PM
> 	bool
> 	depends on OLPC && PCI && PM_SLEEP
> 	default y
> 
> 
> No help necessary; just silently turn it on if PM_SLEEP is enabled,
> but don't make all OLPC support dependent upon PM_SLEEP.

Actually, scratch that; I didn't realize that CONFIG_OLPC !=
CONFIG_OLPC_XO1.  The config looks fine the way you proposed.

