Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab0H3R4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:56:25 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:43939 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674Ab0H3R4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:56:24 -0400
Message-ID: <4C7BF0C8.8070505@fusionio.com>
Date: Mon, 30 Aug 2010 19:56:24 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jeffrey Carlyle <jeff.carlyle@motorola.com>
CC: Tejun Heo <tj@kernel.org>,
        OLUSANYA SOYANNWO <olusanya.soyannwo@motorola.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hu Tao <taohu@motorola.com>, "torvalds@osdl.org" <torvalds@osdl.org>
Subject: Re: [PATCH v6] scatterlist: prevent invalid free when alloc fails
References: <4C7BD8BE.7050600@kernel.org> <20100830165022.96032603843@il93ubuntu.localdomain>
In-Reply-To: <20100830165022.96032603843@il93ubuntu.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-30 18:19, Jeffrey Carlyle wrote:
> When alloc fails, free_table is being called. Depending on the number of
> bytes requested, we determine if we are going to call _get_free_page()
> or kmalloc(). When alloc fails, our math is wrong (due to sg_size - 1),
> and the last buffer is wrongfully assumed to have been allocated by
> kmalloc. Hence, kfree gets called and a panic occurs.

That's a lot of revs, thanks for getting it done (and Tejun for
the careful reviews).

-- 
Jens Axboe

