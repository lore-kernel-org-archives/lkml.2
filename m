Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab2JJFxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 01:53:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61947 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2JJFw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 01:52:58 -0400
X-AuditID: cbfee61b-b7f2b6d000000f14-90-50750d381c94
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'Stefan Hajnoczi'" <stefanha@gmail.com>
Cc: linux-kernel@vger.kernel.org
References: <000901cda2f0$7d773eb0$7865bc10$%kim@samsung.com>
 <20121007064222.GA436@stefanha-thinkpad>
In-reply-to: <20121007064222.GA436@stefanha-thinkpad>
Subject: RE: [PATCH 02/16] f2fs: add on-disk layout
Date: Wed, 10 Oct 2012 14:52:56 +0900
Message-id: <009901cda6ab$7f00a6e0$7d01f4a0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2kVu309gb6EOauTJmta56HKJQ1+wCUXHvQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jQV0L3tIAg0u7dC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGuw2bmAtmcVd0vhZtYNzN0cXIySEhYCJx7P4xJghbTOLCvfVs
	XYxcHEIC0xkllt5vZIRw5jNJvP2zmLWLkYODTUBbYvN+A5AGEQEtiQ+7GtlBbGYBBYlf9zax
	gthCAhkSa85cZwOxOQVMJdbdnAkWFxYwltjbcJQRxGYRUJWY9XICWC+vgK1E3/0mVghbUOLH
	5HssEDP1JD7+uc0IYctLbF7zlhnkBAkBdYlHf3UhTjCSOHvvJzNEiYjEvhfvGCcwCs1CMmkW
	kkmzkEyahaRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgIH4mvYNxVYPFIUYBDkYl
	Ht6KjJIAIdbEsuLK3EOMEhzMSiK8MiuBQrwpiZVVqUX58UWlOanFhxilOViUxHmbPVIChATS
	E0tSs1NTC1KLYLJMHJxSDYxiK9ZMW7VtA+vC3Bf9RgFnN4R2O5wz3Dn7zlRZI2OW/OeRWQkL
	XO2MNyvd4XY8aBOmWBNQ41fDU96/mb1lyVMDk0+LH4mkF++MfuoWHDI7jeGM4CMfp79z1nZv
	X6WWqlX4zVtj1n85hp317tV9XQqLwnf6/77okuFlZTgt48mSmSfX/fe0VldiKc5INNRiLipO
	BAD6Ulf9XgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]

> > +/*
> > + * For superblock
> > + */
> > +struct f2fs_super_block {
> > +	__le32 magic;		/* Magic Number */
> > +	__le16 major_ver;	/* Major Version */
> > +	__le16 minor_ver;	/* Minor Version */
> > +	__le32 log_sectorsize;	/* log2 (Sector size in bytes) */
> > +	__le32 log_sectors_per_block;	/* log2 (Number of sectors per block */
> > +	__le32 log_blocksize;	/* log2 (Block size in bytes) */
> 
> Why store log_blocksize on disk when it can be calculated from
> log_sectorsize and log_sectors_per_block?  It may be handy to keep this
> in the in-memory superblock but keeping it on-disk means you need a
> consistency check and error code path when loading the superblock.
> 

Yes, I added this for sanity check of superblock.

> > +struct f2fs_inode {
> > +	__le16 i_mode;			/* File mode */
> > +	__le16 i_reserved;		/* Reserved */
> > +	__le32 i_uid;			/* User ID */
> > +	__le32 i_gid;			/* Group ID */
> > +	__le32 i_links;			/* Links count */
> > +	__le64 i_size;			/* File size in bytes */
> > +	__le64 i_blocks;		/* File size in bytes */
> 
> File size in blocks
> 
> > +struct direct_node {
> > +	__le32 addr[ADDRS_PER_BLOCK];	/* aray of data block address */
> 
> s/aray/array/
> 
> > +} __packed;
> > +
> > +struct indirect_node {
> > +	__le32 nid[NIDS_PER_BLOCK];	/* aray of data block address */
> 
> s/aray/array/

I'll change them.
Thank you.
> 
> Stefan

