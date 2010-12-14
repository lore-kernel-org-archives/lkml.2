Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab0LNCsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 21:48:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab0LNCsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 21:48:06 -0500
Date: Mon, 13 Dec 2010 21:47:56 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8 v2] cfq-iosched: Introduce vdisktime and io weight
 for CFQ queue
Message-ID: <20101214024756.GA9004@redhat.com>
References: <4CDF7BC5.9080803@cn.fujitsu.com>
 <4CDF9CC6.2040106@cn.fujitsu.com>
 <20101115165319.GI30792@redhat.com>
 <4CE2718C.6010406@kernel.dk>
 <4D01C6AB.9040807@cn.fujitsu.com>
 <4D057A8D.1020704@cn.fujitsu.com>
 <20101213165910.GE20454@redhat.com>
 <4D06D95C.4020107@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D06D95C.4020107@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 10:41:32AM +0800, Gui Jianfeng wrote:

[..]
> >> +
> >> +	/*
> >> +	 * update the io weight if io priority gets changed.
> >> +	 */
> >> +	cfqe->weight = cfq_prio_to_weight(cfqq->ioprio);
> > 
> > How do you know that this cfqe/cfqq is not already on the service tree? I
> > don't think you can update weights while you are enqueued on the tree.
> 
> Vivek, I'm not sure why we can't update weights if cfqe is enqueued on the tree.
> Do you mean when we update cfqe's weight we need to update tree's total_weight
> accordingly?

So far I can think of adjusting total_weight accordingly also if you are
updating the queue weight while it is on service tree.

Thanks
Vivek
