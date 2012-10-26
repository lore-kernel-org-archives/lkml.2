Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966164Ab2JZTZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 15:25:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966098Ab2JZTZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 15:25:26 -0400
Date: Fri, 26 Oct 2012 15:25:17 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Robin Dong <robin.k.dong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Robin Dong <sanbai@taobao.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tao Ma <boyu.mt@taobao.com>
Subject: Re: [PATCH 2/2 v4] block/throttle: Add IO submitted information in
 blkio.throttle
Message-ID: <20121026192517.GC24687@redhat.com>
References: <1351226868-30063-1-git-send-email-robin.k.dong@gmail.com>
 <1351226868-30063-2-git-send-email-robin.k.dong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351226868-30063-2-git-send-email-robin.k.dong@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 12:47:48PM +0800, Robin Dong wrote:

[..]
> @@ -1084,6 +1114,16 @@ static struct cftype throtl_files[] = {
>  		.private = offsetof(struct tg_stats_cpu, serviced),
>  		.read_seq_string = tg_print_cpu_rwstat,
>  	},
> +	{
> +		.name = "throttle.io_submit_bytes",

Do we really need io_submit_bytes stats? Your need seems to be able to
figure out if there are pending IOs in the group and if you need to
increase the bandwidth. For that, isn't number of bios enough?

Also even if we retain bytes, let us change it to "io_submitted_bytes".

Thanks
Vivek
