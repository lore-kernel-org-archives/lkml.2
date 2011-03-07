Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab1CGUrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 15:47:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008Ab1CGUrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 15:47:00 -0500
Date: Mon, 7 Mar 2011 15:46:51 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Justin TerAvest <teravest@google.com>, Chad Talbott <ctalbott@google.com>,
        Nauman Rafique <nauman@google.com>, Divyesh Shah <dpshah@google.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: RFC: default group_isolation to 1, remove option
Message-ID: <20110307204651.GK9540@redhat.com>
References: <AANLkTinXa4Zjg0zGbPQRZQi2QW_-0y+PBzQwcdjPLVKZ@mail.gmail.com>
 <20110301142002.GB25699@redhat.com>
 <4D6F0ED0.80804@kernel.dk>
 <AANLkTin+TycqQxWGyxWOsuT+WOaEA0XhqFkJBMKe7-uY@mail.gmail.com>
 <4D753488.6090808@kernel.dk>
 <20110307202432.GH9540@redhat.com>
 <4D7540F6.3080303@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7540F6.3080303@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 09:32:54PM +0100, Jens Axboe wrote:

[..]
> > So given then fact that per-ioc-per-disk accounting of request descriptors
> > makes the accounting complicated and also makes it hard for block IO
> > controller to use it, the other approach of implementing per group limit
> > and per-group-per-bdi congested might be reasonable. Having said that, the
> > patch I had written for per group descritor was also not necessarily very
> > simple.
> 
> So before all of this gets over designed a lot... If we get rid of the
> one remaining direct buffered writeback in bdp(), then only the flusher
> threads should be sending huge amounts of IO. So if we attack the
> problem from that end instead, have it do that accounting in the bdi.
> With that in place, I'm fairly confident that we can remove the request
> limits.
> 
> Basically just replace the congestion_wait() in there with a bit of
> accounting logic. Since it's per bdi anyway, we don't even have to
> maintain that state in the bdi itself. It can remain in the thread
> stack.

Moving the accounting up sounds interesting. For cgroup stuff we again shall
have to do something additional like having per cgroup per bdi flusher threads
or mainting the number of pending IO per group and not flusher thread does not
submitting IOs for groups which have lots of pending IOs (to avoid faster
group getting blocked behind slower one).

Thanks
Vivek
