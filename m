Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173Ab2KNWQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 17:16:27 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:41322 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933152Ab2KNWQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 17:16:26 -0500
Date: Wed, 14 Nov 2012 17:15:44 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scatterlist: don't BUG when we can trivially return a
 proper error.
Message-ID: <20121114221544.GA3083@elliptictech.com>
References: <1351796580-20600-1-git-send-email-nbowler@elliptictech.com>
 <20121114130500.250dd5b8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121114130500.250dd5b8.akpm@linux-foundation.org>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-14 13:05 -0800, Andrew Morton wrote:
> On Thu,  1 Nov 2012 15:03:00 -0400
> Nick Bowler <nbowler@elliptictech.com> wrote:
> 
> > There is absolutely no reason to crash the kernel when we have a
> > perfectly good return value already available to use for conveying
> > failure status.
> 
> Yes, I suppose that's true.  I don't see a case for BUGging the kernel
> here.
[...]
> > -	BUG_ON(nents > max_ents);
> > +	if (WARN_ON_ONCE(nents > max_ents))
> > +		return -E2BIG;
> >  #endif
> 
> OK, pet peeve: if this E2BIG gets returned to userspace, our poor user
> will look it up and see "Argument list too long; used when the
> arguments passed to a new program being executed with one of the exec
> functions occupy too much memory space".  He then gets to spend half a
> day reviewing his code's exec() callsites!
> 
> See?  Although the error's name sounds like a nice match to the
> internal state, it isn't really a match at all and our use of it is
> misleading.
> 
> Unfortunately there is no EKERNELSCREWEDUP,

Well, maybe we should add it! :P

> so we usually use EINVAL.

Fair enough.  I will prepare v2.  But perhaps EOPNOTSUPP would be a
better fit?

Thanks,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
