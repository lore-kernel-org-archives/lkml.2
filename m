Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab1HHRFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 13:05:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59952 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab1HHRFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 13:05:38 -0400
Date: Mon, 8 Aug 2011 10:04:24 -0700
From: Greg KH <gregkh@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: James Bottomley <JBottomley@Parallels.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [28/55] [SCSI] fix crash in scsi_dispatch_cmd()
Message-ID: <20110808170424.GB27419@suse.de>
References: <20110806000251.682788533@clark.kroah.org>
 <1312739411.2591.1026.camel@deadeye>
 <1312739484.2591.1027.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312739484.2591.1027.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 07, 2011 at 06:51:24PM +0100, Ben Hutchings wrote:
> On Sun, 2011-08-07 at 18:50 +0100, Ben Hutchings wrote:
> > On Fri, 2011-08-05 at 17:01 -0700, Greg KH wrote:
> > > 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
> > > 
> > > ------------------
> > > 
> > > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > 
> > > commit bfe159a51203c15d23cb3158fffdc25ec4b4dda1 upstream.
> > > 
> > > USB surprise removal of sr is triggering an oops in
> > > scsi_dispatch_command().  What seems to be happening is that USB is
> > > hanging on to a queue reference until the last close of the upper
> > > device, so the crash is caused by surprise remove of a mounted CD
> > > followed by attempted unmount.
> > [...]
> > 
> > This has been reported in 2.6.39.y and 3.0, but not in 2.6.32.y.
> 
> That is, AFAIK.

Oops, good catch, I've dropped this from the .32 and .33 queue now, it's
not needed there at all.

greg k-h
