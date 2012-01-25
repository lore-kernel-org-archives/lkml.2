Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab2AYWjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 17:39:43 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34364 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751329Ab2AYWjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 17:39:41 -0500
X-Sasl-enc: F4Oh0qqRLCR4KArB3ytn/kb8JdJOD/UnrMJrhI4BakoW 1327531180
Date: Wed, 25 Jan 2012 14:39:37 -0800
From: Greg KH <greg@kroah.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <JBottomley@parallels.com>
Subject: Re: [v2] Re: [091/129] block: fail SCSI passthrough ioctls on
 partition devices
Message-ID: <20120125223937.GA12516@kroah.com>
References: <20120124023932.023409422@clark.kroah.org>
 <1327423431-13965-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327423431-13965-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 05:43:50PM +0100, Paolo Bonzini wrote:
> > You need to return -ENOTTY from scsi_verify_blk_ioctl and -ENOIOCTLCMD from
> > sd_compat_ioctl, because -ENOIOCTLCMD will not be handled correctly by
> > block/ioctl.c.  This would break BLKROSET and BLKFLSBUF done by non-root
> > but with the appropriate capabilities.
> >
> > Fixed patch follows.  If you prefer that I send an interdiff, let me know.

Wait, why do you want the stable trees to diverge from what is in
Linus's tree with regards to the error codes being returned?

That doesn't seem safe, or sane.

So for now, I'm going to follow what is in Linus's tree.  If you
need/want the error codes to be different, then shouldn't it also be
done there as well?

thanks,

greg k-h
