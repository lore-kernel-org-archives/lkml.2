Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab0ECRKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 13:10:25 -0400
Received: from tex.lwn.net ([70.33.254.29]:41750 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099Ab0ECRKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 13:10:24 -0400
Date: Mon, 3 May 2010 11:10:20 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: mgross@linux.intel.com, aili@codeaurora.org, dwalker@codeaurora.org,
       tiwai@suse.de, bruce.w.allan@intel.com, davidb@quicinc.com,
       mcgrof@gmail.com, pavel@ucw.cz,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]PM QOS refresh against next-20100430
Message-ID: <20100503111020.2dab8003@bike.lwn.net>
In-Reply-To: <87tyqo537l.fsf@deeprootsystems.com>
References: <20100430212043.GA30315@linux.intel.com>
	<20100503103300.6330e522@bike.lwn.net>
	<87y6g1547o.fsf@deeprootsystems.com>
	<20100503104250.7605d2bc@bike.lwn.net>
	<87tyqo537l.fsf@deeprootsystems.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 May 2010 10:01:50 -0700
Kevin Hilman <khilman@deeprootsystems.com> wrote:

> > Well, shallow could mean that the state lacks the CPUIDLE_FLAG_DEEP
> > flag; that should be relatively portable.  In any case, it seems
> > more so than "if I put in a 55us latency requirement, I'll stay out
> > of C3".  
> 
> I guess it depends on your goal.  Do you just want to stay out of C3
> on your current platform?  or do you want to stay out of any low-power
> state (on any platform) where you'll have a latency of > 55 usecs?

My case is a camera driver; as long as latencies are on the scale of
the frame rate, things won't go too wrong.  1ms latencies would not be
a huge problem.  What happens is that the hardware corrupts the data if
it goes into C3 while video capture is happening.

Comments in drivers/net/e1000e/netdev.c suggest that they were dealing
with similar issues.

> The former is not portable (as C-states don't have the same meanings
> across arches/SoCs) where as using a real-world number in usecs will
> have meaning on any platform.

Understood.  But the end result is that I've ended up specifying a
latency requirement that is far tighter than the situation really needs
in order to achieve the real goal.

> My main concern is that drivers not be written with latency
> constraints that assume an Intel-centric set of power states.  There
> are other SoCs out there with different sets of states and
> corresponding latencies, so keeping things in real-world numbers
> (latency, throughput, etc.) seems to me to be the only portable way.

Understood.  Perhaps the pm_qos interface isn't the best way to achieve
the real goal here, but it's all we have at the moment.

Thanks,

jon
