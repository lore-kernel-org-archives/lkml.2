Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab1GNXgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 19:36:45 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:65142 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590Ab1GNXgo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 19:36:44 -0400
MIME-Version: 1.0
In-Reply-To: <201002011140.05761.rusty@rustcorp.com.au>
References: <20100129190158.GA25122@lst.de>
	<201001301529.49848.rusty@rustcorp.com.au>
	<20100130201910.GA19811@lst.de>
	<201002011140.05761.rusty@rustcorp.com.au>
Date: Fri, 15 Jul 2011 03:36:42 +0400
Message-ID: <CAB9v_DHEieOMYYLr90Yqw_SmMKGKZxdCeOtC0fs-eSuz6ooV+Q@mail.gmail.com>
Subject: Re: [PATCH] virtio_blk: add block topology support
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@lst.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 1, 2010 at 04:10, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Sun, 31 Jan 2010 06:49:10 am Christoph Hellwig wrote:
>> On Sat, Jan 30, 2010 at 03:29:49PM +1030, Rusty Russell wrote:
>> > I bow to your expertise on that.  My only query is the __u16 for min_io_size; is that likely to restrict us?
>>
>> Looks like you caught me there - I wrote the above odd format about the
>> physical_block exponent, but scsi actually does the min_io and opt_io
>> size in logical blocks, too.  With that in account the u16 as in scsi
>> is perfectly fine.
>
> Thanks, applied.

Ugh, guys. I know it's already applied long ago, but this kind of
contradicts the virtio specification, doesn't it?


VIRTIO_BLK_F_SECTOR_MAX (10) Maximum total sectors in
   an I/O.
[...]

4. If the VIRTIO_BLK_F_SECTOR_MAX feature is negotiated, the sec-
   tors_max eld should be read to determine the maximum I/O size for
   the driver to use. No requests should be submitted which go beyond this
   limit.

struct virtio_blk_config        {
        u64  capacity ;
        u32  si z e_ m ax ;
        u32  seg_max ;
        struct     virtio_blk_geometry {
                    u16   cylinders ;
                    u8  heads ;
                    u8  sectors ;
        } geometry ;
        u32  blk_size ;
        u32  sectors_max ;
};
