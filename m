Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab1I2Dpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 23:45:39 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:40765 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab1I2Dpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 23:45:38 -0400
Subject: Re: [PATCH 0/6] [RFC] Proposal for optimistic suspend idea.
From: John Stultz <john.stultz@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, markgross@thegnar.org,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1317200359.5781.47.camel@twins>
References: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
	 <1317068164.1763.39.camel@twins> <1317076065.3112.539.camel@work-vm>
	 <1317119870.15383.29.camel@twins> <1317164216.3112.711.camel@work-vm>
	 <1317200359.5781.47.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Sep 2011 20:45:25 -0700
Message-ID: <1317267925.3112.810.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 10:59 +0200, Peter Zijlstra wrote:
> On Tue, 2011-09-27 at 15:56 -0700, John Stultz wrote:
> > 
> > But I also want to separate my specific solution from the problem at
> > large. I do think that there are issues that my proposal and wakelocks
> > address that the hand-wavy "just do it in userspace" rebuttals don't
> > deal with (again specifically: wakeup event consumption in userland
> > before the next suspend). 
> 
> You know, once you drop the whole suspend notion that race goes away.
> 
> Esp. on the mobile hardware there really isn't anything different
> between a deep idle state and suspend.

Well, except timer noise and device irq noise.

> So just make the thing idle and your suspend race goes away.

Maybe hardware vendors will surprise me, but I don't think the power
difference between suspend and idle will get close enough in a
reasonable amount of time on server hardware.

Even then, I doubt you'll see standard distros that get minutes of
un-interrupted deep-idle. 

How long until you realistically expect to leave your laptop overnight
off of AC without suspending it (and not have it be on fumes in the
morning)? 

> There's still things like the cgroup-freezer if you really want to force
> stuff down, but really your core system should be sane and not actually
> do anything unless asked.

I think the cgroup-freezer is closer to the lines I'm thinking of, but
with the potential to do "importance" inheritance so interactions
between tasks in different groups (be they cgroups or sched classes) can
work normally.

thanks
-john


