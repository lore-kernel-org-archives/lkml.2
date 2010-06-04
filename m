Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab0FDLpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 07:45:19 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:40755 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057Ab0FDLpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 07:45:17 -0400
Message-ID: <4C08E73B.8050806@fusionio.com>
Date: Fri, 04 Jun 2010 13:44:59 +0200
From: Jens Axboe <jaxboe@fusionio.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH v4] block: avoid unconditionally freeing previously  allocated
 request_queue
References: <1274744795-9825-1-git-send-email-snitzer@redhat.com> <1274744795-9825-3-git-send-email-snitzer@redhat.com> <4BFBB21A.3030105@ct.jp.nec.com> <20100525124912.GA7447@redhat.com> <20100525163455.GA10155@redhat.com> <20100526045219.GB24702@redhat.com> <20100603165809.GA6730@redhat.com> <20100603173452.GC6730@redhat.com>
In-Reply-To: <20100603173452.GC6730@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-03 19:34, Mike Snitzer wrote:
> block: avoid unconditionally freeing previously allocated request_queue
> 
> On blk_init_allocated_queue_node failure, only free the request_queue if
> it is wasn't previously allocated outside the block layer
> (e.g. blk_init_queue_node was blk_init_allocated_queue_node caller).
> 
> This addresses an interface bug introduced by the following commit:
> 01effb0 block: allow initialization of previously allocated
> request_queue
> 
> Otherwise the request_queue may be free'd out from underneath a caller
> that is managing the request_queue directly (e.g. caller uses
> blk_alloc_queue + blk_init_allocated_queue_node).

Thanks Mike, this looks a lot better. I have applied this one and
2/2 of the original posting.

-- 
Jens Axboe

