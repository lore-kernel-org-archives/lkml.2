Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab0CQNaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 09:30:22 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:34568 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab0CQNaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 09:30:21 -0400
Date: Wed, 17 Mar 2010 14:30:19 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, czoccolo@gmail.com, vgoyal@redhat.com,
       jmoyer@redhat.com, guijianfeng@cn.fujitsu.com, alex.shi@intel.com
Subject: Re: [RFC]cfq-iosched: fix a kbuild regression
Message-ID: <20100317133019.GV5768@kernel.dk>
References: <20100316025656.GA15390@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316025656.GA15390@sli10-desk.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16 2010, Shaohua Li wrote:
> Alex Shi reported a kbuild regression which is about 10% performance lost.
> He bisected to this commit: 3dde36ddea3e07dd025c4c1ba47edec91606fec0.
> The reason is cfqq_close() can't find close cooperator. If we store the seek
> distance to the value before the commit like below, the regression fully goes
> away. If this is too invasive, just changing the cfq_rq_close() for the
> !for_preempt is ok too.

Corrado, any objections to widening the seek threshold?

> 
> Reported-by: Alex Shi <alex.shi@intel.com>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index dee9d93..fcae456 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -46,7 +46,7 @@ static const int cfq_hist_divisor = 4;
>  #define CFQ_HW_QUEUE_MIN	(5)
>  #define CFQ_SERVICE_SHIFT       12
>  
> -#define CFQQ_SEEK_THR		(sector_t)(8 * 100)
> +#define CFQQ_SEEK_THR		(sector_t)(8 * 1024)
>  #define CFQQ_SECT_THR_NONROT	(sector_t)(2 * 32)
>  #define CFQQ_SEEKY(cfqq)	(hweight32(cfqq->seek_history) > 32/8)
>  

-- 
Jens Axboe

