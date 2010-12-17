Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab0LQICj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 03:02:39 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:36357 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab0LQICi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 03:02:38 -0500
Message-ID: <4D0B190E.1030206@kernel.dk>
Date: Fri, 17 Dec 2010 09:02:22 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
CC: akpm@linux-foundation.org, smcameron@yahoo.com,
        linux-kernel@vger.kernel.org, mike.miller@hp.com, thenzl@redhat.com
Subject: Re: [PATCH] cciss: fix cciss_revalidate panic.
References: <20101216190200.630.8596.stgit@beardog.cce.hp.com>
In-Reply-To: <20101216190200.630.8596.stgit@beardog.cce.hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-16 20:02, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <StephenM.Cameron>
> 
> If you delete a logical drive, and then run BLKRRPART (e.g. via fdisk)
> on a logical drive which is "after" the deleted logical drive in the h->drv[]
> array, then cciss_revalidate panics because it will access the null pointer
> h->drv[x] when x hits the deleted drive.

Thanks Stephen. I put this in for-linus for 2.6.37 and marked it for
stable backport.

-- 
Jens Axboe

