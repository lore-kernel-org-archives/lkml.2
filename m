Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611Ab2IDVUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 17:20:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46589 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757685Ab2IDVUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 17:20:20 -0400
Date: Tue, 4 Sep 2012 14:20:22 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, bharrosh@panasas.com,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] dm: Use bioset's front_pad for dm_target_io
Message-ID: <20120904212022.GB8724@dhcp-172-17-108-109.mtv.corp.google.com>
References: <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
 <20120829165006.GB20312@google.com>
 <20120829170711.GC12504@redhat.com>
 <20120829171345.GC20312@google.com>
 <20120830220745.GI27257@redhat.com>
 <20120831014359.GB15218@moria.home.lan>
 <Pine.LNX.4.64.1209031638110.15620@file.rdu.redhat.com>
 <20120904034100.GA21602@moria.home.lan>
 <Pine.LNX.4.64.1209041509160.22689@file.rdu.redhat.com>
 <20120904195156.GE25236@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120904195156.GE25236@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Tue, Sep 04, 2012 at 12:51:56PM -0700, Kent Overstreet wrote:
> I wrote a patch for dm_target_io last night. I think I know an easy way
> to go about converting the rest but it'll probably have to wait until
> I'm further along with my immutable bvec stuff.
> 
> Completely untested patch below:

Yeap, this looks great to me.  In the end, I think it's better to
require stacking drivers to not use separate mempools other than
bioset.  Timer or not, using multiple alloc pools is brittle.  Any
path which ends up allocating in different orders for whatever reason
can lead to subtle deadlock scenarios which can be very difficult to
track down and, at least currently, there's no way to automatically
detect them.  Besides, w/ front-pad, it really shouldn't be necessary.

Thanks.

-- 
tejun
