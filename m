Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab2LTNlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 08:41:18 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37869
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751744Ab2LTNlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 08:41:09 -0500
Message-ID: <50D31546.7020402@kernel.dk>
Date: Thu, 20 Dec 2012 14:40:22 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Arthur Marsh <arthur.marsh@internode.on.net>
CC: shli@kernel.org, neilb@suse.de, linux-kernel@vger.kernel.org
Subject: Re: git-bisect points to block: discard granularity might not be
 power of 2
References: <5806f82593938f8c5ec753ef9f1f27cbc5508ddc@webmail.internode.on.net>
In-Reply-To: <5806f82593938f8c5ec753ef9f1f27cbc5508ddc@webmail.internode.on.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-20 14:33, Arthur Marsh wrote:
> Hi,
>       one of my machines is locking up fairly early in the boot process (about 1.4 seconds in) with recent kernels and a git-bisect lead to:
> commit 8dd2cb7e880d2f77fba53b523c99133ad5054cfd
> 
> Author: Shaohua Li <shli@kernel.org>
> Date:   Fri Dec 14 11:15:36 2012 +0800
> 
>     block: discard granularity might not be power of 2
> 
>     In MD raid case, discard granularity might not be power of 2, for example, a
>     4-disk raid5 has 3*chunk_size discard granularity. Correct the calculation for
>     such cases.
> 
>     Reported-by: Neil Brown <neilb@suse.de>
>     Signed-off-by: Shaohua Li <shli@fusionio.com>
>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> The machine is a dual core Pentium IV with 2 IDE and one SCSI disk. I've tried pulling the SCSI card out and the problem still occurs.
> 
> There are no software raid arrays assembled in the boot process.
> 
> Short of taking a photo of the monitor with the dump on it I'm a bit stuck as to what to do to further identify the problem.

Should be fixed in Linus' tree as-of yesterday. So please try that and
report back if it doesn't work.

-- 
Jens Axboe

