Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab2JFSZn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 14:25:43 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:45867 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab2JFSZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 14:25:41 -0400
Message-ID: <1349547932.12699.49.camel@kjgkr>
Subject: Re: [PATCH 02/16] f2fs: add on-disk layout
From: Jaegeuk Kim <jaegeuk.kim@gmail.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org,
        =?euc-kr?Q?=B1=E8=C0=E7=B1=D8?= <jaegeuk.kim@samsung.com>,
        viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, chur.lee@samsung.com,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com
Date: Sun, 07 Oct 2012 03:25:32 +0900
In-Reply-To: <201210051946.21451.Martin@lichtvoll.de>
References: <000901cda2f0$7d773eb0$7865bc10$%kim@samsung.com>
	 (sfid-20121005_184512_086765_45BFD6B3) <201210051946.21451.Martin@lichtvoll.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-10-05 (금), 19:46 +0200, Martin Steigerwald:
> Am Freitag, 5. Oktober 2012 schrieb 김재극:
> > This adds a header file describing the on-disk layout of f2fs.
> > 
> > Signed-off-by: Changman Lee <cm224.lee@samsung.com>
> > Signed-off-by: Chul Lee <chur.lee@samsung.com>
> > Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > ---
> >  include/linux/f2fs_fs.h |  359 +++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 359 insertions(+)
> >  create mode 100644 include/linux/f2fs_fs.h
> > 
> > diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
> > new file mode 100644
> > index 0000000..b17eeec
> > --- /dev/null
> > +++ b/include/linux/f2fs_fs.h
> > @@ -0,0 +1,359 @@
> > +/**
> > + * include/linux/f2fs_fs.h
> […]
> > +/*
> > + * For superblock
> > + */
> > +struct f2fs_super_block {
> > +       __le32 magic;           /* Magic Number */
> > +       __le16 major_ver;       /* Major Version */
> > +       __le16 minor_ver;       /* Minor Version */
> > +       __le32 log_sectorsize;  /* log2 (Sector size in bytes) */
> > +       __le32 log_sectors_per_block;   /* log2 (Number of sectors per block */
> > +       __le32 log_blocksize;   /* log2 (Block size in bytes) */
> > +       __le32 log_blocks_per_seg; /* log2 (Number of blocks per segment) */
> > +       __le32 log_segs_per_sec; /* log2 (Number of segments per section) */
> > +       __le32 secs_per_zone; /* Number of sections per zone */
> > +       __le32 checksum_offset; /* Checksum position in this super block */
> > +       __le64 block_count;     /* Total number of blocks */
> > +       __le32 section_count;   /* Total number of sections */
> > +       __le32 segment_count;   /* Total number of segments */
> > +       __le32 segment_count_ckpt; /* Total number of segments
> > +                                     in Checkpoint area */
> > +       __le32 segment_count_sit; /* Total number of segments
> > +                                    in Segment information table */
> > +       __le32 segment_count_nat; /* Total number of segments
> > +                                    in Node address table */
> > +       /*Total number of segments in Segment summary area */
> > +       __le32 segment_count_ssa;
> > +       /* Total number of segments in Main area */
> > +       __le32 segment_count_main;
> > +       __le32 failure_safe_block_distance;
> > +       __le64 segment0_blkaddr;        /* Start block address of Segment 0 */
> > +       __le64 start_segment_checkpoint; /* Start block address of ckpt */
> > +       __le64 sit_blkaddr;     /* Start block address of SIT */
> > +       __le64 nat_blkaddr;     /* Start block address of NAT */
> > +       __le64 ssa_blkaddr;     /* Start block address of SSA */
> > +       __le64 main_blkaddr;    /* Start block address of Main area */
> > +       __le32 root_ino;        /* Root directory inode number */
> > +       __le32 node_ino;        /* node inode number */
> > +       __le32 meta_ino;        /* meta inode number */
> > +       __le32 volume_serial_number;    /* VSN is optional field */
> > +       __le16 volume_name[8];  /* Volume Name. 8 unicode characters */
> > +} __packed;
> 
> Any reason why volume label is that short?
> 

Noop.

> If superblock can occupy up to 4096 bytes, i.e. a block, I think a bit
> more space for volume label would fit in there. I count 128 bytes up
> to volume_name. Do other structures need to fit in superblock as well?
> 

I think it cannot be a problem to give more bytes to the name space.
I'll do this.

> I believe users easily can hit a limit of 8 unicode characters even for
> USB sticks and SD cards.

> Nice to see a flash friendly filesystem which seems to take lots of the
> stuff in account I read at Linaro website about flash devices.
> 

Thank you.

-- 
Jaegeuk Kim
Samsung

