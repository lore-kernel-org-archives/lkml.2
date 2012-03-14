Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030618Ab2CNCrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:47:42 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:52313 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030391Ab2CNCrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:47:40 -0400
Message-ID: <4F6006C3.4010204@kernel.org>
Date: Wed, 14 Mar 2012 10:47:31 +0800
From: Shaohua Li <shli@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [patch 0/7] Add TRIM support for raid linear/0/1/10
References: <20120312030412.375458948@fusionio.com> <20120314132422.3aeb6d49@notabene.brown>
In-Reply-To: <20120314132422.3aeb6d49@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/12 10:24 AM, NeilBrown wrote:
>  On Mon, 12 Mar 2012 11:04:12 +0800 Shaohua Li <shli@fusionio.com> wrote:
>
> > The patches add TRIM support for raid linear/0/1/10. I'll add TRIM 
support for
> > raid 4/5/6 later. The implementation is pretty straightforward and
> > self-explained.
> >
> > Thanks,
> > Shaohua
>
>  Thanks.
>  They look mostly OK.
>
>  In raid0.c, I think you'll need to change
>
>  /* Sanity check -- queue functions should prevent this happening */
>  if (bio->bi_vcnt != 1 ||
>  bio->bi_idx != 0)
>  goto bad_map;
>
>  to also allow for 'bi_vcnt == 0' like you did in bio_split.
>
>  Also I wonder about handling failure in RAID1.
>  I think the code will currently treat it like a write error, and
>  maybe record a bad block (then fail the device is writing the badblock
>  record fails). Is that what were want?
Mainly to simplify the code. And I thought a normal discard should not fail.
If it fails, something is wrong, marked it as badblock maybe not bad.

>  And of course resync/recovery will mess up the discarded sector 
information,
>  so this isn't a complete solution for RAID1. But it is a reasonable start.
Yes, this is a mess. Looks impossible without ondisk format change at
first glance.

Thanks,
Shaohua
