Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290Ab1LPM7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 07:59:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45925 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759114Ab1LPM7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 07:59:09 -0500
Message-ID: <4EEB409B.3070004@kernel.dk>
Date: Fri, 16 Dec 2011 13:59:07 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/2]block: recursive merge requests
References: <1324000363.22361.453.camel@sli10-conroe>
In-Reply-To: <1324000363.22361.453.camel@sli10-conroe>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-16 02:52, Shaohua Li wrote:
> In my workload, thread 1 accesses a, a+2, ..., thread 2 accesses a+1,
> a+3,.... When the requests are flushed to queue, a and a+1 are merged
> to (a, a+1), a+2 and a+3 too to (a+2, a+3), but (a, a+1) and (a+2, a+3)
> aren't merged.
> With recursive merge below, the workload throughput gets improved 20%
> and context switch drops 60%.

Interesting, I didn't consider that corner case. Hard to argue with the
numbers, this might positively impact apps using posix aio for instance.
Applied to for-3.3/core.

-- 
Jens Axboe

