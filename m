Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab2BFR1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 12:27:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44402 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513Ab2BFR1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 12:27:11 -0500
Date: Mon, 6 Feb 2012 09:27:06 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <vivek.goyal2008@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Subject: Re: [patch]block: fix ioc locking warning
Message-ID: <20120206172706.GB21292@google.com>
References: <1328514611.21268.66.camel@sli10-conroe>
 <20120206151219.GC30752@redhat.com>
 <4F2FFB21.9000202@kernel.dk>
 <20120206163721.GF30752@redhat.com>
 <20120206164428.GA21292@google.com>
 <CA+55aFx6BR_ZUHd8d64btu-LzsPHo3Ot_d1-5jJytjQUqvvaiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFx6BR_ZUHd8d64btu-LzsPHo3Ot_d1-5jJytjQUqvvaiQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Feb 06, 2012 at 08:58:49AM -0800, Linus Torvalds wrote:
> On Mon, Feb 6, 2012 at 8:44 AM, Tejun Heo <tj@kernel.org> wrote:
> >
> > Yeah, this seems better to me.  Jens, if you're gonna amend the
> > commit, please consider collapsing the following patch into the
> > original patch too.  Thanks.
> 
> Guys, is it *really* worth it to do all these crazy games?
>
> How bad is it to just always use the async freeing, instead of this
> clearly very fragile crazy direct-freeing-with-serious-locking-issues
> thing?

It's one wq scheduling on exit for any task which has issued an IO.  I
don't think it would matter except for task fork/exit microbenchs (or
workloads which approximate to that).  I'll get some measurements and
strip the optimization if it doesn't really show up.

Thanks.

--
tejun
