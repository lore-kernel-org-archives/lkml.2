Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab1HHSHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:07:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41913 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361Ab1HHSHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:07:41 -0400
Date: Mon, 8 Aug 2011 19:07:35 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Message-ID: <20110808180735.GD29924@decadent.org.uk>
References: <20110806000249.573906795@clark.kroah.org>
 <1312738681.2591.1024.camel@deadeye>
 <20110808170300.GA27419@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110808170300.GA27419@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [07/55] SUNRPC: Fix a race between work-queue
 and rpc_killall_tasks
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 10:03:00AM -0700, Greg KH wrote:
> On Sun, Aug 07, 2011 at 06:38:01PM +0100, Ben Hutchings wrote:
> > On Fri, 2011-08-05 at 17:01 -0700, Greg KH wrote:
> > > 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
> > > 
> > > ------------------
> > > 
> > > From: Trond Myklebust <Trond.Myklebust@netapp.com>
> > > 
> > > commit b55c59892e1f3b6c7d4b9ccffb4263e1486fb990 upstream.
> > > 
> > > Since rpc_killall_tasks may modify the rpc_task's tk_action field
> > > without any locking, we need to be careful when dereferencing it.
> > [...]
> > 
> > This isn't nearly careful enough to avoid races.  You must at least use
> > the ACCESS_ONCE macro, otherwise the compiler can just optimise away the
> > local variable this introduces.
> 
> Well, that's an upstream issue as well, right?  Not much I can do here
> in the stable updates :)
 
Right, but if it doesn't fix a bug then it is not suitable for
stable.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
