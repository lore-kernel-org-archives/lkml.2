Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab1D3Pqe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 11:46:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:53779 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab1D3Pq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 11:46:29 -0400
Date: Sat, 30 Apr 2011 08:47:33 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Allow setting of number of raw devices as a module parameter
Message-ID: <20110430154733.GA21893@suse.de>
References: <1304029469-19672-1-git-send-email-jack@suse.cz>
 <20110429162817.2eb26efb.akpm@linux-foundation.org>
 <20110430112937.06024368@lxorguk.ukuu.org.uk>
 <20110430153452.GA21439@suse.de>
 <20110430164141.55d0ef0a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110430164141.55d0ef0a@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 30, 2011 at 04:41:41PM +0100, Alan Cox wrote:
> > > A large vmalloc array is very antisocial on a 32bit x86 box. It looks
> > > like almost all of it would become sane if there was an array of pointers
> > > to raw devices and the devices were initially allocated on need (even if
> > > for now only recovered on rmmod)
> > 
> > In practice, we've never seen a problem with this[1].  Machines that
> > want thousands of raw devices have plenty of memory to handle this
> > situation.
> > 
> > I doubt adding the complexity of dynamically allocating the devices
> > as-needed is worth it for the very few systems that ever use this
> > driver, compounded with the fact that we keep saying that this code
> > isn't to be used by "normal" people anyway.
> 
> That's no excuse for sloppy code. Making it an array populated on demand
> is an improvement for everyone, making it vmalloc hurts every access (in
> TLB misses for one as well as vmalloc overhead).
> 
> I note two of us immediately made the same observation. Doing it
> basically right (array of pointers) is easy. Doing the full works with a
> hash for the lookups is a bit harder and that I would agree is overkill.

Ah, ok, I was thinking of the latter, I'll work on implementing the
former next week, unless Jan wants to do it instead?

thanks for the review,

greg k-h
