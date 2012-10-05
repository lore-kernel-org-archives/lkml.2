Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab2JEQGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:06:35 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:32776 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151Ab2JEQGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:06:34 -0400
Date: Fri, 5 Oct 2012 09:06:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Borislav Petkov <bp@amd64.org>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Fix bogus "callbacks suppressed" messages
Message-ID: <20121005160630.GA15269@kroah.com>
References: <20121004124025.GC21028@aftab.osrc.amd.com>
 <20121004131101.GA245@x4>
 <506EC1AE.6000201@suse.cz>
 <20121005122741.GB8019@aftab.osrc.amd.com>
 <20121005125717.GB245@x4>
 <20121005142639.GA20065@kroah.com>
 <20121005152948.GC24764@aftab.osrc.amd.com>
 <20121005153706.GA13571@kroah.com>
 <20121005154312.GF24764@aftab.osrc.amd.com>
 <20121005154847.GB246@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121005154847.GB246@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 05:48:47PM +0200, Markus Trippelsdorf wrote:
> On 2012.10.05 at 17:43 +0200, Borislav Petkov wrote:
> > On Fri, Oct 05, 2012 at 08:37:06AM -0700, Greg Kroah-Hartman wrote:
> > > So WARN_RATELIMIT was never working properly? If so, how far back does
> > > it go in kernel releases that this should be fixed?
> > 
> > Since b3eec79b0776e which added it in May 2011. But the only one othe r
> > user is net/core/filter.c.
> 
> But it doesn't matter, because the WARN_RATELIMIT in net/core/filter.c
> is guarded by a switch statement and uses WARN_RATELIMIT(1,...). So it
> could never trigger the bug.

Ok, thanks for digging that all up, I'll just merge this in for 3.7.

greg k-h
