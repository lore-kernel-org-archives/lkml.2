Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab1ILJ7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 05:59:54 -0400
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:46910
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab1ILJ7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 05:59:53 -0400
Message-ID: <4E6DD818.80902@kernel.dk>
Date: Mon, 12 Sep 2011 11:59:52 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] block: remove support for bio remapping from ->make_request
References: <20110911145053.GA28996@infradead.org> <20110911145129.GA29504@infradead.org>
In-Reply-To: <20110911145129.GA29504@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-11 16:51, Christoph Hellwig wrote:
> There is very little benefit in allowing to let a ->make_request
> instance update the bios device and sector and loop around it in
> __generic_make_request when we can archive the same through calling
> generic_make_request from the driver and letting the loop in
> generic_make_request handle it.

Agree, this looks good! Will apply for 3.2.

> Note that various drivers got the return value from ->make_request and
> returned non-zero values for errors.

Hadn't noticed that, I guess the return values are easy to get wrong in
that case. Never a good sign.


-- 
Jens Axboe

