Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab2BGA7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 19:59:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38765 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab2BGA7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 19:59:05 -0500
Date: Mon, 6 Feb 2012 16:59:00 -0800
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Subject: Re: [patch]block: fix ioc locking warning
Message-ID: <20120207005900.GF21292@google.com>
References: <20120206151219.GC30752@redhat.com>
 <4F2FFB21.9000202@kernel.dk>
 <20120206163721.GF30752@redhat.com>
 <20120206164428.GA21292@google.com>
 <CA+55aFx6BR_ZUHd8d64btu-LzsPHo3Ot_d1-5jJytjQUqvvaiQ@mail.gmail.com>
 <20120206172706.GB21292@google.com>
 <20120206203604.GC21292@google.com>
 <CANejiEVzs=pUhQSTvUppkDcc2TNZyfohBRLygW5zFmXyk5A-xQ@mail.gmail.com>
 <20120207003948.GE21292@google.com>
 <1328575430.21268.69.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328575430.21268.69.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 08:43:50AM +0800, Shaohua Li wrote:
> Quite simple, copy kernel source to tmpfs in tight memory environment.
> This will trigger swap. The bisection result appears stable.

Looked through the commit again but it really doesn't change fast
paths.  The only paths which can be slower are ioc and q exits.  Can
you please do the followings?

* Share the script used for microbench.  Maybe it somehow exposes
  slower exit path?  How much regression are we talking about?

* Test with the this_q != locked_q trylock patch.

Thanks.

-- 
tejun
