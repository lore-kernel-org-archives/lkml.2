Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab2GWIjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 04:39:08 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13423 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab2GWIjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 04:39:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 23 Jul 2012 01:33:59 -0700
Date: Mon, 23 Jul 2012 11:38:18 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCHSET] workqueue: reimplement CPU hotplug to keep idle
 workers
Message-ID: <20120723083818.GA12034@tbergstrom-lnx.Nvidia.com>
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
 <1342808550.2583.48.camel@twins>
 <20120720183400.GL32763@google.com>
 <201207202144.05154.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201207202144.05154.rjw@sisk.pl>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 09:44:04PM +0200, Rafael J. Wysocki wrote:
> On Friday, July 20, 2012, Tejun Heo wrote:
> > Hello,
> > 
> > On Fri, Jul 20, 2012 at 08:22:30PM +0200, Peter Zijlstra wrote:
> > > I really think people who use hotplug at high frequencies are on drugs
> > > and doing it wrong.
> > 
> > I don't know.  It does make some sense.  It's not like we have any
> > other mechanism to keep some processors completely quiesient, which
> > could make a noticeable difference from powersaving POV compared to
> > mostly idle.  Rafael, can you please chime in and explain how / where
> > / how freqeuntly / etc CPU hotplug is used for powersaving?
> 
> Well, there are use cases I'm not really familiar with.
> 
> Pretty much the only use case I'm sufficiently familiar with is
> suspend/hibernate where we unplug all of the nonboot CPUs at one point.
> 
> The other use cases, which I don't really think are entirely valid,
> are on some ARM platforms where CPUs are unplugged instead of being put into
> C-states or equivalent (because we don't have a good mechanism for handling
> multiprocessor C-states; there's a set of patches for that waiting for
> the merge window in the Len's tree).  I'm hoping to get rid of those
> use cases in future entirely.

I don't see how we can get rid of hotplug (or some other state where
some processors are completely quiesient) in systems which have CPU clusters
with a different number of CPUs in each cluster. (eg 4 and 1 in case of
Tegra30).

Cheers,

Peter.
