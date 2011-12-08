Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab1LHRBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 12:01:25 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:15658 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750763Ab1LHRBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 12:01:23 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/b3fTWySA+nJyARISCEdL/
Date: Thu, 8 Dec 2011 09:01:14 -0800
From: Tony Lindgren <tony@atomide.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Russell King <linux@arm.linux.org.uk>, Greg KH <greg@kroah.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH 4/7] amp/omap: add a remoteproc driver
Message-ID: <20111208170114.GZ31337@atomide.com>
References: <1319536106-25802-1-git-send-email-ohad@wizery.com>
 <1319536106-25802-5-git-send-email-ohad@wizery.com>
 <CAK=WgbZvH3eiouryKDenC_x0LdDcHFuumhfoeY4ueiwT5r0cxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK=WgbZvH3eiouryKDenC_x0LdDcHFuumhfoeY4ueiwT5r0cxA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ohad Ben-Cohen <ohad@wizery.com> [111207 23:26]:
> Hi Tony,
> 
> On Tue, Oct 25, 2011 at 11:48 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> > Add a remoteproc driver for OMAP4, so we can boot the dual-M3 "Ducati"
> > and DSP subsystems.
> >
> > Use the omap_device_* API to control the hardware state, and utilize
> > the OMAP mailbox to interrupt the remote processor when a new message
> > is pending (the mailbox payload is used to tell it which virtqueue was
> > the message placed in).
> >
> > Conversely, when an inbound mailbox message arrives, tell the remoteproc
> > core which virtqueue is triggered.
> >
> > Later we will also use the mailbox payload to signal omap-specific
> > events like remote crashes (which will be used to trigger remoteproc
> > recovery) and power management transitions. At that point we will also
> > extend the remoteproc core to support this.
> >
> > Based on (but now quite far from) work done by Fernando Guzman Lugo
> > <fernando.lugo@ti.com> and Hari Kanigeri <h-kanigeri2@ti.com>.
> >
> > Designed with Brian Swetland <swetland@google.com>.
> >
> > Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> > Cc: Brian Swetland <swetland@google.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Cc: Tony Lindgren <tony@atomide.com>
> > Cc: Russell King <linux@arm.linux.org.uk>
> > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Greg KH <greg@kroah.com>
> > Cc: Stephen Boyd <sboyd@codeaurora.org>
> > ---
> >  arch/arm/plat-omap/include/plat/remoteproc.h |   56 ++++++
> >  drivers/amp/remoteproc/Kconfig               |   21 +++
> >  drivers/amp/remoteproc/Makefile              |    4 +-
> >  drivers/amp/remoteproc/omap_remoteproc.c     |  248 ++++++++++++++++++++++++++
> >  drivers/amp/remoteproc/omap_remoteproc.h     |   69 +++++++
> >  5 files changed, 397 insertions(+), 1 deletions(-)
> >  create mode 100644 arch/arm/plat-omap/include/plat/remoteproc.h
> >  create mode 100644 drivers/amp/remoteproc/omap_remoteproc.c
> >  create mode 100644 drivers/amp/remoteproc/omap_remoteproc.h
> 
> I'm about to add this to linux-next (minus the 'amp' wording); can I
> please have your Acked-by for this (at least for the plat-omap change) ?

The platform init code looks OK to me. Please also start considering
how to do the DT bindings for it. For patches 4 & 5:

Acked-by: Tony Lindgren <tony@atomide.com>
