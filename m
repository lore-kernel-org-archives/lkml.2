Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab2G0OhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 10:37:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274Ab2G0OhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 10:37:21 -0400
Date: Fri, 27 Jul 2012 10:37:15 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Sameer Nanda <snanda@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/watchdog.c : fix smp_processor_id() warning
Message-ID: <20120727143715.GK5637@redhat.com>
References: <1343191185-7746-1-git-send-email-ming.lei@canonical.com>
 <20120726194324.GG5637@redhat.com>
 <CACVXFVPdKzHXE=mV=FOx8xV4BLUEo_Ey9p6e9CkSOHxxYBfVgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVPdKzHXE=mV=FOx8xV4BLUEo_Ey9p6e9CkSOHxxYBfVgA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 08:38:21AM +0800, Ming Lei wrote:
> On Fri, Jul 27, 2012 at 3:43 AM, Don Zickus <dzickus@redhat.com> wrote:
> > On Wed, Jul 25, 2012 at 12:39:45PM +0800, Ming Lei wrote:
> >> Use raw_smp_processor_id in lockup_detector_bootcpu_resume()
> >> because it is enough when non-boot CPUs are offline.
> >>
> >> This patch fixes the following warning when DEBUG_PREEMPT
> >> is enabled.
> >
> > Is this patched on top of linux-next?
> 
> Yes.
> 
> The warning is introduced by the commit below:
> 
>       7fb860ff90ae970cf62cf676dfc1addcf8415674
>       (NMI watchdog: fix for lockup detector breakage on resume)

Ok, so I can respin this to give my SoB, if Andrew wants.  But at the same
time this patch will become obsolete (or broken) with tglx's hotplug
infrastructure changes.

Not sure what to do here.

Andrew?

Cheers,
Don
