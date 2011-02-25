Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975Ab1BYU1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:27:54 -0500
Received: from adelie.canonical.com ([91.189.90.139]:37587 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab1BYU1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:27:52 -0500
Date: Fri, 25 Feb 2011 14:27:48 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Performance/resume issues on Toshiba NB305
Message-ID: <20110225202748.GB24686@thinkpad-t410>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <20110225164239.GA24686@thinkpad-t410>
 <20110225201747.GB23161@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225201747.GB23161@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 03:17:47PM -0500, Steven Rostedt wrote:
> Would be helpful to Cc the people that may help you.
> 
> 
> On Fri, Feb 25, 2011 at 10:42:39AM -0600, Seth Forshee wrote:
> > I've been looking into a couple of problems with this machine that have
> > me a bit stumped at the moment. The two problems may or may not be
> > related, so I'm including details about both issues below. If anyone has
> > any ideas, I'd love to hear them. Note that these are not recent
> > regressions; they've been around since at least 2.6.32.
> > 
> > The CPU in this machine is an Atom N450.
> > 
> > When booted normally the performance on this machine is very poor, but
> > when booted with any of nohz=off, nolapic, or nohpet it improves
> > significantly. The performance also improves if I use the patch below to
> > force the hpet to remain in periodic mode (with hpet=periodic on the
> > command line).
> > 
> > One other thing I noticed when I had added some logging related to hpet
> > rearming is 3-5 second periods of no log activity occurring fairly
> > frequently, whereas such inactive periods are infrequent when
> > performance is good and are also infrequent on another machine with very
> > similar hardware and no performance issues.
> > 
> > The machine also hangs for 5 minutes during resume, unless booted with
> > both nohz=off and highres=off, or with hpet=periodic using the patch
> > below. I've traced this down to hanging in an SMI handler during the
> > ACPI _WAK method execution. The 5 minutes corresponds to how long it
> > takes for the low 32 bits of the hpet to wrap in this machine, and since
> > the options that eliminate the hang result in the hpet being in periodic
> > mode during _WAK method execution I suspect that the SMI handler is
> > hanging until a timer interrupt happens.
> > 
> > One possible explanation here is that the performance problems are also
> > related to hangs in SMI handlers until there's a timer interrupt,
> > although I don't know how that explains why some of the command line
> > options eliminate the performance issues.
> 
> Sounds like a buggy BIOS to me. Is there upgrades available for this
> box?

It does sound like a buggy BIOS. I've already flashed the latest BIOS
though, so no luck there.
