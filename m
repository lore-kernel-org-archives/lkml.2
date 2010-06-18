Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194Ab0FRESP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 00:18:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757Ab0FRESN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 00:18:13 -0400
Date: Thu, 17 Jun 2010 21:17:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Brown <neilb@suse.de>
Cc: Sage Weil <sage@newdream.net>, Alexey Dobriyan <adobriyan@gmail.com>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, hch@lst.de,
       bfields@citi.umich.edu
Subject: Re: weird umem vs nfsd regression
Message-Id: <20100617211759.84eccaa3.akpm@linux-foundation.org>
In-Reply-To: <20100618125420.46fda9d6@notabene.brown>
References: <Pine.LNX.4.64.1006171305320.8387@cobra.newdream.net>
	<20100617134706.6c5ad7f1.akpm@linux-foundation.org>
	<20100618125420.46fda9d6@notabene.brown>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jun 2010 12:54:20 +1000 Neil Brown <neilb@suse.de> wrote:

> > There may also be bugs in the umem driver.  Even if the IO errors are
> > bogus, the kernel shouldn't hang up waiting for IO completion as it's
> > doing here.
> > 
> 
> No?  Even if it is due to faulty hardware?
> Do you think the driver should set a timer and disable the card if it hasn't
> heard back for a while?
> I guess that might be reasonable, though if it turns out to be faulty
> hardware I wouldn't trust it on the buss at all...

hm, yes, if a DMA controller goes haywire then adding a timeout
specifically to catch and recover from that one particular hardware
failure mode doesn't seem justified.

If we were going to do that then it should be done centrally at the
block layer with a timer-per-request, tunable on a max(all-end-devices)
basis.  blah.

As long as the softlockup detector or NMI watchdog or whatever gives a
useful trace pointing at the problem (as it does) then that's
sufficient.

