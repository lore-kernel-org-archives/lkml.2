Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823Ab2JXXjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 19:39:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab2JXXjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 19:39:05 -0400
Date: Wed, 24 Oct 2012 16:39:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: MITSUNARI Shigeo <herumi@nifty.com>, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: fs: page cache wrongly left invalidated after revalidate_disk
Message-Id: <20121024163903.2a5bb819.akpm@linux-foundation.org>
In-Reply-To: <x491ugo6l3c.fsf@segfault.boston.devel.redhat.com>
References: <28086318.27561350944959337.herumi@nifty.com>
	<x491ugo6l3c.fsf@segfault.boston.devel.redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012 09:44:23 -0400
Jeff Moyer <jmoyer@redhat.com> wrote:

> MITSUNARI Shigeo <herumi@nifty.com> writes:
> 
> > Hi, 
> >
> > We found that bdev->bd_invalidated was left set once revalidate_disk() 
> > is called, which results in page cache flush every time that device 
> > is open. 
> >
> > Specifically, we found this problem in MD block device.  Once we 
> > resize a MD device, mdadm --monitor periodically flush all page cache 
> > for that device every 60 or 1000 seconds when it opens the device. 
> >
> > This bug lies since at least 3.2.0 till the latest kernel(3.6.2). 
> > Patch is attached. 
> >
> > Anyone please review this?  Thanks in advance.
> 
> rescan_partitions (called in the bdev open path) should reset
> bd_invalidated.  I think you need to dig into why that isn't happening.

I suspect it's because I_NEW is no longer set on the inode.

I queued this one for some viro attention ;)
