Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab2AZXBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 18:01:32 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51197 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab2AZXBb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 18:01:31 -0500
MIME-Version: 1.0
In-Reply-To: <20120126223037.GE28368@quack.suse.cz>
References: <20120126223037.GE28368@quack.suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 26 Jan 2012 15:01:10 -0800
X-Google-Sender-Auth: hWsf4xbXN4IaW4Kt-S3r_dsdXUk
Message-ID: <CA+55aFwkRhsdAYwP-S5_qPkRX=dMSnxv5Ow1ULaSJjKe3aTy2w@mail.gmail.com>
Subject: Re: Ioctl warning for a partition
To: Jan Kara <jack@suse.cz>
Cc: Paolo Bonzini <pbonzini@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        James Bottomley <JBottomley@parallels.com>, mmarek@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 2:30 PM, Jan Kara <jack@suse.cz> wrote:
>
> It's easy enough to silence the warning the same way as
> CDROM_GET_CAPABILITY since the ioctl is safe but it's not so simple for
> 32-bit userspace.  MTIOCGET32 is defined only in fs/compat_ioctl.c so we
> cannot easily add it to scsi_verify_blk_ioctl(). Any opinion how to cleanly
> solve this? The only idea I had was to define compat structures and ioctl
> numbers in a special header and use it both in fs/compat_ioctl.c and in
> block/scsi_ioctl.c.

I suspect we can just remove the warning entirely - once we've gotten
enough coverage with the -rc kernels that people (me in particular)
are happy that no normal load really needs it, and returning an error
is fine.

So I don't really consider the warning to be something long-term - I
wanted it to make sure that some random binary in some odd
distribution wouldn't break in mysterious ways that would take a lot
of debugging to find. And so that we really know what we end up
blocking in practice.

I'm not sure how good the -rc kernel coverage is, but I think it's
good enough that we can drop the warning before doing a real 3.3
release. And I don't think the stable kernel versions ever got that
warning printout, did they? That would be great for coverage, of
course, if they did.

                      Linus
