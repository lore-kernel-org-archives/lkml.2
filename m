Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab1HEFMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 01:12:32 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52307 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab1HEFMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 01:12:30 -0400
MIME-Version: 1.0
In-Reply-To: <1312519150-3261-1-git-send-email-tm@tao.ma>
References: <1312519150-3261-1-git-send-email-tm@tao.ma>
Date: Fri, 5 Aug 2011 13:12:29 +0800
X-Google-Sender-Auth: RzWm88NTRw63akTsibC5dGzhhmc
Message-ID: <CANejiEWx1xGiQ=wxX2-w+-9FThUm9z-opN-Aqvvizv588XYsmw@mail.gmail.com>
Subject: Re: [PATCH] block: Make rq_affinity = 1 work as expected.
From: Shaohua Li <shli@kernel.org>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Roland Dreier <roland@purestorage.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/5 Tao Ma <tm@tao.ma>:
> From: Tao Ma <boyu.mt@taobao.com>
>
> Commit 5757a6d76c introduced a new rq_affinity = 2 so as to make
> the request completed in the __make_request cpu. But it makes the
> old rq_affinity = 1 not work any more. The root cause is that
> if the 'cpu' and 'req->cpu' is in the same group and cpu != req->cpu,
> ccpu will be the same as group_cpu, so the completion will be
> excuted in the 'cpu' not 'group_cpu'.
>
> This patch fix problem by simpling removing group_cpu and the codes
> are more explicit now. If ccpu == cpu, we complete in cpu, otherwise
> we raise_blk_irq to ccpu.
good catch. This changed old behavior and can cause more lock contention.
and if user doesn't care about lock contention, he can use rq_affinity = 2

Reviewed-by: Shaohua Li <shaohua.li@intel.com>
