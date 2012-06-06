Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab2FFQQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:16:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155Ab2FFQQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:16:12 -0400
Date: Wed, 6 Jun 2012 12:15:44 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        linux-fsdevel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: write-behind on streaming writes
Message-ID: <20120606161544.GA8133@redhat.com>
References: <20120529155759.GA11326@localhost>
 <CA+55aFykFaBhzzEyRYWRS9Qoy_q_R65Cuth7=XvfOZEMqjn6=w@mail.gmail.com>
 <20120530032129.GA7479@localhost>
 <20120605172302.GB28556@redhat.com>
 <20120605174157.GC28556@redhat.com>
 <20120605184853.GD28556@redhat.com>
 <20120605201045.GE28556@redhat.com>
 <20120606025729.GA1197@redhat.com>
 <CA+55aFyxucvhYhbk0yyNa1WSeYXgHHAyWRHPNWDwODQhyAWGww@mail.gmail.com>
 <20120606121408.GB4934@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120606121408.GB4934@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 08:14:08AM -0400, Vivek Goyal wrote:

[..]
> I think it is happening because sync_file_range() will send all
> the writes as SYNC and it will compete with firefox IO. On the other
> hand, flusher's IO will show up as ASYNC and CFQ  will be penalize it
> heavily and firefox's IO will be prioritized. And this effect should
> just get worse as more processes do sync_file_range().

Ok, this time I tried the same test again but with 4 processes doing
writes in parallel on 4 different files.

And with sync_file_range() things turned ugly. Interactivity was very poor. 

firefox launch test took around 1m:45s with sync_file range() while it
took only about 35seconds with regular flusher threads.

So sending writeback IO synchronously wreaks havoc.

Thanks
Vivek
