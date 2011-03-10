Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab1CJTE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 14:04:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33608 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab1CJTE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 14:04:26 -0500
Date: Thu, 10 Mar 2011 11:02:27 -0800
From: Greg KH <gregkh@suse.de>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] sysfs: add more info to the oops dump
Message-ID: <20110310190227.GA28086@suse.de>
References: <1299772388-15439-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <20110310162501.GB23989@suse.de>
 <20110310183239.GF7975@esdhcp04044.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110310183239.GF7975@esdhcp04044.research.nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 08:32:40PM +0200, Phil Carmody wrote:
> On 10/03/11 08:25 -0800, ext Greg KH wrote:
> > On Thu, Mar 10, 2011 at 05:53:08PM +0200, Phil Carmody wrote:
> > > If we're going to remember which file we accessed, we might as well
> > > also remember whether it was a read or a write, and if the latter,
> > > some indication of what was written.
> > > 
> > > e.g.
> > > $ echo 1 > /sys/kernel/slab/:at-0000064/sanity_checks
> > > $ echo c > /proc/sysrq-trigger
> > > ...
> > > [  112.457580] last sysfs file (w): /sys/kernel/slab/:at-0000064/sanity_checks
> > > [  112.464569]   written: 1
> > 
> > Has this actually helped you out?  I've been thinking of removing this
> > line in the dmesg entirely as I haven't seen it help in a very long time
> > to track anything down.
> 
> I'm glad I started my commit message with that 'if', that tells you
> something. I have considered it, in its original form, not particularly
> helpful too. But I blamed that on it not telling me enough. Today I saw
> an oops related to a sysfs write, and this just patch basically wrote
> itself instantly. But it's not stood the test of time, that's for sure.

But would the trace-back also have shown you the problem?  If not, then
that's a good reason to keep this feature, and to add your patch.

But, I would suggest keeping it on one line, adding more lines to oops
messages is not good if at all possible.

thanks,

greg k-h
