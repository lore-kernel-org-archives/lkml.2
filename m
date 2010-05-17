Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab0EQUVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 16:21:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38476 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755269Ab0EQUVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 16:21:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Brian Swetland <swetland@google.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Date: Mon, 17 May 2010 22:22:22 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: me@felipebalbi.com, James Bottomley <James.Bottomley@suse.de>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-omap@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>, Geoff Smith <geoffx.smith@intel.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Tejun Heo <tj@kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Matthew Garrett <mjg@redhat.com>
References: <Pine.LNX.4.44L0.1005151716180.24645-100000@netrider.rowland.org> <20100517183904.GA14047@gandalf> <AANLkTillcFg_y-GeXJNBuIYiGvht-NBZPxwdb71qDui0@mail.gmail.com>
In-Reply-To: <AANLkTillcFg_y-GeXJNBuIYiGvht-NBZPxwdb71qDui0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005172222.22494.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 May 2010, Brian Swetland wrote:
> On Mon, May 17, 2010 at 11:39 AM, Felipe Balbi <me@felipebalbi.com> wrote:
...
> > but can anyone write an app that holds a suspend_blocker ?? If so, then
> > your goal is already broken, right ? I mean, if anyone can keep a
> > suspend_blocker held forever, you'll never ever sleep, right ? While
> > with runtime, if you keep the keypad open, only the keypad and the paths
> > directly related to it (probably the i2c controller and the power domain
> > where the i2c controller sits) will be kept alive, no ?
> 
> No, you'll never suspend, which is different from never going to the
> lowest CPU power state.  On shipping Android devices we aggressively
> completely power down the CPU in idle whenever we can (based on
> latency requirements generally).  We power off peripherals whenever
> they're not in use.
> 
> This is why I've stated previously that I don't think runtime PM and
> opportunistic suspend are competitive features.

Agreed.

> Everyone who cares about minimizing power should want runtime pm or at least
> similar functionality (our drivers have always powered down peripherals when
> not in use, even while the device is open, etc, prior to the existence
> of runtime PM).

Yes.

> If your environment is such that going to full suspend will not gain
> you anything, then don't use opportunistic suspend.

Exactly.

> We find that there are savings to be had with this model in Android which is
> why we use it.  If you are going to use opportunistic suspend,
> suspend_blockers provide useful functionality.

And as I said, I regard this as a legitimate approach to power management.

Thanks,
Rafael
