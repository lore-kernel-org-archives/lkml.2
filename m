Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1FMBDf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 21:03:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:56598 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301Ab1FMBDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 21:03:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,356,1304319600"; 
   d="scan'208";a="15435715"
Subject: Re: CFQ: async queue blocks the whole system
From: Shaohua Li <shaohua.li@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tao Ma <tm@tao.ma>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20110610092031.GD4183@redhat.com>
References: <1307616577-6101-1-git-send-email-tm@tao.ma>
	 <20110609141451.GD29913@redhat.com> <4DF0DD0F.8090407@tao.ma>
	 <20110609153738.GF29913@redhat.com>
	 <BANLkTinMp5_TS-=Y0ZsxB45RLQv18WCZDg@mail.gmail.com>
	 <BANLkTikNrxqxcouafDA-HuuDm8G_Ho7Mwg@mail.gmail.com>
	 <4DF17C38.2010306@tao.ma>
	 <BANLkTincgq4hRU=kag9sspU5ZB8QOx7gUQ@mail.gmail.com>
	 <4DF18933.4070904@tao.ma>  <20110610092031.GD4183@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Jun 2011 09:03:29 +0800
Message-ID: <1307927009.15392.102.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-10 at 17:20 +0800, Vivek Goyal wrote:
> On Fri, Jun 10, 2011 at 11:02:11AM +0800, Tao Ma wrote:
> 
> [..]
> > > I don't think we can give a deadline for async request, because we
> > > still want to give sync high priority. We can give async some slices,
> > > so for a workload of small number of async requests and large number
> > > sync requests, we don't starve async too much. But for a workload with
> > > large number of sync/async requests, async will be starved for sure
> > > and we can't solve this in cfq.
> > OK, so if you guys thinks a 500 seconds wait is good for an async write
> > to complete, fine, then we have to switch to deadline.
> 
> I don't think that starving WRITES completely is a good idea. Especially
> given the fact that you were not able to dispatch WRITES for 500 seconds.
> This needs fixing.
> 
> Its not about giving hard deadline to WRITES, but making sure we don't
> starve them completely and they also make some progress.
Sure, I have no objection to avoid write starvation for a light write
workload. We definitely should do something for such workload. Your
patch is a good start.
But for a heavy write workload (for example, Ma's test), CFQ never can
completely avoid write starvation. In such workload, write queue has
only slow progress to handle requests.

Thanks,
Shaohua

