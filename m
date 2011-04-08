Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab1DHGDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 02:03:11 -0400
Received: from imr3.ericy.com ([198.24.6.13]:50677 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab1DHGDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 02:03:09 -0400
Date: Thu, 7 Apr 2011 23:02:18 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Natarajan Gurumoorthy <natg@google.com>
CC: Jean Delvare <khali@linux-fr.org>, Wim Van Sebroeck <wim@iguana.be>,
        Mike Waychison <mikew@google.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v2 0/3] Make all it87 drivers SMP safe.
Message-ID: <20110408060218.GA5233@ericsson.com>
References: <1302211560-8052-1-git-send-email-natg@google.com>
 <20110408003742.GD3942@ericsson.com>
 <BANLkTimsB9EoOVq1fojcazU4GCFyqPmF=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BANLkTimsB9EoOVq1fojcazU4GCFyqPmF=w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 12:58:05AM -0400, Natarajan Gurumoorthy wrote:
> Guenter,
>       Comments are below
> 
> On Thu, Apr 7, 2011 at 5:37 PM, Guenter Roeck
> <guenter.roeck@ericsson.com> wrote:
> >
> > Did you consider naming this file include/linux/it87.h as suggested ?
> > I thought that was a goodd idea.
> >
> This does seem to be a good idea. I had some other thoughts about
> where to place the
> it87_lock.c file. One thought was to move the lock into the
> drivers/mfd directory and
> completely decouple the lock from the watchdog or the hwmon
> directories. The mfd/Kconfig
> would contain the IT87_LOCK.
> 
Might make sense, but I would suggest to solicit feedback from others before
you do that. Specifically you'll need some guidance from the watchdog maintainer
and possibly from the mfd maintainer if your current solution is acceptable
or if the mfd solution would be better (ie more likely to be accepted).

If you move the lock handling to mfd, you probably want to name the file it87.c,
or maybe it87-core.c, to ensure that other functionality can be added to it
without having to rename the file.

> > When you send out new versions of your patch set, it would be prudent
> > to list the patch version, as well as the changes made compared to previous
> I am new at this. Exactly where do you list the patch version. I put
> v2 in the subject line.

That was ok.

> The only difference between the 2 patch sets was that each of the patches has a
> more verbose body section explaining the contents of the patch and
> each of the sub patch
> Subject line reflected what was happening in that sub patch. I also
> made sure I had the
> "In-Reply-To" entry in the patches.
> 
This somehow didn't work. If you look at the kernel.org mailing list, it
did not recognize your series of patches as a single thread, but lists
it as independent posts.

You might want to play with that by sending series of patches to yourself 
and check if your mailer recognizes it as one thread.

> Where in the patch do you discuss the changes made with respect to the
> previous patch.
> 
See SubmittingPatches, #15. Add version information (ie what changed in which version)
after the "---" marker line, such as 

---
v2: Changed subject line to be meaningful, added description

One hint - the first comment line in each of your patches is a bit odd and should
not really be there. Keep in mind that everything up to the "---" line will end up
in the commit log unless the maintainer takes it out. The rest of the explanations
looked ok to me.

> When I send out the next set of patches do I have to send out the
> entire patch set marked as v3.
> 
If you change the header file name and/or location, each of the patches will be affected,
so each of the patches should get a new version number. If you don't change anything,
don't resubmit (yet).

Thanks,
Guenter
