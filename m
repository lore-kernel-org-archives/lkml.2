Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab1FMMoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 08:44:21 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44937 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab1FMMoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 08:44:20 -0400
Message-ID: <4DF60622.7020804@kernel.dk>
Date: Mon, 13 Jun 2011 14:44:18 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
        avillaci@ceibo.fiec.espol.edu.ec
Subject: Re: [PATCH] block: use the passed in @bdev when claiming if partno
 is  zero
References: <20110613104440.GB16021@htj.dyndns.org>
In-Reply-To: <20110613104440.GB16021@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-13 12:44, Tejun Heo wrote:
> 6b4517a791 (block: implement bd_claiming and claiming block)
> introduced claiming block to support O_EXCL blkdev opens properly.
> 
> bd_start_claiming() looks up the part 0 bdev and starts claiming
> block.  The function assumed that there is only one part 0 bdev and
> always used bdget_disk(disk, 0) to look it up; unfortunately, this
> isn't true for some drivers (floppy) which use multiple block devices
> to denote different operating parameters for the same physical device.
> There can be multiple part 0 bdev's for the same device number.
> 
> This incorrect assumption caused the wrong bdev to be used during
> claiming leading to unbalanced bd_holders as reported in the following
> bug.
> 
>   https://bugzilla.kernel.org/show_bug.cgi?id=28522
> 
> This patch updates bd_start_claiming() such that it uses the bdev
> specified as argument if its partno is zero.
> 
> Note that this means that different bdev's can be used for the same
> device and O_EXCL check can be effectively bypassed.  It has always
> been broken that way and floppy is fortunately on its way out.  Leave
> that breakage alone.

Thanks, applied for 3.0.

-- 
Jens Axboe

