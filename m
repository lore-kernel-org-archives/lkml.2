Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab3AGHzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 02:55:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50264 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab3AGHzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 02:55:53 -0500
Message-ID: <50EA7F3A.2010601@kernel.dk>
Date: Mon, 07 Jan 2013 08:54:34 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: majianpeng <majianpeng@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Remove judgement for rq_mergeable(rq) in func
 elv_rqhash_find.
References: <201301071308168882920@gmail.com>
In-Reply-To: <201301071308168882920@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-07 06:08, majianpeng wrote:
> Because only mergeable rq can add rqhash.So it does not make sense to
> judge rq_mergeable(rq) in func elv_rqhash_find.

It does make sense. A request is always mergeable when it enters the
hash, but it may not remain mergeable. This can happen if we merge it to
its maximum size, for instance.

-- 
Jens Axboe

