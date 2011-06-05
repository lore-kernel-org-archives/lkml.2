Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab1FERTL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 13:19:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57600 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab1FERTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 13:19:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: balbi@ti.com
Subject: Re: [PATCH 4/4] mfd: global Suspend and resume support of ehci and ohci
Date: Sun, 5 Jun 2011 19:19:38 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: Keshava Munegowda <keshava_mgowda@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        gadiyar@ti.com, sameo@linux.intel.com, parthab@india.ti.com,
        tony@atomide.com, khilman@ti.com, b-cousson@ti.com, paul@pwsan.com
References: <1306934847-6098-1-git-send-email-keshava_mgowda@ti.com> <201106011554.38415.rjw@sisk.pl> <20110601143256.GG2409@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110601143256.GG2409@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201106051919.38637.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 01, 2011, Felipe Balbi wrote:
> Hi,
> 
> On Wed, Jun 01, 2011 at 03:54:38PM +0200, Rafael J. Wysocki wrote:
> > > +static const struct dev_pm_ops usbhsomap_dev_pm_ops = {
> > > +	.suspend	= usbhs_suspend,
> > > +	.resume		= usbhs_resume,
> > > +};
> > 
> > Please add .freeze()/.thaw() and .poweroff()/.restore() callbacks too.
> > They may point to the same routines, but must be present.
> > 
> > You can actually use the SIMPLE_DEV_PM_OPS() convenience macro for this
> > purpose.
> 
> good point. BTW, do we need this #ifdef CONFIG_PM stuff which has been
> popping on most drivers recently ? To me it looks like driver.pm field
> is always available even if PM is disabled, so what's the point ? Saving
> a few bytes ?

Basically, yes (you may want to avoid defining the object this points to if
CONFIG_PM is unset).

Thanks,
Rafael
