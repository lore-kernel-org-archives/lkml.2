Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408Ab1BCSk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 13:40:57 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:40730 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932312Ab1BCSk4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 13:40:56 -0500
Date: Thu, 3 Feb 2011 10:40:51 -0800
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Daniel Drake <dsd@laptop.org>, linux-kernel@vger.kernel.org,
        sodaville@linutronix.de, x86@kernel.org, dirk.brandewie@gmail.com
Subject: Re: [PATCH v2 01/15] x86/e820: remove conditional early mapping in
 parse_e820_ext
Message-ID: <20110203104051.12cdfbe5@queued.net>
In-Reply-To: <AANLkTi=kXaD0qhpHx30tFKN92pmAESSrXE1mz_55yuQO@mail.gmail.com>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
	<1292600033-12271-2-git-send-email-bigeasy@linutronix.de>
	<20101230083745.GC11721@angua.secretlab.ca>
	<20110104130839.GA21359@www.tglx.de>
	<20110114081446.GC21832@angua.secretlab.ca>
	<20110114105709.GA7562@www.tglx.de>
	<20110114134345.712e2e29@queued.net>
	<AANLkTimyrGkqtjo99+aV+N4KcrC2_3PprpRD2tRo_NtC@mail.gmail.com>
	<4D4808D2.3080701@linutronix.de>
	<20110201103617.2c3aa118@debxo>
	<AANLkTi=kXaD0qhpHx30tFKN92pmAESSrXE1mz_55yuQO@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Feb 2011 20:10:13 -0700
Grant Likely <grant.likely@secretlab.ca> wrote:

> On Tue, Feb 1, 2011 at 11:36 AM, Andres Salomon <dilinger@queued.net>
> wrote:
> > On Tue, 01 Feb 2011 14:21:22 +0100
> > Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> >
> >> Daniel Drake wrote:
> >> > Hi,
> >> Hi,
> >>
> >> > Context: https://patchwork.kernel.org/patch/450681/
> >> >
> >> > This patch will indeed cause problems for OLPC. Thanks for
> >> > bringing it to our attention.
> >> >
> >> > On OLPC, the device tree is not used as a source of devices like
> >> > on other platforms, it is simply used to present information to
> >> > the kernel and userspace (in read-only fashion).
> >> >
> >> > If I understand it correctly, the above patch is saying: if we
> >> > have a device tree, don't add the standard x86 RTC device.
> >> Yes.
> >>
> >> > However, what we need it to say is: if we have a device tree
> >> > *and* the device tree is being used as a source of devices,
> >> > don't add the standard x86 RTC device.
> >> >
> >> > Therefore in the OLPC case, this particular bail-out condition
> >> > will never be met, because the device tree is not being used as
> >> > a source of devices.
> >> So it is not case now. Will it ever be?
> >>
> >
> > That is unclear.  For now, it's not, and there aren't plans to make
> > it so.
> >
> >> >
> >> > Does that make sense?
> >>
> >> I don't quite get how or what for do you use the device tree. Could
> >> you please answer me the following questions:
> >> - is the variable allnodes NULL in your case?
> >
> > No.
> >
> >> - variable initial_boot_params should be NULL in your case, right?
> >
> > Yes.
> >
> >> - how should I checked for "device tree is being used as a source
> >> of devices"? The nodes on in the device tree are not probed unless
> >> one calls of_platform_bus_probe() with a few ids. However I do
> >> this now unconditionally which is not a problem unless you have a
> >> device tree ...
> >
> > Perhaps it should be specifically checking for a fdt (by way of
> > initial_boot_params)?   Sparc also does not have
> > initial_boot_params, so one might even be able to drop an #ifdef in
> > the process.
> 
> OLPC is very much the oddball in this case.  Everyone else uses
> devicetree for registering devices.  It could be solved by making OLPC
> explicitly register the RTC.
> 
> g.
> 

That's actually what the plan is; the code just depends on PM features,
which is still being worked on.

