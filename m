Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab2KFLjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 06:39:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37281 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab2KFLjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 06:39:47 -0500
Message-ID: <5098F6E1.6010502@kernel.dk>
Date: Tue, 06 Nov 2012 12:39:13 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: block CFQ: avoid moving request to different queue
References: <20121106113428.GA19182@kernel.org>
In-Reply-To: <20121106113428.GA19182@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-06 12:34, Shaohua Li wrote:
> request is queued in cfqq->fifo list. Looks it's possible we are
> moving a request from one cfqq to another in request merge case. In
> such case, adjusting the fifo list order doesn't make sense and is
> impossible if we don't iterate the whole fifo list.
> 
> My test does hit one case the two cfqq are different, but didn't cause
> kernel crash, maybe it's because fifo list isn't used frequently.
> Anyway, from the code logic, this is buggy.

Good find!! Usually we never merge between cfqq's as our lookup basis is
the cfqq. And yes, the fifo generally isn't used a lot, it's only a
fallback measure to prevent inter-cfqq unfairness.

Applied to for-3.8/core.

And lets re-enable the recursive merging, please do send a patch for
that too.

-- 
Jens Axboe

