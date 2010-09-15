Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab0IOLHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 07:07:14 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:47006 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab0IOLHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 07:07:13 -0400
Message-ID: <4C90A8E0.4050807@kernel.dk>
Date: Wed, 15 Sep 2010 13:07:12 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: fix an address space warning in blk-map.c
References: <1284478956-13664-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1284478956-13664-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-14 17:42, Namhyung Kim wrote:
> Change type of 2nd parameter of blk_rq_aligned() into unsigned long
> and remove unnecessary casting. Now we can call it with 'uaddr'
> instead of 'ubuf' in __blk_rq_map_user() so that it can remove
> following warnings from sparse:
> 
>  block/blk-map.c:57:31: warning: incorrect type in argument 2 (different address spaces)
>  block/blk-map.c:57:31:    expected void *addr
>  block/blk-map.c:57:31:    got void [noderef] <asn:1>*ubuf
> 
> However blk_rq_map_kern() needs one more local variable to handle it.

Thanks, applied to for-2.6.37/core

-- 
Jens Axboe

