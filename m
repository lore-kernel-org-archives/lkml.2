Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab0EQTYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:24:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:45147 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657Ab0EQTYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:24:39 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
From: James Bottomley <James.Bottomley@suse.de>
To: me@felipebalbi.com
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-omap@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>, Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Matthew Garrett <mjg@redhat.com>
In-Reply-To: <20100517181252.GA14260@gandalf>
References: <Pine.LNX.4.44L0.1005151716180.24645-100000@netrider.rowland.org>
	 <87hbm6cz90.fsf@deeprootsystems.com>
	 <1274115885.4418.59.camel@mulgrave.site> <20100517174647.GA11512@gandalf>
	 <1274119179.4418.68.camel@mulgrave.site>  <20100517181252.GA14260@gandalf>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 15:24:27 -0400
Message-ID: <1274124267.4418.149.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 21:12 +0300, Felipe Balbi wrote:
> Hi,
> 
> On Mon, May 17, 2010 at 01:59:39PM -0400, James Bottomley wrote:
> > Have you actually tried this?  On my N1 with CM5.0.6 just running
> > powertop requires me to keep the USB system up (debugging cable) and
> > paths into the usb console ... all of this produces significant wakeup
> > distortion, mostly in the msm i2c subsystem.  But in all the noise it's
> > hard to find rogue applications.
> 
> Well, I use serial console, but in the worst case scenario I would make
> powertop save the output to a memory buffer a big one, and after
> finished flush to some mmc or anything like that.

Surely, depending on your UART FIFO depth, of course, a serial console
interrupts once every 16 characters or so ... how do you filter out that
storm of interrupts refreshing the powertop screen from the actual
application problems?

But anyway, the average user probably either doesn't have or doesn't
know how to get to a serial console on their phone ...

> > The technical reason for wanting suspend blockers (as has been stated
> > more times than I can be bothered to go back and count) is that no-one
> > can currently produce a working model for race free kernel to user work
> > handoff and, in the face of open app stores, rogue applications are a
> > significant problem.  The fact that suspend blockers enables easy
> > identification of power hogging apps is just a very useful side effect.
> 
> I still can't get over the fact that suspend_blockers are dealing with
> userland problems in kernel space. If we can't really trust apps, I'm
> sorry but companies like Google and Nokia (which I work for) will have
> to setup better application acceptance on their stores. The fact that we
> can get statistics of power usage from kernel space is actually really
> good and could be easily automated on an AppStore environment. If it's
> cause too many wakeups you report that to the developer of the app
> before accepting. The same feature could be shipped on the SDK, so
> developer has also early feedback about how good (or bad) his/her
> application really is to the system.
> 
> IMO we should be celebrating good apps, not dealing in kernel space with
> bad ones. And on top of all that, we would still need custom
> applications with suspend_blockers support built into them.

If you actually s/app/USB storage device/ (with a few other obvious text
changes) in most of the above two paragraphs, you've got a good
description of the problems we go through on an almost daily basis in
the kernel for USB storage ... and why we've grown a massive exception
table.

Just saying "devices should conform to specifications" is a wonderful
magic wand for wishing away all the problems bad devices cause and
bludgeoning manufacturers with the said spec wrapped around a large lead
brick is very cathartic but it doesn't change the fact that users blame
the kernel for not working with the bad devices ... and we gave up
trying to re-educate users on that score years ago.

James


