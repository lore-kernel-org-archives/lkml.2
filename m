Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab2DIOfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 10:35:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106Ab2DIOfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 10:35:30 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Chris Mason <chris.mason@oracle.com>, Shaohua Li <shli@fusionio.com>
Subject: Re: [RESEND][PATCH v2] block: remove plugging at buffered write time
References: <20120408010600.GA31377@localhost>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 09 Apr 2012 10:34:44 -0400
In-Reply-To: <20120408010600.GA31377@localhost> (Wu Fengguang's message of
	"Sun, 8 Apr 2012 09:06:00 +0800")
Message-ID: <x494nst7z3v.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang <fengguang.wu@intel.com> writes:

> Buffered write(2) is not directly tied to IO, so it's not suitable to
> handle plug in generic_file_aio_write().
[snip, moved]
> Note that plugging for O_SYNC writes is also removed. The user may pass
> arbitrary @size arguments, which may be much larger than the preferable
> I/O size, or may cross extent/device boundaries. Let the lower layers
> handle the plugging. Otherwise the plugging code here will turn the
> low level plugging into no-ops.

I assume you have some numbers to back this up, right?  Care to share
those?

> Also moves unplugging for direct I/O from around ->direct_IO() down to
> do_blockdev_direct_IO().

This could be handled in a separate patch.  Acked-by: Jeff Moyer
<jmoyer@redhat.com> for this part.

Cheers,
Jeff
