Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab0GMBIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 21:08:54 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58443 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab0GMBIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 21:08:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HvH184l8vAqPa1OvNtryeLaER1pBRXS0M/v2i7ISTXrzUhuDpYsBrV3nonLxbfXKgu
         Xrpw5jXjHhtPCRw2sYo+Lupg7GTn14ep0jkltuDhhoaCJielNE3hSV0lBHP4c0P1HeQl
         KWCBmeACOGlk1KofvE4+y2LmwugkmH8qNIFgk=
MIME-Version: 1.0
In-Reply-To: <3BB069D5-B193-43A4-B678-B3CEA4873B58@dilger.ca>
References: <871vbax86w.fsf@patl.com>
	<87zkxyvtjt.fsf@patl.com>
	<3BB069D5-B193-43A4-B678-B3CEA4873B58@dilger.ca>
Date: Mon, 12 Jul 2010 18:08:51 -0700
Message-ID: <AANLkTikAEycm5PKTLPuRFcB0e4qNp5EuQbKUx5aruNrh@mail.gmail.com>
Subject: Re: [PATCH 2/2] OCFS2: Allow huge (> 16 TiB) volumes to mount
From: "Patrick J. LoPresti" <lopresti@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 5:21 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> On 2010-07-11, at 11:04, Patrick J. LoPresti wrote:
> >
>> +     /* Absolute addressability check (borrowed from ext4/super.c) */
>> +     if ((max_block >
>> +          (sector_t)(~0LL) >> (osb->sb->s_blocksize_bits - 9)) ||
>> +         (max_block > (pgoff_t)(~0LL) >> (PAGE_CACHE_SHIFT -
>> +                                          osb->sb->s_blocksize_bits))) {
>> +             mlog(ML_ERROR, "Volume too large "
>> +                  "to mount safely on this system");
>> +             status = -EFBIG;
>> +             goto out;
>> +     }
>
> This hunk of code is actually in several filesystems.  It wouldn't be a bad idea to make it a library function that can be called by the filesystem to check the kernel page cache and block layer can handle these large filesystems.

True, but some of them do it differently (e.g. see the #if switch in
xfs_sb_validate_fsb_count).  Tracking down all variants and changing
them is a much larger task than my simple patch.

Are you suggesting I need to do this before my patch is accepted at
all?  Or is this a refactoring that can happen later?

 - Pat
