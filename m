Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab2AYXCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 18:02:19 -0500
Received: from blackhole.sdinet.de ([176.9.52.58]:60847 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab2AYXCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 18:02:14 -0500
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jan 2012 18:02:14 EST
Date: Wed, 25 Jan 2012 23:51:40 +0100 (CET)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: Greg KH <greg@kroah.com>
cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        James Bottomley <JBottomley@parallels.com>
Subject: Re: [v2] Re: [091/129] block: fail SCSI passthrough ioctls on
 partition devices
In-Reply-To: <20120125223937.GA12516@kroah.com>
Message-ID: <alpine.DEB.2.02.1201252348520.22090@aurora.sdinet.de>
References: <20120124023932.023409422@clark.kroah.org> <1327423431-13965-1-git-send-email-pbonzini@redhat.com> <20120125223937.GA12516@kroah.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jan 2012, Greg KH wrote:

> On Tue, Jan 24, 2012 at 05:43:50PM +0100, Paolo Bonzini wrote:
> > > You need to return -ENOTTY from scsi_verify_blk_ioctl and -ENOIOCTLCMD from
> > > sd_compat_ioctl, because -ENOIOCTLCMD will not be handled correctly by
> > > block/ioctl.c.  This would break BLKROSET and BLKFLSBUF done by non-root
> > > but with the appropriate capabilities.
> > >
> > > Fixed patch follows.  If you prefer that I send an interdiff, let me know.
> 
> Wait, why do you want the stable trees to diverge from what is in
> Linus's tree with regards to the error codes being returned?
> 
> That doesn't seem safe, or sane.
> 
> So for now, I'm going to follow what is in Linus's tree.  If you
> need/want the error codes to be different, then shouldn't it also be
> done there as well?

May be because the stable trees do not have
07d106d0a33d6063d2061305903deb02489eba20? "vfs: fix up ENOIOCTLCMD error 
handling"?

c'ya
sven-haegar

-- 
Three may keep a secret, if two of them are dead.
- Ben F.
