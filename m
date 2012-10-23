Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab2JWAx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 20:53:57 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:37591 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321Ab2JWAx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 20:53:56 -0400
Message-ID: <5085EA94.7000901@oracle.com>
Date: Mon, 22 Oct 2012 19:53:40 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121012 Thunderbird/16.0.1
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>
Subject: Re: [PATCH v3 00/22] loop: Issue O_DIRECT aio using bio_vec
References: <1350918922-6096-1-git-send-email-dave.kleikamp@oracle.com> <20121023000733.GG4291@dastard>
In-Reply-To: <20121023000733.GG4291@dastard>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 07:07 PM, Dave Chinner wrote:
> On Mon, Oct 22, 2012 at 10:15:00AM -0500, Dave Kleikamp wrote:
>> This is the current version of the patchset I presented at the LSF-MM
>> Summit in San Francisco in April. I apologize for letting it go so
>> long before re-submitting.
>>
>> This patchset was begun by Zach Brown and was originally submitted for
>> review in October, 2009. Feedback was positive, and I have picked up
>> where he left off, porting his patches to the latest mainline kernel
>> and adding support more file systems.
>>
>> This patch series adds a kernel interface to fs/aio.c so that kernel code can
>> issue concurrent asynchronous IO to file systems.  It adds an aio command and
>> file system methods which specify io memory with pages instead of userspace
>> addresses.
>>
>> This series was written to reduce the current overhead loop imposes by
>> performing synchronus buffered file system IO from a kernel thread.  These
>> patches turn loop into a light weight layer that translates bios into iocbs.
> 
> I note that there is no support for XFS in this patch set. Is there
> a particular problem that prevents XFS from being converted, or it
> just hasn't been done?

It just hasn't been done. It wasn't one of the trivial ones so I put it
off at first, and after that, it's an oversight. I'll follow up with an
xfs patch for your review.

Thanks,
Shaggy

> 
> Cheers,
> 
> Dave.
> 
