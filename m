Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab1GUJdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 05:33:36 -0400
Received: from ozlabs.org ([203.10.76.45]:37606 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab1GUJdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 05:33:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Avishay Traeger <avishay@il.ibm.com>, linux-kernel@vger.kernel.org,
        Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] virtio_blk: add block topology support
In-Reply-To: <CAB9v_DHEieOMYYLr90Yqw_SmMKGKZxdCeOtC0fs-eSuz6ooV+Q@mail.gmail.com>
References: <20100129190158.GA25122@lst.de> <201001301529.49848.rusty@rustcorp.com.au> <20100130201910.GA19811@lst.de> <201002011140.05761.rusty@rustcorp.com.au> <CAB9v_DHEieOMYYLr90Yqw_SmMKGKZxdCeOtC0fs-eSuz6ooV+Q@mail.gmail.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 21 Jul 2011 17:23:01 +0930
Message-ID: <8762mw2hpe.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jul 2011 03:36:42 +0400, Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
> On Mon, Feb 1, 2010 at 04:10, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > On Sun, 31 Jan 2010 06:49:10 am Christoph Hellwig wrote:
> >> On Sat, Jan 30, 2010 at 03:29:49PM +1030, Rusty Russell wrote:
> >> > I bow to your expertise on that.  My only query is the __u16 for min_io_size; is that likely to restrict us?
> >>
> >> Looks like you caught me there - I wrote the above odd format about the
> >> physical_block exponent, but scsi actually does the min_io and opt_io
> >> size in logical blocks, too.  With that in account the u16 as in scsi
> >> is perfectly fine.
> >
> > Thanks, applied.
> 
> Ugh, guys. I know it's already applied long ago, but this kind of
> contradicts the virtio specification, doesn't it?

Ugh indeed!  The same field is used by two places, as
VIRTIO_BLK_F_SECTOR_MAX never made it into the linux headers.

> VIRTIO_BLK_F_SECTOR_MAX (10) Maximum total sectors in
>    an I/O.

The patch made the spec, but as far as I can tell, no implementation.

If that's right, we just remove it from the spec.  If it did make it in,
we now have a very ugly case where the layout will have to vary
depending on what options are negotiated.

Once we've resolved this, I'll update the spec...

Thanks,
Rusty.
