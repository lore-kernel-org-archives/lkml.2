Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab0DOFXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 01:23:51 -0400
Received: from smtp-out.google.com ([74.125.121.35]:61824 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab0DOFXt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 01:23:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=XmbaapDEnT7ll34t9qE2nNB97rXvrvlII4ttnIhlv7m6gGyb6jS/p+/BWq2vqrtH+
	ZY95jRaz/SUPfYgz58PfQ==
MIME-Version: 1.0
In-Reply-To: <20100415124222.8e0e7132.sfr@canb.auug.org.au>
References: <20100415124222.8e0e7132.sfr@canb.auug.org.au>
From: Divyesh Shah <dpshah@google.com>
Date: Wed, 14 Apr 2010 22:23:25 -0700
Message-ID: <r2kaf41c7c41004142223m1464fd07u5617fe7332cb2ea@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the block tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 7:42 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Jens,
>
> After merging the block tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> ERROR: "get_gendisk" [block/blk-cgroup.ko] undefined!
> ERROR: "sched_clock" [block/blk-cgroup.ko] undefined!

Hi Stephen,
     These errors seem to show up because the 2 symbols aren't
exported and hence when building as a module we don't have access to
these symbols. I'll send a patch to fix that shortly. Sorry for the
build breakage.

-Divyesh

>
> Probably caused by commits 34d0f179d6dd711d3fc13c0820a456c59aae8048
> ("io-controller: Add a new interface "weight_device" for IO-Controller"),
> 9195291e5f05e01d67f9a09c756b8aca8f009089 ("blkio: Increment the blkio
> cgroup stats for real now") and 812df48d127365ffd0869aa139738f572a86759c
> ("blkio: Add more debug-only per-cgroup stats").
>
> I have used the version of the block tree from next-20100414 for today.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>
