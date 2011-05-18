Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175Ab1ERNwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 09:52:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932837Ab1ERNwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 09:52:17 -0400
Date: Wed, 18 May 2011 09:51:32 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 4/4 v2] watchdog: configure nmi watchdog period based on
 watchdog_thresh
Message-ID: <20110518135132.GL29881@redhat.com>
References: <1305588901-8141-1-git-send-email-msb@chromium.org>
 <1305588901-8141-4-git-send-email-msb@chromium.org>
 <20110517071642.GF22305@elte.hu>
 <20110518034431.GC11023@google.com>
 <20110518083936.GF14805@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518083936.GF14805@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 10:39:36AM +0200, Ingo Molnar wrote:
> 
> * Mandeep Singh Baines <msb@chromium.org> wrote:
> 
> > Ingo Molnar (mingo@elte.hu) wrote:
> > > 
> > > * Mandeep Singh Baines <msb@chromium.org> wrote:
> > > 
> > > > Before the conversion of the NMI watchdog to perf event, the watchdog
> > > > timeout was 5 seconds. Now it is 60 seconds. For my particular application,
> > > > netbooks, 5 seconds was a better timeout. With a short timeout, we
> > > > catch faults earlier and are able to send back a panic. With a 60 second
> > > > timeout, the user is unlikely to wait and will instead hit the power
> > > > button, causing us to lose the panic info.
> > > 
> > > That's an interesting observation. Have you been able to measure/observe this 
> > > effect somehow, or do you presume that users find 60 seconds too long?
> > > 
> > 
> > Mostly intuition. There is a threshold beyond which the user will hit
> > the power button. Not sure if its 20 seconds or 20 minutes. My feeling
> > was that the 1 minute was too long.
> > 
> > For a user experience perspective, a quick reboot also seems like a better
> > experience than a one minute hang. Our systems boot in 8 seconds and restore
> > the previous session so a reboot is almost not noticable.
> 
> Indeed you definitely want it configurable and have the delay down to 5 or 10 
> seconds, to correlate it with your boot delay.
> 
> Personally i consider any hang over 1 second annoying so you might want to work 
> on that 8 seconds boot time some more, it's too long ;-)
> 
> And any kernel code running with more than 1 second irqs off is a bug, plain 
> and simple.

Not necessarily, but in those cases the code can use touch_nmi_watchdog
(for example slow hardware, long print outs, etc). :-)

Cheers,
Don
