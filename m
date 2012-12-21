Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab2LUWEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 17:04:44 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:40264 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab2LUWEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 17:04:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jan-Matthias Braun <jan_braun@gmx.net>, Jiri Kosina <jkosina@suse.cz>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Resend][PATCH] PM: Move disabling/enabling runtime PM to late suspend/early resume
Date: Fri, 21 Dec 2012 23:09:57 +0100
Message-ID: <1399643.20qlzBtAyt@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <87d2y3dvxj.fsf@deeprootsystems.com>
References: <1988667.JSHu2WyJuF@vostro.rjw.lan> <3307221.dy6xvn45xe@vostro.rjw.lan> <87d2y3dvxj.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 21, 2012 11:52:56 AM Kevin Hilman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > Currently, the PM core disables runtime PM for all devices right
> > after executing subsystem/driver .suspend() callbacks for them
> > and re-enables it right before executing subsystem/driver .resume()
> > callbacks for them.  This may lead to problems when there are
> > two devices such that the .suspend() callback executed for one of
> > them depends on runtime PM working for the other.  In that case,
> > if runtime PM has already been disabled for the second device,
> > the first one's .suspend() won't work correctly (and analogously
> > for resume).
> >
> > To make those issues go away, make the PM core disable runtime PM
> > for devices right before executing subsystem/driver .suspend_late()
> > callbacks for them and enable runtime PM for them right after
> > executing subsystem/driver .resume_early() callbacks for them.  This
> > way the potential conflitcs between .suspend_late()/.resume_early()
> > and their runtime PM counterparts are still prevented from happening,
> > but the subtle ordering issues related to disabling/enabling runtime
> > PM for devices during system suspend/resume are much easier to avoid.
> >
> > Reported-and-tested-by: Jan-Matthias Braun <jan_braun@gmx.net>
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Yes!  
> 
> Of course if there are dependencies between drivers late/early
> callbacks, we'll still have the same problems, but those should be
> *very* rare compared to the suspend/resume dependencies.  

Well, let's put it this way: Any dependencies between drivers' late/early
callbacks that make things break because runtime PM is disabled at that time
are bugs that need to be fixed.

Why?

Because runtime PM has always been disabled during late/early callbacks since
they were introduced and if somebody conveniently ignored that, then this is
this person's problem entirely.

> I haven't been able to do any testing with this yet (I'm away from my
> hardware for a bit), but I totally support this change.  
> 
> Reviewed-by: Kevin Hilman <khilman@deeprootsystems.com>

Thanks!

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
