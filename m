Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab0DSVVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:21:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab0DSVVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:21:51 -0400
Date: Mon, 19 Apr 2010 17:21:35 -0400
From: Don Zickus <dzickus@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>, mingo@elte.hu
Cc: peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: Re: [PATCH v2] [watchdog] combine nmi_watchdog and softlockup
Message-ID: <20100419212135.GN15159@redhat.com>
References: <1271366710-17468-1-git-send-email-dzickus@redhat.com>
 <20100416014712.GC15570@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100416014712.GC15570@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 03:47:14AM +0200, Frederic Weisbecker wrote:
> On Thu, Apr 15, 2010 at 05:25:10PM -0400, Don Zickus wrote:
> > The new nmi_watchdog (which uses the perf event subsystem) is very
> > similar in structure to the softlockup detector.  Using Ingo's suggestion,
> > I combined the two functionalities into one file, kernel/watchdog.c.
> > 
> > Now both the nmi_watchdog (or hardlockup detector) and softlockup detector
> > sit on top of the perf event subsystem, which is run every 60 seconds or so
> > to see if there are any lockups.

Hello all,

After making a bunch of cleanups, I am stuck debating whether to continue
updating this patch on the stale branch perf/nmi on Ingo's tree or just
repost the whole patch again (which isn't much bigger just adds the
arch/x86/kernel/apic/hw_nmi.c piece).

Part of the new patch series includes removing kernel/nmi_watchdog.c,
which seemed kinda silly because it was only an intermediate file until
things got shifted to kernel/watchdog.c

Thoughts?

Cheers,
Don
