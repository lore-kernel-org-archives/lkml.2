Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab1DMPKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:10:52 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60437 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961Ab1DMPKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:10:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SrHlCNzsaxnECaUUPDwGOONnbDeXqkP9D+H1N/nZhkEsnSUpFpfJ3ByXDJ5nKtEEM9
         Qg1e/fh+dPmt5IgoHqU/97QZEGBfA1pLFJNLK3edMcYOw1N0UP6cgTMTAmsDfIHTLom7
         p7apBPwSkjpCzCq0U8yBbpWxy5efcg/g597Pg=
Date: Wed, 13 Apr 2011 17:10:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Paul Mundt <lethal@linux-sh.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "v2.6.33.." <stable@kernel.org>
Subject: Re: [PATCH 1/5] ptrace: Prepare to fix racy accesses on task
 breakpoints
Message-ID: <20110413151040.GC2277@nowhere>
References: <1302284067-7860-1-git-send-email-fweisbec@gmail.com>
 <1302284067-7860-2-git-send-email-fweisbec@gmail.com>
 <1302518877.24286.34.camel@e102144-lin.cambridge.arm.com>
 <20110412175437.GC2240@nowhere>
 <1302705258.4214.11.camel@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302705258.4214.11.camel@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 03:34:18PM +0100, Will Deacon wrote:
> > Returning -ERSCH there would mean that the task struct doesn't exist,
> > or something confusing like this. Which is not true: the task exists.
> 
> Sure, we need a way of saying `you can't take a reference to the
> breakpoints for this task' without specifying why. So I guess -ESRCH is
> wrong but I don't know that -1 is correct either (then again, I'm not
> *too* bothered by it :).

-EBUSY perhaps? Well I took -1 by default...

> 
> > OTOH, the caller, which is ptrace, needs to take a decision when he
> > can't take a reference to the breakpoints. The behaviour is
> > to act as if the process does not exist anymore, which is about to
> > happen for real but we anticipate because the task has reached a
> > state in its exiting path where we can't manipulate the breakpoints
> > anymore.
> > 
> > So the rationale behind it is that -ERSCH is an interpretation
> > of the caller.
> > 
> > Right?
> 
> Yup.
> 
> For this and the ARM patch:
> 
> Acked-by: Will Deacon <will.deacon@arm.com>

Great! Thanks!
