Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab1GEQ2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:28:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48196 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755045Ab1GEQ2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:28:23 -0400
Date: Tue, 5 Jul 2011 12:28:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Partha Basak <p-basak2@ti.com>, Keshava Munegowda <keshava_mgowda@ti.com>,
        USB list <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Anand Gadiyar <gadiyar@ti.com>, <sameo@linux.intel.com>,
        <parthab@india.ti.com>, <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        <paul@pwsan.com>, <johnstul@us.ibm.com>,
        Vishwanath Sripathy <vishwanath.bs@ti.com>
Subject: Re: [PATCH 6/6 v2] arm: omap: usb: global Suspend and resume support
 of ehci and ohci
In-Reply-To: <20110705155312.GQ2820@legolas.emea.dhcp.ti.com>
Message-ID: <Pine.LNX.4.44L0.1107051220220.2060-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jul 2011, Felipe Balbi wrote:

> > >  Well, of
> > > course runtime PM will conserve power on runtime, but system suspend
> > > should be no different other than an "always deepest sleep state"
> > > decision.
> > 
> > No, it is significantly different for several reasons.  Some of the
> > most important differences are concerned with freezing userspace and
> > deciding what events should be allowed to wake up the system.  Also, 
> > there are systems which can achieve greater power savings by system 
> > sleep than they can by runtime PM + cpuidle.
> 
> I remember we've been through this discussion before and it's just
> nonsensical to make such statement. What does freezing userspace have to
> do with power consumption ? If you can't reach lower power consumption
> with runtime PM it only means userspace is waking the system too much.

_That's_ what freezing userspace has to do with power consumption.  You 
have answered your own question.

And don't forget the other points about wakeup events and greater power
savings.  If you want to discuss this further, you should start a new
thread on linux-pm.


> > Furthermore, from what I've gathered so far from this thread, the
> > _real_ problem is that nobody has written suspend and resume callbacks
> > for the parent device.  You're relying on runtime PM to do things with
> > the parent, but instead you should make use of the usual system sleep
> > mechanism: Parents are always suspended after their children and
> > awakened before.  Have the parent's suspend routine disable the clocks 
> > and have the resume routine enable them.  Problem solved, no changes 
> > needed in the child's driver code.
> 
> that's currently hidden on the omap rutime pm support. No driver is to
> talk to clk API directly anymore. Granted, now that I read what I just
> wrote it does sound like it's a limitation, although it's really nice
> not to have to remember all the numerous clocks needed for a particular
> device to work properly. So, if there would be a way, other than
> pm_runtime_resume(), to enable all clocks a particular device has
> without really having to clk_get(); clk_enable() each one of them, fine,
> this would be solved. But as of today, we only have pm_runtime_resume()
> to achieve that, unless I'm missing something.

(Actually, your problem isn't enabling clocks during resume; it is 
disabling them during suspend.)

The OMAP maintainer should be involved in this discussion.  Basically,
the new PM domain framework is now supposed to handle these issues.

Alan Stern

