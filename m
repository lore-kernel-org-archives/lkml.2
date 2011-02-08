Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab1BHX4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 18:56:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38427 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915Ab1BHX4I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 18:56:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=umxSMnvLyGqxEVIgFCzv6Bsox6O9ervyDM0C/JmzieTGiJRfkK6nepmJB7q6XP92Gl
         M6B/be7oKHUMjGzJejzEDXQ/wZPDEpdchTqWorzCt0hlZdV5MP4g+q2ifwu4Dn8/fa/M
         rmlx9IuF6CZM3+7NYnmwihL0va5sVgAonYAuM=
MIME-Version: 1.0
In-Reply-To: <0d1aa13e-be1f-4e21-adf2-f0162c67ede3@default>
References: <AANLkTi=CEXiOdqPZgQZmQwatHqZ_nsnmnVhwpdt=7q3f@mail.gmail.com>
	<0d1aa13e-be1f-4e21-adf2-f0162c67ede3@default>
Date: Wed, 9 Feb 2011 08:56:07 +0900
Message-ID: <AANLkTimm8o6FnDon=eMTepDaoViU9tjteAYE9kmJhMsx@mail.gmail.com>
Subject: Re: [PATCH V2 2/3] drivers/staging: zcache: host services and PAM services
From: Minchan Kim <minchan.kim@gmail.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: gregkh@suse.de, Chris Mason <chris.mason@oracle.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        matthew@wil.cx, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        ngupta@vflare.org, jeremy@goop.org,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        riel@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>, mel@csn.ul.ie,
        kosaki.motohiro@jp.fujitsu.com, sfr@canb.auug.org.au,
        wfg@mail.ustc.edu.cn, tytso@mit.edu, viro@zeniv.linux.org.uk,
        hughd@google.com, hannes@cmpxchg.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 9, 2011 at 8:27 AM, Dan Magenheimer
<dan.magenheimer@oracle.com> wrote:
> Hi Minchan --
>
>> First of all, thanks for endless effort.
>
> Sometimes it does seem endless ;-)
>
>> I didn't look at code entirely but it seems this series includes
>> frontswap.
>
> The "new zcache" optionally depends on frontswap, but frontswap is
> a separate patchset.  If the frontswap patchset is present
> and configured, zcache will use it to dynamically compress swap pages.
> If frontswap is not present or not configured, zcache will only
> use cleancache to dynamically compress clean page cache pages.
> For best results, both frontswap and cleancache should be enabled.
> (and see the link in PATCH V2 0/3 for a monolithic patch against
> 2.6.37 that enabled both).
>
>> Finally frontswap is to replace zram?
>
> Nitin and I have agreed that, for now, both frontswap and zram
> should continue to exist.  They have similar functionality but
> different use models.  Over time we will see if they can be merged.
>
> Nitin and I agreed offlist that the following summarizes the
> differences between zram and frontswap:
>
> ===========
>
> Zram uses an asynchronous model (e.g. uses the block I/O subsystem)
> and requires a device to be explicitly created.  When used for
> swap, mkswap creates a fixed-size swap device (usually with higher
> priority than any disk-based swap device) and zram is filled
> until it is full, at which point other lower-priority (disk-based)
> swap devices are then used.  So zram is well-suited for a fixed-
> size-RAM machine with a known workload where an administrator
> can pre-configure a zram device to improve RAM efficiency during
> peak memory load.
>
> Frontswap uses a synchronous model, circumventing the block I/O
> subsystem.  The frontswap "device" is completely dynamic in size,
> e.g. frontswap is queried for every individual page-to-be-swapped
> and, if rejected, the page is swapped to the "real" swap device.
> So frontswap is well-suited for highly dynamic conditions where
> workload is unpredictable and/or RAM size may "vary" due to
> circumstances not entirely within the kernel's control.
>
> ==========
>
> Does that make sense?

Thanks for the quick reply.
As I read your comment, I can't find the benefit of zram compared to frontswap.

1. asynchronous model
2. usability
3. adaptive dynamic ram size

If I consider your statement, with 2, 3, zram isn't better than
fronswap, I think.
1 on zram may be good than frontswap but I doubt how much we have a
big benefit on async operation in ramdisk model.

If we have a big overhead of block stuff in such a model, couldn't we
remove the overhead generally?

What I can think of benefit is that zram export interface to block
device so someone can use compressed block device.
Block device interface exporting is enough to live zram in there?

Maybe I miss something of zram's benefits.
At least, I can't convince why zram and frontswap should coexist.
AFAIK, Nitin and you discussed it many times long time ago but I
didn't follow up it.  Sorry if I am missing something.

Thanks.


-- 
Kind regards,
Minchan Kim
