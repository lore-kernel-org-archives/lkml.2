Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab0GZNRs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 09:17:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab0GZNRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 09:17:47 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Heinz Diehl <htd@fancy-poultry.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfq-iosched: don't allow aliased requests to starve  others
References: <x49zkxuaymb.fsf@segfault.boston.devel.redhat.com>
	<20100724080459.GA6500@fancy-poultry.org> <4C4ABA55.2000204@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 26 Jul 2010 09:17:38 -0400
In-Reply-To: <4C4ABA55.2000204@kernel.dk> (Jens Axboe's message of "Sat, 24
	Jul 2010 12:03:01 +0200")
Message-ID: <x49iq42gz65.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 07/24/2010 10:04 AM, Heinz Diehl wrote:
>> On 14.07.2010, Jeff Moyer wrote: 
>> 
>>> Comments, as always, are welcome.
>> 
>> This patch, applied to 2.6.35-rc6, increases desktop interactivity
>> _NOTICEABLY_ on my quadcore machine, and the machine stays rock-stable.
>> I have now tested this patch with the latest 2.6.35-rc kernels over 
>> 1 week.
>> 
>> Unfortunately, I can't provide some testing results which makes this
>> statement more objective, but I'll do some synthetic testing in the next
>> days.
>
> It is extremely unlikely that this patch will have any impact on
> "normal" workloads. To even hit a code path where it would make a
> difference, you would need to use O_DIRECT IO, otherwise you cannot have
> aliases in the IO scheduler.

I agree that it shouldn't help normal workloads at all.  I do think
there is one other case where you can get aliases: doing I/O both
through the file system and the underlying device.  However, that's
obviously a bad idea (and maybe open_bdev_exclusive will keep that from
happening?).

Cheers,
Jeff
