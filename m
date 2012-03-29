Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828Ab2C2Acj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 20:32:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37085 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757769Ab2C2Acc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 20:32:32 -0400
Date: Wed, 28 Mar 2012 17:32:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: Make cfq_target_latency tunable through sysfs.
Message-ID: <20120329003228.GA18424@kroah.com>
References: <1332836213-5266-1-git-send-email-tm@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332836213-5266-1-git-send-email-tm@tao.ma>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 04:16:53PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In cfq, when we calculate a time slice for a process(or a cfqq to
> be precise), we have to consider the cfq_target_latency so that all the
> sync request have an estimated latency(300ms) and it is controlled by
> cfq_target_latency. But in some hadoop test, we have found that if
> there are many processes doing sequential read(24 for example), the
> throughput is bad because every process can only work for about 25ms
> and the cfqq is switched. That leads to a higher disk seek. We can
> achive the good throughput by setting low_latency=0, but then some
> read's latency is too much for the application.
> 
> So this patch makes cfq_target_latency tunable through sysfs so that
> we can tune it and find some magic number which is not bad for both
> the throughput and the read latency.

If you add/modify sysfs files, you HAVE to also have a matching change
to Documentation/ABI.

Please do so.

thanks,

greg k-h
