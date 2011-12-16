Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245Ab1LPM4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 07:56:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44480 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300Ab1LPM4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 07:56:37 -0500
Message-ID: <4EEB4001.8010205@kernel.dk>
Date: Fri, 16 Dec 2011 13:56:33 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2]block, cfq: fix empty queue crash caused by request
 merge
References: <1324000362.22361.452.camel@sli10-conroe>
In-Reply-To: <1324000362.22361.452.camel@sli10-conroe>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-16 02:52, Shaohua Li wrote:
> All requests of a queue could be merged to other requests of other queue.
> Such queue will not have request in it, but it's in service tree. This
> will cause kernel oops.
> I encounter a BUG_ON() in cfq_dispatch_request() with next patch, but the
> issue should exist without the patch.

Good catch, yes I think this could happen if you just happen to have a
very deliberate/unlucky set of processes and timings. Applied.


-- 
Jens Axboe

