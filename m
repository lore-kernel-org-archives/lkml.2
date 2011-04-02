Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab1DBTog (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 15:44:36 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:43732 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756612Ab1DBTof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 15:44:35 -0400
Date: Sat, 02 Apr 2011 15:44:30 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 16/18] 2.6.40: x86 idle APM: remove deprecated
 apm_cpu_idle()
In-reply-to: <20110402124054.49c3a3f4@lxorguk.ukuu.org.uk>
Message-id: <alpine.LFD.2.02.1104021529580.18682@x980>
References: <alpine.LFD.2.02.1104010020280.2797@x980>
 <1301725380-10579-1-git-send-email-lenb@kernel.org>
 <5d9716021b20302ece48fd486bbad9bcb2502353.1301724243.git.len.brown@intel.com>
 <20110402124054.49c3a3f4@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > There is some doubt whether the APM idle feature
> > to call into the BIOS from the idle loop is reliable.
> > Certainly it was known to fail on some machines,
> 
> And it was known to work on lots - a point that despite repeated
> reminding you seem keen to ignore.
> 
> The fundamental problem I have with this patch set is this
> 
> You've provided no architectural overall justification for all this
> effort. What is the big picture around your crusade here ? What is the
> grand plan ?

This patch series was posted in reply to a table of contents

https://lkml.org/lkml/2011/4/2/8

"By the end of this series, pm_idle is removed as a public
 x86 idle-loop registration mechanism.  A few other things are
 cleaned up in the process."

I labeled it "idle cleanup - v3" -- I'm sorry if it went un-noticed
because I neglected to put the [PATCH 0/18] on it.

Trinabh also replied to you, pointing one of the previous
LKML discussions about the mis-use of pm_idle.

> > but more importantly, APM machines have not shipped
> > for a decade and so finding machines to test the code
> > is problematic.
> 
> So don't test it - if it's wrong someone will let you know, believe me 8)
> 
> And 2.6.40 is far too soon - it takes about a year for stuff to rattle
> through to leading edge distro users in bulk

If you insist.

We'll create a new APM cpuidle driver in Linux (Trinabh prototyped one),
and at the same time, schedule it for removal in a year.  Personally,
I think it is make-work, and in real-life it is more likely to do
more harm than removing apm_idle, but I don't want to stand in the
way of process.

thanks,
-Len

