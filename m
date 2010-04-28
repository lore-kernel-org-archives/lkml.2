Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416Ab0D1XKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 19:10:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17494 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246Ab0D1XKI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 19:10:08 -0400
Subject: Re: Cleancache [PATCH 6/7] (was Transcendent Memory): ext4 hook
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@sun.com>
In-Reply-To: <20100422132929.GA27380@ca-server1.us.oracle.com>
Date: Wed, 28 Apr 2010 17:08:54 -0600
Cc: Chris Mason <chris.mason@oracle.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>, mfasheh@suse.com,
       Joel Becker <joel.becker@oracle.com>, Matthew Wilcox <matthew@wil.cx>,
       linux-btrfs@vger.kernel.org,
       "linux-kernel@vger.kernel.org Mailinglist" 
	<linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       linux-ext4 development <linux-ext4@vger.kernel.org>,
       ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, ngupta@vflare.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, JBeulich@novell.com,
       kurt.hackel@oracle.com, Nick Piggin <npiggin@suse.de>,
       dave.mccracken@oracle.com, Rik van Riel <riel@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <8EEE8A6D-343A-4514-BFC8-1EFEDE180B70@sun.com>
References: <20100422132929.GA27380@ca-server1.us.oracle.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
X-Mailer: Apple Mail (2.1078)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090207.4BD8C035.00B9,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-04-22, at 07:29, Dan Magenheimer wrote:
> Cleancache [PATCH 6/7] (was Transcendent Memory): ext4 hook
> 
> Filesystems must explicitly enable cleancache.  For ext4,
> all other cleancache hooks are in the VFS layer.
> 
> Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

Given the minimal changes being done to ext3/ext4, I don't have any objection to this.  Being able to hook ext4 into SSDs for hierarchical caching is something that will become increasingly important for huge ext4 filesystems.

Acked-by: Andreas Dilger <adilger@sun.com>

> Diffstat:
> super.c                                  |    2 ++
> 1 file changed, 2 insertions(+)
> 
> --- linux-2.6.34-rc5/fs/ext4/super.c	2010-04-19 17:29:56.000000000 -0600
> +++ linux-2.6.34-rc5-cleancache/fs/ext4/super.c	2010-04-21 10:13:00.000000000 -0600
> @@ -39,6 +39,7 @@
>  #include <linux/ctype.h>
>  #include <linux/log2.h>
>  #include <linux/crc16.h>
> +#include <linux/cleancache.h>
>  #include <asm/uaccess.h>
>  
>  #include "ext4.h"
> @@ -1784,6 +1785,7 @@ static int ext4_setup_super(struct super
>  			EXT4_INODES_PER_GROUP(sb),
>  			sbi->s_mount_opt);
> 
> +	sb->cleancache_poolid = cleancache_init_fs(PAGE_SIZE);
>  	return res;
>  }


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

