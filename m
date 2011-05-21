Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab1EUVu2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 17:50:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:34584 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357Ab1EUVuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 17:50:25 -0400
Date: Sat, 21 May 2011 14:49:10 -0700
From: Greg KH <gregkh@suse.de>
To: Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: [15/24] tmpfs: fix spurious ENOSPC when racing with unswap
Message-ID: <20110521214910.GB5912@suse.de>
References: <20110519183127.122729561@clark.kroah.org>
 <alpine.LSU.2.00.1105201026430.9887@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1105201026430.9887@sister.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 10:49:59AM -0700, Hugh Dickins wrote:
> On Thu, 19 May 2011, Greg KH wrote:
> > 2.6.33-longterm review patch.  If anyone has any objections, please let us know.
> 
> We've got in a muddle on this one: too many tmpfs races and too many trees!

Yeah, it's messy :(

> So far, so good: indeed let's have the spurious ENOSPC fix in
> 33-longterm.
> 
> But here this 15/24 patch veers off into a quite different patch,
> for "tmpfs: fix race between umount and writepage" (46/71 in the
> 38-stable series).  I've appended the actual ENOSPC backport at the end.
> 
> Yes, let's have this writepage fix in 33-longterm too (the 38-stable
> patch should apply), but it does need "tmpfs: fix race between swapoff
> and writepage" (47/71 in the 38-stable series) on top to correct it,
> please add that in too.
> 
> For differing reasons, none of these races is as likely in 2.6.33
> as in 2.6.38, but good to include the fixes anyway; whereas 2.6.32
> gets more complicated for some of them, so I haven't bothered there.
> 
> (I think I'm reading the mails right, but of course made a fool of
> myself in the past, because of how gmail "rationalized" my view of
> them: I hope this won't be another such case.)

Ok, as this really isn't a big deal for .33, how about I just drop all
of the tmpfs patches for .33-longterm and we call it a day :)

It's easier that way for me by far.

If you think these really should all go to .33, can you send me the
individual patches so I know exactly what ones, and in what order, to
apply?

thanks,

greg k-h
