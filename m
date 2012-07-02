Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648Ab2GBUPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:15:46 -0400
Received: from swielinga.nl ([83.160.77.141]:58576 "EHLO swielinga.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940Ab2GBUPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:15:44 -0400
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Jul 2012 16:15:44 EDT
Date: Mon, 2 Jul 2012 22:08:21 +0200
From: Sytse Wielinga <sytse@swielinga.nl>
To: Richard Cochran <richardcochran@gmail.com>
Cc: John Stultz <johnstul@us.ibm.com>, Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] Potential fix for leapsecond caused futex related
 load spikes
Message-ID: <20120702200821.GA31197@swielinga.nl>
Mail-Followup-To: Richard Cochran <richardcochran@gmail.com>,
	John Stultz <johnstul@us.ibm.com>,
	Prarit Bhargava <prarit@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <4FF06CAB.9020800@redhat.com>
 <4FF08154.3050407@redhat.com>
 <4FF088B9.1000308@us.ibm.com>
 <20120702101606.GA16008@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120702101606.GA16008@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Mon, Jul 02, 2012 at 12:16:08PM +0200, Richard Cochran wrote:
> I know you didn't like my (originally Michael Hack's) idea of keeping
> time in TAI, but wouldn't changing to an internal, continuous time
> scale (not necessary TAI) solve these sorts of timer issues?

Doesn't that actually make the problem of leap seconds worse, as you'd have to
start tabulating past leap seconds in the kernel?

Even worse, *future* leap seconds would need to be tracked and after they've
happened stored on disk, and loaded back into the kernel after booting, which
seems like a mess.  The trouble here is that leap seconds are only announced a
short while before they happen, so there's no way to bake leap seconds into
the software; they need to be dynamically added by ntpd.

Or is there somehow some way to avoid that?

> There have been a number of clock/timer/leap bugs over the last
> years. Some of these might have been avoided by using a continuous
> scale, since no special timer actions would be needed during a leap
> second.
> 
> The run time cost is low, just one additional test and addition when
> reading the time. It might be worth it for the peace of mind when
> the next leap second rolls around.

I don't know if reworking the system that's been in place for ages is a good
way to give us 'peace of mind'.  Then again, I love to be enlightened :-)

Sytse Wielinga
