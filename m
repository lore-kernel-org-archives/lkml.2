Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab0LUHds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 02:33:48 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:54352 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab0LUHdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 02:33:47 -0500
Message-ID: <4D105858.2020209@kernel.dk>
Date: Tue, 21 Dec 2010 08:33:44 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        akpm@linux-foundation.org, smcameron@yahoo.com,
        linux-kernel@vger.kernel.org, mike.miller@hp.com, thenzl@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] cciss: fix cciss_revalidate panic.
References: <20101216190200.630.8596.stgit@beardog.cce.hp.com> <4D0B190E.1030206@kernel.dk> <20101220234213.GA10060@sepie.suse.cz>
In-Reply-To: <20101220234213.GA10060@sepie.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-21 00:42, Michal Marek wrote:
> On Fri, Dec 17, 2010 at 09:02:22AM +0100, Jens Axboe wrote:
>> On 2010-12-16 20:02, Stephen M. Cameron wrote:
>>> From: Stephen M. Cameron <StephenM.Cameron>
>>>
>>> If you delete a logical drive, and then run BLKRRPART (e.g. via fdisk)
>>> on a logical drive which is "after" the deleted logical drive in the h->drv[]
>>> array, then cciss_revalidate panics because it will access the null pointer
>>> h->drv[x] when x hits the deleted drive.
>>
>> Thanks Stephen. I put this in for-linus for 2.6.37 and marked it for
>> stable backport.
> 
> This got applied without the semicolon after 'continue' somehow and
> broke build. Please apply the patch below.

I wonder how that happened. Thanks, I'll fix it up.

-- 
Jens Axboe

