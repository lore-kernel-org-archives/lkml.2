Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab2BGQXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 11:23:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55768 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab2BGQW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 11:22:59 -0500
Date: Tue, 7 Feb 2012 08:22:53 -0800
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        Shaohua Li <vivek.goyal2008@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Subject: Re: [PATCH] block: strip out locking optimization in
 put_io_context()
Message-ID: <20120207162253.GG21292@google.com>
References: <1328514611.21268.66.camel@sli10-conroe>
 <20120206151219.GC30752@redhat.com>
 <4F2FFB21.9000202@kernel.dk>
 <20120206163721.GF30752@redhat.com>
 <20120206164428.GA21292@google.com>
 <CA+55aFx6BR_ZUHd8d64btu-LzsPHo3Ot_d1-5jJytjQUqvvaiQ@mail.gmail.com>
 <20120206172706.GB21292@google.com>
 <4F303506.9000201@kernel.dk>
 <20120206215451.GD21292@google.com>
 <4F30C96F.1000905@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F30C96F.1000905@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

On Tue, Feb 07, 2012 at 07:49:19AM +0100, Jens Axboe wrote:
> > I couldn't find any statiscally meaningful advantage of the
> > optimization with tight fork/exit tests w/ forced ioc creation on
> > fork, which gotta be the most pathological test case for the code
> > path.  So, let's remove the ugly optimization.  If I missed sth, we
> > can resurrect the simpler optimization later.  Jens, this is on top of
> > linus#master without Shaohua's patch.
> 
> OK, then I'm fine with cleaning it up. Applied, thanks Tejun.

Hmmm... how about merging Shaohua's smaller fix first until we figure
out what's going on with the performance regression he's seeing?

Thanks.

-- 
tejun
