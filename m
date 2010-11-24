Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589Ab0KXILQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:11:16 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55396 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab0KXILO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:11:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uk/rlNEueNd2SeaP403TwjUQBDHWmtFx+J/qscYVbipWsKnGqmV8Z+BoflJDtOmWTr
         uhQ5MwYSYexvDVNtTA+NTSAQIjugjkAxp5dAlne9NL3+EAj0+tT3ARrzWmS7UzdMwf63
         00hVCck8aBWAK8Jc6xk0GV7UgthKSl0mVDhFw=
MIME-Version: 1.0
In-Reply-To: <20101124075818.GB2212@linux-sh.org>
References: <4CE79BD0.3030200@gmail.com>
	<20101124075818.GB2212@linux-sh.org>
Date: Wed, 24 Nov 2010 09:11:13 +0100
Message-ID: <AANLkTinF2NX9e7deTvDa8zQ0PA4u0ch0xrNWk0FaqvGV@mail.gmail.com>
Subject: Re: [PATCH 04/16 v4] pramfs: file operations
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
> On Sat, Nov 20, 2010 at 10:58:40AM +0100, Marco Stornelli wrote:
>> diff -Nurp linux-2.6.36-orig/fs/pramfs/file.c linux-2.6.36/fs/pramfs/file.c
>> --- linux-2.6.36-orig/fs/pramfs/file.c        1970-01-01 01:00:00.000000000 +0100
>> +++ linux-2.6.36/fs/pramfs/file.c     2010-09-24 18:34:03.000000000 +0200
>> @@ -0,0 +1,166 @@
>> +/*
>> + * FILE NAME fs/pramfs/file.c
>> + *
>> + * BRIEF DESCRIPTION
>> + *
>> + * File operations for files.
>> + *
> This FILE NAME / BRIEF DESCRIPTION thing should probably die, it's also
> not used consistently throughout the series.

Maybe yes, it's more a problem then a advantage :)

>
>> +static int pram_open_file(struct inode *inode, struct file *filp)
>> +{
>> +#ifndef CONFIG_PRAMFS_XIP
>> +     /* Without XIP we force to use Direct IO */
>> +     filp->f_flags |= O_DIRECT;
>> +#endif
>> +     return generic_file_open(inode, filp);
>> +}
>> +
> Relying on a config option for this is in violently poor taste. Rely on
> the config option to enable/disable XIP support as you like, but whether
> it's actually mounted XIP or not should really depend be determined by a
> mount option. Presently you have no way of dealing with the file system
> being mounted multiple times with mixed XIP and non-XIP, which doesn't
> seem like a particularly exotic configuration. As you seem to have copied

Maybe on embedded, it could be.

> most of this from ext2, I'm curious why you opted to hardcode this
> instead of maintaining the flexibility that ext2 XIP has over this.
>

First of all because it was simpler :) In addition there was some
design problem to use it in combination with the memory protection.
The difference with ext2 is that we aren't talking about a general
purpose fs used (mainly) on normal desktop/server systems, but a
specific fs for embedded world, so I think some little constraints are
ok.

Marco
