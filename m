Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab2BGKVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 05:21:24 -0500
Received: from 1wt.eu ([62.212.114.60]:62284 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab2BGKVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 05:21:23 -0500
Date: Tue, 7 Feb 2012 11:21:04 +0100
From: Willy Tarreau <w@1wt.eu>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        James Bottomley <JBottomley@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 90/91] block: fail SCSI passthrough ioctls on partition devices
Message-ID: <20120207102104.GA27069@1wt.eu>
References: <0635750f5f06ed2ca212b91fcb5c4483@local> <20120205220953.312427771@pcw.home.local> <4F2F0669.3000601@redhat.com> <20120205225314.GF8334@1wt.eu> <4F30F6D7.8080401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F30F6D7.8080401@redhat.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo,

On Tue, Feb 07, 2012 at 11:03:03AM +0100, Paolo Bonzini wrote:
> On 02/05/2012 11:53 PM, Willy Tarreau wrote:
> >Thanks for this report, I missed this patch. I thought the reason for the 
> >lack
> >of scsi_cmd_blk_ioctl() it was one of the differences between 2.6.27 and 
> >2.6.32,
> >so I have adapted the callers I identified to perform the same test as 
> >what's
> >in scsi_cmd_blk_ioctl().
> 
> There were other callers in patch 1/3, most notably virtio-blk, that are 
> not in your patch.

Yes it was, just like ub, sd and ide-floppy. In fact backport this whole patch
was the trickiest task as I had to review each caller one after the other, and
I'm quite confident the result is fine. But I prefer to redo it from scratch
with your original patch that I missed, as it will wipe any doubts and make
further maintenance easier.

Thanks,
Willy

