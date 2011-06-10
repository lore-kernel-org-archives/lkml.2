Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab1FJJWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 05:22:00 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:54807 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405Ab1FJJV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 05:21:58 -0400
Message-ID: <4DF1E235.8010104@kernel.dk>
Date: Fri, 10 Jun 2011 11:21:57 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Tao Ma <tm@tao.ma>, Shaohua Li <shaohua.li@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: CFQ: async queue blocks the whole system
References: <1307616577-6101-1-git-send-email-tm@tao.ma> <20110609141451.GD29913@redhat.com> <4DF0DD0F.8090407@tao.ma> <20110609153738.GF29913@redhat.com> <BANLkTinMp5_TS-=Y0ZsxB45RLQv18WCZDg@mail.gmail.com> <BANLkTikNrxqxcouafDA-HuuDm8G_Ho7Mwg@mail.gmail.com> <4DF17C38.2010306@tao.ma> <BANLkTincgq4hRU=kag9sspU5ZB8QOx7gUQ@mail.gmail.com> <4DF18933.4070904@tao.ma> <20110610092031.GD4183@redhat.com>
In-Reply-To: <20110610092031.GD4183@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-10 11:20, Vivek Goyal wrote:
> On Fri, Jun 10, 2011 at 11:02:11AM +0800, Tao Ma wrote:
> 
> [..]
>>> I don't think we can give a deadline for async request, because we
>>> still want to give sync high priority. We can give async some slices,
>>> so for a workload of small number of async requests and large number
>>> sync requests, we don't starve async too much. But for a workload with
>>> large number of sync/async requests, async will be starved for sure
>>> and we can't solve this in cfq.
>> OK, so if you guys thinks a 500 seconds wait is good for an async write
>> to complete, fine, then we have to switch to deadline.
> 
> I don't think that starving WRITES completely is a good idea. Especially
> given the fact that you were not able to dispatch WRITES for 500 seconds.
> This needs fixing.
> 
> Its not about giving hard deadline to WRITES, but making sure we don't
> starve them completely and they also make some progress.

Agree, we need to have some sort of forward progress guarantee at least.
Starving buffered writes indefinitely is surely a BUG. And it must be a
regression from not that long ago.

Trying to catch up with this thread...

-- 
Jens Axboe

