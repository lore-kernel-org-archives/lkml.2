Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab2JGGmb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 02:42:31 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42374 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab2JGGma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 02:42:30 -0400
Date: Sun, 7 Oct 2012 08:42:22 +0200
From: Stefan Hajnoczi <stefanha@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/16] f2fs: add on-disk layout
Message-ID: <20121007064222.GA436@stefanha-thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000901cda2f0$7d773eb0$7865bc10$%kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*
> + * For superblock
> + */
> +struct f2fs_super_block {
> +	__le32 magic;		/* Magic Number */
> +	__le16 major_ver;	/* Major Version */
> +	__le16 minor_ver;	/* Minor Version */
> +	__le32 log_sectorsize;	/* log2 (Sector size in bytes) */
> +	__le32 log_sectors_per_block;	/* log2 (Number of sectors per block */
> +	__le32 log_blocksize;	/* log2 (Block size in bytes) */

Why store log_blocksize on disk when it can be calculated from
log_sectorsize and log_sectors_per_block?  It may be handy to keep this
in the in-memory superblock but keeping it on-disk means you need a
consistency check and error code path when loading the superblock.

> +struct f2fs_inode {
> +	__le16 i_mode;			/* File mode */
> +	__le16 i_reserved;		/* Reserved */
> +	__le32 i_uid;			/* User ID */
> +	__le32 i_gid;			/* Group ID */
> +	__le32 i_links;			/* Links count */
> +	__le64 i_size;			/* File size in bytes */
> +	__le64 i_blocks;		/* File size in bytes */

File size in blocks 

> +struct direct_node {
> +	__le32 addr[ADDRS_PER_BLOCK];	/* aray of data block address */

s/aray/array/

> +} __packed;
> +
> +struct indirect_node {
> +	__le32 nid[NIDS_PER_BLOCK];	/* aray of data block address */

s/aray/array/

Stefan
