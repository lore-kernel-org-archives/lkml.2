Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab1AKWAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 17:00:36 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:20148 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab1AKWAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 17:00:33 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 24.130.172.179
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/qigJzcMA4yxsCZeMR011U
Date: Tue, 11 Jan 2011 14:00:19 -0800
From: Tony Lindgren <tony@atomide.com>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Walmsley <paul@pwsan.com>, Anand Gadiyar <gadiyar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB merge for .38
Message-ID: <20110111220018.GW4957@atomide.com>
References: <20110106235016.GA2212@kroah.com>
 <AANLkTi=rwv2CW-x_p9SrKghcPKD4TeOAP=2mtp8EcS34@mail.gmail.com>
 <20110107220012.GA26091@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107220012.GA26091@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <gregkh@suse.de> [110107 14:05]:
> On Fri, Jan 07, 2011 at 01:22:40PM -0800, Linus Torvalds wrote:
> > On Thu, Jan 6, 2011 at 3:50 PM, Greg KH <gregkh@suse.de> wrote:
> > >
> > > Nothing radical here at all, lots of musb changes, which touched a bunch
> > > of arch-specific code, and some new drivers, mostly gadget ones.
> > 
> > There were also a number of conflicts with the ARM updates (omap clock
> > data in particular - added aliases, changed names, you name it).
> > 
> > I spent some time trying to fix it up properly, and maybe I even
> > succeeded, but you guys should really look the result over.
> 
> The drivers/usb/* changes look good to me.  I know Tony was looking at
> the omap merge issues, and if there was one, I think he had the needed
> fixup.
> 
> thanks for doing the merge.

The merge was good thanks. The clock changes in the omap tree caused
a minor issue, I have the following patch queued up to fix it. Will
post a pull request soonish along with few other patches.

Regards,

Tony

From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date: Sun, 9 Jan 2011 22:16:13 +0000
Subject: [PATCH] omap3: clocks: Fix build error 'CK_3430ES2' undeclared here

At latest mainline commit 0c21e3aaf6a,  omap2plus build is broken. This
patch is trivial fix for the missed usb clock node for CK_3430ES2PLUS
flag update.

 CHK     include/generated/compile.h
  CC      arch/arm/mach-omap2/clock3xxx_data.o
arch/arm/mach-omap2/clock3xxx_data.c:3289: error: 'CK_3430ES2' undeclared
here (not in a function)
make[1]: *** [arch/arm/mach-omap2/clock3xxx_data.o] Error 1
make: *** [arch/arm/mach-omap2] Error 2

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Anand Gadiyar <gadiyar@ti.com>
Acked-by: Paul Walmsley <paul@pwsan.com>
[tony@atomide.com: updated mask to include CK_36XX]
Signed-off-by: Tony Lindgren <tony@atomide.com>

--- a/arch/arm/mach-omap2/clock3xxx_data.c
+++ b/arch/arm/mach-omap2/clock3xxx_data.c
@@ -3286,7 +3286,7 @@ static struct omap_clk omap3xxx_clks[] = {
 	CLK(NULL,	"cpefuse_fck",	&cpefuse_fck,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
 	CLK(NULL,	"ts_fck",	&ts_fck,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
 	CLK(NULL,	"usbtll_fck",	&usbtll_fck,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
-	CLK("ehci-omap.0",	"usbtll_fck",	&usbtll_fck,	CK_3430ES2 | CK_AM35XX),
+	CLK("ehci-omap.0",	"usbtll_fck",	&usbtll_fck,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
 	CLK("omap-mcbsp.1",	"prcm_fck",	&core_96m_fck,	CK_3XXX),
 	CLK("omap-mcbsp.5",	"prcm_fck",	&core_96m_fck,	CK_3XXX),
 	CLK(NULL,	"core_96m_fck",	&core_96m_fck,	CK_3XXX),
