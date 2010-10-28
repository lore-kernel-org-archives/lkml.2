Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923Ab0J1HIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 03:08:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932535Ab0J1HIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 03:08:49 -0400
Date: Thu, 28 Oct 2010 00:07:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Grazvydas Ignotas <notasas@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: -tip: origin tree build failure (battery-2.6.git related)
Message-Id: <20101028000710.2039c2f4.akpm@linux-foundation.org>
In-Reply-To: <20101028065457.GA29856@elte.hu>
References: <20101026144118.GA9335@oksana.dev.rtsoft.ru>
	<20101028065457.GA29856@elte.hu>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Oct 2010 08:54:57 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> Hi,
> 
> * Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> 
> > Hello Linus,
> > 
> > Please pull battery-2.6.git tree to receive changes prepared for
> > 2.6.37.
> > 
> > There are three new drivers, various small cleanups and bug fixes.
> > [...]
> >
> > Grazvydas Ignotas (1):
> >       power_supply: Add driver for TWL4030/TPS65950 BCI charger
> 
> Today's -tip fails to build due to upstream commit 2e727f1 ("power_supply: Add 
> driver for TWL4030/TPS65950 BCI charger"), on every x86 build that has this driver 
> enabled (for example allyesconfig or allmodconfig):
> 
>  drivers/power/twl4030_charger.c: In function ___twl4030_clear_set_boot_bci___:
>  drivers/power/twl4030_charger.c:105: error: ___TWL4030_PM_MASTER_BOOT_BCI___ undeclared (first use in this function)
>  drivers/power/twl4030_charger.c:105: error: (Each undeclared identifier is reported only once
>  drivers/power/twl4030_charger.c:105: error: for each function it appears in.)
>  drivers/power/twl4030_charger.c: In function ___twl4030_bci_have_vbus___:
>  drivers/power/twl4030_charger.c:137: error: ___TWL4030_PM_MASTER_STS_HW_CONDITIONS___ undeclared (first use in this function)
> 
> The new driver does not build at its own commit point either, as the missing symbol 
> definition is simply not there. It appears that commit 2e727f1 could not have been 
> build-tested by anyone before it got upstream (let alone boot and functionality 
> tested). As a temporary workaround i'm disabling it in -tip.
> 

Those definitions get added by the MFD tree and used by the battery
tree.  Things arrived in the wrong order (and, yes, didn't get tested).

The fix is for Samuel to get a wiggle on with his merge?  The -rc1
window is about to slam shut on his fingers anyway.
