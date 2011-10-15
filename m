Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab1JOSfB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 14:35:01 -0400
Received: from netrider.rowland.org ([192.131.102.5]:33132 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752071Ab1JOSfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 14:35:00 -0400
Date: Sat, 15 Oct 2011 14:34:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: NeilBrown <neilb@suse.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of suspend/hibernate
 interfaces
In-Reply-To: <20111015080718.01aef515@notabene.brown>
Message-ID: <Pine.LNX.4.44L0.1110151426420.15129-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Oct 2011, NeilBrown wrote:

> > One of the things Rafael didn't mention is that sometimes a kernel 
> > driver needs to prevent the system from suspending.  This happens when 
> > recharging over a USB connection.
> > 
> > There's no simple way for such a driver to communicate with a power
> > daemon.  The driver has to use something like the wakeup mechanism -- 
> > but currently that mechanism is optional.
> > 
> > Alan Stern
> 
> Certainly I don't expect a kernel driver to communicate directly with a
> user-space daemon.  It communicates indirectly through the wakeup_source
> mechanism.
> If user-space wants to block suspend, it talks to the suspend daemon (power
> manager) some how (dbus, lock files, sockets, signals, whatever).
> If the kernel wants to block suspend, it activates a wakeup_source (aka
> caffeine source) which the suspend daemon notices via /sys/power/wakeup_count.
> 
> But you say this wakeup mechanism is optional .... I don't see that.
> 
> It is implemented in drivers/base/power/wakeup.c which is included in the
> kernel if CONFIG_PM_SLEEP which is defined as
> 
> config PM_SLEEP
> 	def_bool y
> 	depends on SUSPEND || HIBERNATE_CALLBACKS
> 
> which seems to mean "enable this unless we don't have suspend and we don't
> have hibernate".
> 
> So it seems that the only time we don't have the wakeup mechanism, we also
> have no risk of ever going to sleep.
> 
> What exactly where you saying was "optional"?? I don't understand.

It's optional in the sense that user programs can bypass it.  They 
aren't forced to read or write /sys/power/wakeup_countm, and if they 
don't then the wakeup mechanism won't prevent the system from 
suspending.

Alan Stern

