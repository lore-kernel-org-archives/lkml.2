Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab2KGQkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:40:40 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33458 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab2KGQkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:40:17 -0500
MIME-Version: 1.0
In-Reply-To: <CAEwNFnD9tVywtb6s3YGMs7vcndCVZNZ0wU=RnOeVnG9UEXnmWQ@mail.gmail.com>
References: <1351840367-4152-1-git-send-email-minchan@kernel.org>
	<20121106153213.03e9cc9f.akpm@linux-foundation.org>
	<CAEwNFnAA+PNh0OT7vdv5k5u3TXeBUDJZX75TQg_Si4yFnE6e-g@mail.gmail.com>
	<CAEwNFnD9tVywtb6s3YGMs7vcndCVZNZ0wU=RnOeVnG9UEXnmWQ@mail.gmail.com>
Date: Wed, 7 Nov 2012 08:40:16 -0800
Message-ID: <CAA25o9S=XiO7b-HNbx1GHr+ETrA_p11WU+FUprMn_VhjU=jjvw@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] zram/zsmalloc promotion
From: Luigi Semenzato <semenzato@google.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Jens Axboe <axboe@kernel.dk>, Pekka Enberg <penberg@cs.helsinki.fi>,
        gaowanlong@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since Chrome OS was mentioned: the main reason why we don't use swap
to a disk (rotating or SSD) is because it doesn't degrade gracefully
and leads to a bad interactive experience.  Generally we prefer to
manage RAM at a higher level, by transparently killing and restarting
processes.  But we noticed that zram is fast enough to be competitive
with the latter, and it lets us make more efficient use of the
available RAM.

As Minchan said, the zram module in itself appears to work fine.  We
are hitting other mm issues (one of which was recently fixed) which
most likely are exposed by the different patterns of memory allocation
when using zram.

On Wed, Nov 7, 2012 at 2:38 AM, Minchan Kim <minchan@kernel.org> wrote:
> Hi Andrew,
>
> On Wed, Nov 7, 2012 at 8:32 AM, Andrew Morton <akpm@linux-foundation.org>
> wrote:
>> On Fri, 2 Nov 2012 16:12:44 +0900
>> Minchan Kim <minchan@kernel.org> wrote:
>>
>>> This patchset promotes zram/zsmalloc from staging.
>>
>> The changelogs are distressingly short of *reasons* for doing this!
>>
>>> Both are very clean and zram have been used by many embedded product
>>> for a long time.
>>
>> Well that's interesting.
>>
>> Which embedded products? How are they using zram and what benefit are
>> they observing from it, in what scenarios?
>>
>
> At least, major TV companys have used zram as swap since two years ago and
> recently our production team released android smart phone with zram which is
> used as swap, too.
> And there is trial to use zram as swap in ChromeOS project, too. (Although
> they report some problem recently, it was not a problem of zram).
> When you google zram, you can find various usecase in xda-developers.
>
> With my experience, the benefit in real practice was to remove jitter of
> video application. It would be effect of efficient memory usage by
> compression but more issue is whether swap is there or not in the system. As
> you know, recent mobile platform have used JAVA so there are lots of
> anonymous pages. But embedded system normally doesn't use eMMC or SDCard as
> swap because there is wear-leveling issue and latency so we can't reclaim
> anymous pages. It sometime ends up making system very slow when it requires
> to get contiguous memory and even many file-backed pages are evicted. It's
> never what embedded people want it. Zram is one of best solution for that.
>
> It's very hard to type with mobile phone. :(
>
> --
> Kind regards,
> Minchan Kim
