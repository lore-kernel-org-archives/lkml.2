Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab2AZATi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 19:19:38 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45938 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752253Ab2AZATg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 19:19:36 -0500
X-Sasl-enc: ezSE4U/D1EWlsVhpY13SNAKtLUNyVjushgKAuY3DbbLd 1327537175
Date: Wed, 25 Jan 2012 16:19:26 -0800
From: Greg KH <greg@kroah.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Petr Matousek <pmatouse@redhat.com>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        James Bottomley <JBottomley@parallels.com>
Subject: Re: [PATCH stable 3/4] block: fail SCSI passthrough ioctls on
 partition devices
Message-ID: <20120126001926.GA1058@kroah.com>
References: <1326772723.2819.167.camel@deadeye>
 <1326773222.2819.172.camel@deadeye>
 <4F1545A4.3000809@redhat.com>
 <1326862077.2819.210.camel@deadeye>
 <4F168A49.8000606@redhat.com>
 <1326902676.3271.10.camel@deadeye>
 <4F1EAA6A.6020207@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F1EAA6A.6020207@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 01:56:10PM +0100, Paolo Bonzini wrote:
> On 01/18/2012 05:04 PM, Ben Hutchings wrote:
> >>  There is harm.  You'll be blacklisting also the standard block device
> >>  ioctls, and those won't work on 32-on-64 anymore.  A system with 32-bit
> >>  userland will likely not boot anymore.
> >
> >It does (yes, I tested that myself now).  The standard block device
> >ioctls are handled without calling the driver's compat_ioctl.
> 
> What about the non-compat path when done by non-root?
> 
> * Does BLKROSET still return EACCES when run by non-root and without
> CAP_SYS_ADMIN?  I suspect your patch is changing it to EINVAL.
> 
> * Does BLKFLSBUF work when run by non-root but with CAP_SYS_ADMIN?

I'm confused here as well.

Can someone please send me the proper patch that I need to apply to
resolve this issue on the 2.6.32.y kernel?

thanks,

greg k-h
