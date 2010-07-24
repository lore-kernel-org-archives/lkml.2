Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab0GXKDT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 06:03:19 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56861 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab0GXKDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 06:03:17 -0400
Message-ID: <4C4ABA55.2000204@kernel.dk>
Date: Sat, 24 Jul 2010 12:03:01 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Heinz Diehl <htd@fancy-poultry.org>
CC: jmoyer@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfq-iosched: don't allow aliased requests to starve 
 others
References: <x49zkxuaymb.fsf@segfault.boston.devel.redhat.com> <20100724080459.GA6500@fancy-poultry.org>
In-Reply-To: <20100724080459.GA6500@fancy-poultry.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2010 10:04 AM, Heinz Diehl wrote:
> On 14.07.2010, Jeff Moyer wrote: 
> 
>> Comments, as always, are welcome.
> 
> This patch, applied to 2.6.35-rc6, increases desktop interactivity
> _NOTICEABLY_ on my quadcore machine, and the machine stays rock-stable.
> I have now tested this patch with the latest 2.6.35-rc kernels over 
> 1 week.
> 
> Unfortunately, I can't provide some testing results which makes this
> statement more objective, but I'll do some synthetic testing in the next
> days.

It is extremely unlikely that this patch will have any impact on
"normal" workloads. To even hit a code path where it would make a
difference, you would need to use O_DIRECT IO, otherwise you cannot have
aliases in the IO scheduler.

-- 
Jens Axboe

