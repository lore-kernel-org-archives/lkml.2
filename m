Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab1I1ISQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 04:18:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:58094 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab1I1ISO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 04:18:14 -0400
Date: Wed, 28 Sep 2011 10:18:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        markgross@thegnar.org, Alan Stern <stern@rowland.harvard.edu>,
        amit.kucheria@linaro.org, farrowg@sg.ibm.com,
        "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com
Subject: Re: [PATCH 0/6] [RFC] Proposal for optimistic suspend idea.
In-Reply-To: <1317172798.3112.742.camel@work-vm>
Message-ID: <alpine.LFD.2.02.1109280953000.2711@ionos>
References: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>  <1317068164.1763.39.camel@twins> <1317076065.3112.539.camel@work-vm>  <alpine.LFD.2.02.1109280145150.2711@ionos> <1317172798.3112.742.camel@work-vm>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Sep 2011, John Stultz wrote:
> On Wed, 2011-09-28 at 02:09 +0200, Thomas Gleixner wrote:
> > We have proper mechanisms in place to handle such stuff, but they need
> > proper overall design and definitely a bit more brain usage than just
> > yelling "wakelock".
> 
> And it would be great if some of that brain usage was spent to review
> and critique what I'm actually proposing, rather then just yelling
> "wakelock". :P

Working on it :)
 
> I apologize for being probably too verbose in my mails, but I did
> originally admit that the firmware update issue is a simpler problem and
> doesn't necessarily need the same solution as the races around my
> nightly backups. But I do think that some thought should be put into the
> different use cases that seem to desire similar things, so that an
> appropriate design can be created, instead of a collection of short-term
> hacks.

Yes, we want use cases, which can actually justify something like the
proposed.

Firmware update is _not_ one of them because it needs a proper design
to be completely failsafe and just preventing the box to suspend is
not helping that goal at all. You have to deal with broken network
connections, resets, power outage and more to make it failsafe. And
dealing with all of that covers the unintended suspend already. It
simply does not matter whether it happens or not.

And that's why I'm ranting about such arguments, as they will just
guide people into the delusion of solving hard problems like safe
firmware updates with the wrong mechanisms.

The whole wakelock discussion has been full of delusions from the very
beginning and we really need to eliminate the lunatic arguments so we
can look at the real remaining ones (if any), which might justify
them.

> More brain usage, and proper design. At least with that, I think we
> agree. :)

Right, and proper design does not exclude user space. It very much
starts there.

Thanks,

	tglx
