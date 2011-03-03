Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab1CCDpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 22:45:33 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:41474 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757868Ab1CCDpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 22:45:31 -0500
Message-ID: <4D6F0ED0.80804@kernel.dk>
Date: Wed, 02 Mar 2011 22:45:20 -0500
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Justin TerAvest <teravest@google.com>, Chad Talbott <ctalbott@google.com>,
        Nauman Rafique <nauman@google.com>, Divyesh Shah <dpshah@google.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: RFC: default group_isolation to 1, remove option
References: <AANLkTinXa4Zjg0zGbPQRZQi2QW_-0y+PBzQwcdjPLVKZ@mail.gmail.com> <20110301142002.GB25699@redhat.com>
In-Reply-To: <20110301142002.GB25699@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-01 09:20, Vivek Goyal wrote:
> I think creating per group request pool will complicate the
> implementation further. (we have done that once in the past). Jens
> once mentioned that he liked number of requests per iocontext limit
> better than overall queue limit. So if we implement per iocontext
> limit, it will get rid of need of doing anything extra for group
> infrastructure.
> 
> Jens, do you think per iocontext per queue limit on request
> descriptors make sense and we can get rid of per queue overall limit? 

Since we practically don't need a limit anymore to begin with (or so is
the theory), then yes we can move to per-ioc limits instead and get rid
of that queue state. We'd have to hold on to the ioc for the duration of
the IO explicitly from the request then.

I primarily like that implementation since it means we can make the IO
completion lockless, at least on the block layer side. We still have
state to complete in the schedulers that require that, but it's a good
step at least.

-- 
Jens Axboe

