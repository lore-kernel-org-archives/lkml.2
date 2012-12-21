Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab2LUT7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 14:59:30 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:49017 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab2LUT73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 14:59:29 -0500
From: Kevin Hilman <khilman@deeprootsystems.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jan-Matthias Braun <jan_braun@gmx.net>, Jiri Kosina <jkosina@suse.cz>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Resend][PATCH] PM: Move disabling/enabling runtime PM to late suspend/early resume
Organization: Deep Root Systems, LLC
References: <1988667.JSHu2WyJuF@vostro.rjw.lan>
	<3307221.dy6xvn45xe@vostro.rjw.lan>
Date: Fri, 21 Dec 2012 11:52:56 -0800
In-Reply-To: <3307221.dy6xvn45xe@vostro.rjw.lan> (Rafael J. Wysocki's message
	of "Sat, 15 Dec 2012 01:25:58 +0100")
Message-ID: <87d2y3dvxj.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> Currently, the PM core disables runtime PM for all devices right
> after executing subsystem/driver .suspend() callbacks for them
> and re-enables it right before executing subsystem/driver .resume()
> callbacks for them.  This may lead to problems when there are
> two devices such that the .suspend() callback executed for one of
> them depends on runtime PM working for the other.  In that case,
> if runtime PM has already been disabled for the second device,
> the first one's .suspend() won't work correctly (and analogously
> for resume).
>
> To make those issues go away, make the PM core disable runtime PM
> for devices right before executing subsystem/driver .suspend_late()
> callbacks for them and enable runtime PM for them right after
> executing subsystem/driver .resume_early() callbacks for them.  This
> way the potential conflitcs between .suspend_late()/.resume_early()
> and their runtime PM counterparts are still prevented from happening,
> but the subtle ordering issues related to disabling/enabling runtime
> PM for devices during system suspend/resume are much easier to avoid.
>
> Reported-and-tested-by: Jan-Matthias Braun <jan_braun@gmx.net>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Yes!  

Of course if there are dependencies between drivers late/early
callbacks, we'll still have the same problems, but those should be
*very* rare compared to the suspend/resume dependencies.  

I haven't been able to do any testing with this yet (I'm away from my
hardware for a bit), but I totally support this change.  

Reviewed-by: Kevin Hilman <khilman@deeprootsystems.com>

Thanks!

Kevin
