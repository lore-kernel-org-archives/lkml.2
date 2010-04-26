Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab0DZQXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 12:23:19 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:61461 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab0DZQXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 12:23:17 -0400
Date: Mon, 26 Apr 2010 12:22:58 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Vroon <tony@linx.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: commit 9630bdd9 changes behavior of the poweroff - bug?
In-reply-to: <20100426150503.GA4005@tiehlicka.suse.cz>
Message-id: <alpine.LFD.2.00.1004261130090.3999@localhost.localdomain>
References: <20100401133923.GA4104@tiehlicka.suse.cz>
 <20100419115942.GC5160@tiehlicka.suse.cz> <201004191719.53602.rjw@sisk.pl>
 <201004250435.42779.rjw@sisk.pl> <20100426150503.GA4005@tiehlicka.suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal,

> my laptop changed behavior during poweroff recently (after upgrading
> from .33 to .34-rc1). The system seems to be powered off (status display
> is off) at first glance but when I close the lid then I can hear a noise
> which sounds like HDD parking and when I open lid again it starts
> booting without poweroff button (same like when I suspend to RAM).

Tony,

> I have the exact same "lid close = powering back on" regression on a
> Fujitsu-Siemens Lifebook S6420.

Perhaps you can review this description and help me
better understand the symptoms?

Michal,
Re: poweroff

Before the regression you could hear the HDD park as a result of the
"poweroff" command without touching the lid, and after the regression
you don't hear that sound until after you close the lid -- no matter
how long you wait to close the lid?

During this period after poweroff and LCD goes out, but before
lid close, are there any other signs of life?  eg. does caps
lock button light the caps LED?

How about during this period if you press the power button and
hold it for 5 seconds, does that cause the HDD parking sound?

If yes, then the regression is that poweroff never completes,
though perhaps a lid event allows it to complete.

When you say 'when I open the lid again i starts booting'.
Is that a cold boot from scratch, or a resume from suspend?

Does the new boot start when the lid is closed, or when it is
subsequently opened?

Thanks for sending your /proc/acpi/wakeup, it shows that

LID       S4    *enabled  

which means that the LID is not an S5 wakeup device.
So if you really do get down to S5, the LID should
not be able to wake the system.  So if it is, then
we are never getting to S5.

Tony,
Please send the /proc/acpi/wakeup file before and after
the regression.  Does the system reach a complete poweroff
before the lid is closed?  If yes, what happens when
you press the power button w/o closing the lid?
If you reached S5, it should give you a cold boot.
If you did not reach S5, it will have no effect.

thanks,
Len Brown, Intel Open Source Technology Center

