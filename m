Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467Ab2DKXNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:13:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761176Ab2DKXNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:13:46 -0400
Date: Wed, 11 Apr 2012 16:13:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Chris Mason <chris.mason@oracle.com>, Shaohua Li <shli@fusionio.com>
Subject: Re: [RESEND][PATCH v2] block: remove plugging at buffered write
 time
Message-Id: <20120411161344.309f12ef.akpm@linux-foundation.org>
In-Reply-To: <x494nst7z3v.fsf@segfault.boston.devel.redhat.com>
References: <20120408010600.GA31377@localhost>
	<x494nst7z3v.fsf@segfault.boston.devel.redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Apr 2012 10:34:44 -0400
Jeff Moyer <jmoyer@redhat.com> wrote:

> Wu Fengguang <fengguang.wu@intel.com> writes:
> 
> > Buffered write(2) is not directly tied to IO, so it's not suitable to
> > handle plug in generic_file_aio_write().
> [snip, moved]
> > Note that plugging for O_SYNC writes is also removed. The user may pass
> > arbitrary @size arguments, which may be much larger than the preferable
> > I/O size, or may cross extent/device boundaries. Let the lower layers
> > handle the plugging. Otherwise the plugging code here will turn the
> > low level plugging into no-ops.
> 
> I assume you have some numbers to back this up, right?  Care to share
> those?

Yes please.

We've broken this stuff a few times recently - we should review and
test carefully.

> > Also moves unplugging for direct I/O from around ->direct_IO() down to
> > do_blockdev_direct_IO().
> 
> This could be handled in a separate patch.

I think that would be better.
