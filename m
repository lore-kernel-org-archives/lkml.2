Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab1I1JAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 05:00:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60476 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab1I1JAT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 05:00:19 -0400
Subject: Re: [PATCH 0/6] [RFC] Proposal for optimistic suspend idea.
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, markgross@thegnar.org,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 28 Sep 2011 10:59:19 +0200
In-Reply-To: <1317164216.3112.711.camel@work-vm>
References: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
	 <1317068164.1763.39.camel@twins> <1317076065.3112.539.camel@work-vm>
	 <1317119870.15383.29.camel@twins> <1317164216.3112.711.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317200359.5781.47.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-27 at 15:56 -0700, John Stultz wrote:
> 
> But I also want to separate my specific solution from the problem at
> large. I do think that there are issues that my proposal and wakelocks
> address that the hand-wavy "just do it in userspace" rebuttals don't
> deal with (again specifically: wakeup event consumption in userland
> before the next suspend). 

You know, once you drop the whole suspend notion that race goes away.

Esp. on the mobile hardware there really isn't anything different
between a deep idle state and suspend.

So just make the thing idle and your suspend race goes away.

There's still things like the cgroup-freezer if you really want to force
stuff down, but really your core system should be sane and not actually
do anything unless asked.

Also, I'm all for aggressive enforcement, if it doesn't obey they rules,
kill it. Don't mess about with freezing it, that never does the users
any favour.

If they find their app dies a lot, they'll complain to the dev, if the
dev doesn't fix his stuff, the app gets a shitty rating and nobody will
bother installing it again, problem sorted.

We don't try to be friendly in the face of memory protection violations
either.
