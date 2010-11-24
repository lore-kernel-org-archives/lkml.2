Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab0KXIaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:30:16 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34698 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab0KXIaO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:30:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nLyp9IHSq7o0TlZ1n4fCPbWkJ+LPVowFz7C9VaDcOqJ5xtHkcv2J6yX7gJtjWa1dXQ
         HFA83zBUbeox2PQuW5zRxXBPO4bFUhnxI/xST8lhtouc/vaTBigRViNrOrWIwFoXgIN0
         mU61SMBUTJi4zJFau7/YW96GBmQyzH0qRpEBE=
MIME-Version: 1.0
In-Reply-To: <20101124081755.GD2212@linux-sh.org>
References: <4CE79C4D.6000104@gmail.com>
	<20101124081755.GD2212@linux-sh.org>
Date: Wed, 24 Nov 2010 09:30:13 +0100
Message-ID: <AANLkTinsnEd-QMcjRCaj-crKzOrj2oZe3C4RA2i5KqCP@mail.gmail.com>
Subject: Re: [PATCH 09/16 v4] pramfs: dir operations
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tim Bird <tim.bird@am.sony.com>, Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/24 Paul Mundt <lethal@linux-sh.org>:
> On Sat, Nov 20, 2010 at 11:00:45AM +0100, Marco Stornelli wrote:
>> +int pram_add_link(struct dentry *dentry, struct inode *inode)
>> +{
>> +     struct inode *dir = dentry->d_parent->d_inode;
>> +     struct pram_inode *pidir, *pi, *pitail = NULL;
>> +     u64 tail_ino, prev_ino;
>> +
>> +     const char *name = dentry->d_name.name;
>> +
>> +     int namelen = dentry->d_name.len > PRAM_NAME_LEN ?
>> +             PRAM_NAME_LEN : dentry->d_name.len;
>> +
>
>        namelen = min_t(unsigned int, dentry->d_name.len, PRAM_NAME_LEN);
>
> ?

Ok, I can use it, I have to check the type.

>
>> +#define S_SHIFT 12
>> +static unsigned int dtype_by_mode[S_IFMT >> S_SHIFT] = {
>> +     [S_IFREG >> S_SHIFT]    DT_REG,
>> +     [S_IFDIR >> S_SHIFT]    DT_DIR,
>> +     [S_IFCHR >> S_SHIFT]    DT_CHR,
>> +     [S_IFBLK >> S_SHIFT]    DT_BLK,
>> +     [S_IFIFO >> S_SHIFT]    DT_FIFO,
>> +     [S_IFSOCK >> S_SHIFT]   DT_SOCK,
>> +     [S_IFLNK >> S_SHIFT]    DT_LNK,
>> +};
>> +
>> +static int pram_readdir(struct file *filp, void *dirent, filldir_t filldir)
>> +{
> ...
>> +             ret = filldir(dirent, name, namelen,
>> +                           filp->f_pos, ino,
>> +                           dtype_by_mode[(be16_to_cpu(pi->i_mode) & S_IFMT)>>S_SHIFT]);
>> +             filp->f_pos = pi->i_d.d_next ? be64_to_cpu(pi->i_d.d_next) : 3;
>
> You might try to provide some generic helpers for this, at least GFS2
> also does the same thing:
>
> include/linux/gfs2_ondisk.h:#define DT2IF(dt) (((dt) << 12) & S_IFMT)
> include/linux/gfs2_ondisk.h:#define IF2DT(sif) (((sif) & S_IFMT) >> 12)
>

I'll look at it.

Marco
