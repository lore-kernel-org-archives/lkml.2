Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab2LNC0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 21:26:13 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40089 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab2LNC0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 21:26:12 -0500
MIME-Version: 1.0
In-Reply-To: <20121213211808.GJ25017@kernel.dk>
References: <1354568322-29029-1-git-send-email-koverstreet@google.com>
	<20121213211808.GJ25017@kernel.dk>
Date: Fri, 14 Dec 2012 10:26:09 +0800
Message-ID: <CA+res+SKXjXTgrxPaj+kuekd-CZMp4POkSpsdJ7Csfg0HsD=bA@mail.gmail.com>
Subject: Re: [PATCH 00/26] AIO performance improvements/cleanups, v2
From: Jack Wang <jack.wang.usish@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, zab@redhat.com,
        bcrl@kvack.org, jmoyer@redhat.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/14 Jens Axboe <jaxboe@fusionio.com>:
> On Mon, Dec 03 2012, Kent Overstreet wrote:
>> Last posting: http://thread.gmane.org/gmane.linux.kernel.aio.general/3169
>>
>> Changes since the last posting should all be noted in the individual
>> patch descriptions.
>>
>>  * Zach pointed out the aio_read_evt() patch was calling functions that
>>    could sleep in TASK_INTERRUPTIBLE state, that patch is rewritten.
>>  * Ben pointed out some synchronize_rcu() usage was problematic,
>>    converted it to call_rcu()
>>  * The flush_dcache_page() patch is new
>>  * Changed the "use cancellation list lazily" patch so as to remove
>>    ki_flags from struct kiocb.
>
> Kent, I ran a few tests, and the below patches still don't seem as fast
> as the approach I took. To keep it fair, I used your aio branch and
> applied by dio speedups too. As a sanity check, I ran with your branch
> alone as well. The quick results below - kaio is kent-aio, just your
> branch. kaio-dio is with the direct IO speedups too. jaio is my branch,
> which already has the dio changes too.
>
> Devices         Branch          IOPS
> 1               kaio            ~915K
> 1               kaio-dio        ~930K
> 1               jaio           ~1220K
> 6               kaio           ~3050K
> 6               kaio-dio       ~3080K
> 6               jaio            3500K
>
> The box runs out of CPU driving power, which is why it doesn't scale
> linearly, otherwise I know that jaio at least does. It's basically
> completion limited for the 6 device test at the moment.
>
> I'll run some profiling tomorrow morning and get you some better
> results. Just thought I'd share these at least.
>
> --
> Jens Axboe
>

A really good performance, woo.

I think the device tested is really fast PCIe SSD builded by fusionio
with fusionio in house block driver?

any compare number with current mainline?

Jack
