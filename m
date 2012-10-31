Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380Ab2JaSYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:24:12 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:33879 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754260Ab2JaSYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:24:10 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18r4ZhsZgkthxEAqVOsITh0
Date: Wed, 31 Oct 2012 11:24:01 -0700
From: Tony Lindgren <tony@atomide.com>
To: Loic PALLARDY <loic.pallardy@st.com>
Cc: Omar Ramirez Luna <omar.luna@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Juan Gutierrez <jgutierrez@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Suman Anna <s-anna@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/2] ARM: OMAP2+: move mailbox.h out of plat-omap
 headers
Message-ID: <20121031182401.GM12739@atomide.com>
References: <1351530381-11459-1-git-send-email-omar.luna@linaro.org>
 <1351530381-11459-2-git-send-email-omar.luna@linaro.org>
 <20121029175228.GD11908@atomide.com>
 <CALLhW=4ukBuRSVcPm2A37PgBhv33yKqk2G=Dz2XTUyswXw=JMg@mail.gmail.com>
 <20121030162441.GF11908@atomide.com>
 <20121030210213.GA6098@kroah.com>
 <CALLhW=6p06MPdfbD2S-PRs=w0zLNsEifsJ2xL0hjEZaFpbadDA@mail.gmail.com>
 <5090E515.9050407@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5090E515.9050407@st.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Loic PALLARDY <loic.pallardy@st.com> [121031 01:48]:
> 
> Hi Omar,
> 
> On 10/31/2012 08:22 AM, Omar Ramirez Luna wrote:
> >
> > As part of plat-omap code cleanup, I was planning to move omap-mailbox
> > framework to a newly drivers/mailbox folder, right now this code is
> > specific to OMAP platforms, but with some clean up it could be the
> > base for a generic framework. And living under drivers/mailbox could
> > give it some exposure for interested developers to give feedback and
> > propose changes.
> >
> > In the past there was a mailbox-like driver in mach-ux500, I was
> > hoping both could live under the same folder, however the platform
> > using it, was dropped a couple of kernel releases back and with it the
> > other similar mailbox implementation.
> 
> On STE side, we are working on a mailbox driver which will rely on 
> mailbox framework.
> However some modifications in current Omap mailbox framework are needed 
> to fit STE HW specificities.
> - API naming should be generic (replace omap prefix by mailbox)
> - message type should be enhanced
> - fifo mechanism is linked to Omap maibox, not needed in STE case since 
> it relies on cross interrupt + shared memory
> I already have modifications I'll send you to see how we can create a 
> common and generic mailbox framework.

OK cool. How about Omar first posts the fixed minimal patches
to move things to live under drivers so can fix up omap for
ARCH_MULTIPLATFORM?

I can then put just those into an immutable branch that people
can pull in as needed, and you guys can continue from there with
the common mailbox framework (and I can continue work on the
core omap code independently of the mailbox framwork work).

Regards,

Tony
