Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab1BRS2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 13:28:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37840 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab1BRS2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 13:28:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Rabin Vincent <rabin@rab.in>
Subject: Re: platform/i2c busses: pm runtime and system sleep
Date: Fri, 18 Feb 2011 19:28:05 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc5+; KDE/4.4.4; x86_64; ; )
Cc: stern@rowland.harvard.edu, linux-pm@lists.linux-foundation.org,
        linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        khilman@ti.com, magnus.damm@gmail.com
References: <AANLkTinyDE3OxKup_aqsN8HJH_r5LcwkP17OtuMRpACx@mail.gmail.com> <AANLkTikRUZRh0YnP8nYTKFnFeUiJbK5xKvHHjn_S+gZE@mail.gmail.com> <AANLkTinsPqFcodH0w7LQeFEY+amodNH4CneRCRhhbKaz@mail.gmail.com>
In-Reply-To: <AANLkTinsPqFcodH0w7LQeFEY+amodNH4CneRCRhhbKaz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102181928.05911.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 18, 2011, Rabin Vincent wrote:
> On Thu, Feb 17, 2011 at 20:55, Rabin Vincent <rabin@rab.in> wrote:
> > This will solve the platform vs AMBA bus, but shouldn't we really be
> > aiming for consistent behaviour between these and the other busses such
> > as I2C and SPI, which are also usually commonly used on the same
> > platforms and are using GENERIC_PM_OPS?
> >
> > Should we be auditing all platform drivers and then switch platform to
> > the GENERIC_PM_OPS?
> >
> > Or should the two points (1) and (2) be not handled in the bus at all
> > and be left to individual drivers (in which case we should audit i2c and
> > spi and change GENERIC_PM_OPS)?
> 
> How about something like the below?  If we have something like this, we
> can just switch platform to GENERIC_PM_OPS and add the
> pm_runtime_want_interaction() (or something better named) call to the
> i2c and spi drivers using runtime PM.

Why don't we make platform_bus_type behave along the lines of generic ops
instead?

Rafael
