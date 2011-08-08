Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab1HHSKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:10:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41941 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423Ab1HHSKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:10:16 -0400
Date: Mon, 8 Aug 2011 19:10:11 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: James Bottomley <JBottomley@Parallels.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
Message-ID: <20110808181011.GE29924@decadent.org.uk>
References: <20110806000251.682788533@clark.kroah.org>
 <1312739411.2591.1026.camel@deadeye>
 <1312739484.2591.1027.camel@deadeye>
 <20110808170424.GB27419@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110808170424.GB27419@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [28/55] [SCSI] fix crash in scsi_dispatch_cmd()
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 10:04:24AM -0700, Greg KH wrote:
> On Sun, Aug 07, 2011 at 06:51:24PM +0100, Ben Hutchings wrote:
> > On Sun, 2011-08-07 at 18:50 +0100, Ben Hutchings wrote:
> > > On Fri, 2011-08-05 at 17:01 -0700, Greg KH wrote:
> > > > 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > > 
> > > > commit bfe159a51203c15d23cb3158fffdc25ec4b4dda1 upstream.
> > > > 
> > > > USB surprise removal of sr is triggering an oops in
> > > > scsi_dispatch_command().  What seems to be happening is that USB is
> > > > hanging on to a queue reference until the last close of the upper
> > > > device, so the crash is caused by surprise remove of a mounted CD
> > > > followed by attempted unmount.
> > > [...]
> > > 
> > > This has been reported in 2.6.39.y and 3.0, but not in 2.6.32.y.
> > 
> > That is, AFAIK.
> 
> Oops, good catch, I've dropped this from the .32 and .33 queue now, it's
> not needed there at all.
 
Well, it is entirely possible that I am confusing multiple bugs (I
actualy attempted to delete this message from my outgoing mail queue
as I was becoming less confident about it).  I assume James can
confirm one way or the other.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
