Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab2D1QY3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 12:24:29 -0400
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:32911 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab2D1QY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 12:24:28 -0400
X-Greylist: delayed 1309 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Apr 2012 12:24:27 EDT
Date: Sat, 28 Apr 2012 12:02:27 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: Burning multiple DVDs at one time
Message-ID: <20120428160226.GA9811@animx.eu.org>
Mail-Followup-To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20120315225310.GB3152@animx.eu.org>
 <20120317095644.145d0588@stein>
 <20120317142255.GB26403@animx.eu.org>
 <20120317162853.13afa28b@stein>
 <20120318133059.GB10172@animx.eu.org>
 <20120318150127.5f8db40c@stein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120318150127.5f8db40c@stein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> On Mar 18 Wakko Warner wrote:
> > Stefan Richter wrote:
> > > On Mar 17 Wakko Warner wrote:
> > > > Thanks.  I looked at the patch.  I would just like to confirm that I can
> > > > patch my 3.0.0 vanilla kernel, compile the sr module, unload the current and
> > > > load the patched one without the need to reboot.
> > > 
> > > Yes, this should be possible.
> > > 
> > > Oh, I only noticed just know that you also wrote:
> > > 
> > > > > > The kernel is a vanilla kernel v3.0.0.  (This also happened with 2.6.35)
> > > 
> > > In 2.6.35, the Big Kernel Lock was still in place there.  That lock
> > > behaved differently from a plain mutex --- notably it was released when a
> > > thread went to sleep --- so maybe there is more to your problem than just
> > > sr_mutex blocking unrelated sr accesses.
> > 
> > There is a good possibility that I was mistaken on the 2.6.35.
> > 
> > I manually applied your patch to 3.0.0, compiled, removed sr-mod module and
> > inserted the newly compiled one.
> > 
> > With the vanilla one, I would see the buf % in wodim drop while the fifo was
> > full.  With the patch (removing the mutex), buf stayed above 98% and the
> > burn speed was 16x at the end (10x avg).
> > 
> > Seems to have fixed my problem.
> 
> Very nice; so there is an almost easy fix.  Now I or somebody else need to
> work out the required cdrom_device_info protection on which Arnd and James
> commented.

Has anything come of this as far as the fix going into the kernel?

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
