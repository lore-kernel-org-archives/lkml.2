Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391Ab1JGUXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 16:23:03 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:53897 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab1JGUXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 16:23:00 -0400
Date: Fri, 7 Oct 2011 23:20:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] trace: cleanup: make some types unsigned
Message-ID: <20111007202004.GI18470@longonot.mountain>
References: <20111007132744.GC31424@elgon.mountain>
 <1317994732.4729.39.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317994732.4729.39.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E8F5FA1.00A7:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 09:38:51AM -0400, Steven Rostedt wrote:
> On Fri, 2011-10-07 at 16:27 +0300, Dan Carpenter wrote:
> > The problem here is that I'm trying to silence a static checker
> > warning.  In replace_preds() we cap n_preds at MAX_FILTER_PRED but
> > we don't check for negative values.  It can't actually be negative
> > values, but the static checkers get confused.
> 
> I really hate to uglify code for the sake of static checkers.
> 
> This code may change in the near future, and the possibility that
> n_preds may become a possibility. Perhaps we should add a:
> 
> WARN_ON(n_preds < 0);
> 
> If in the future the count_preds() changes and incorrectly produces a
> negative number, or perhaps even overflows int, we wont catch it with
> unsigned.

I've sent a couple type changes to silence static checker warnings,
but I haven't been pushing it, because I'm interested to see what
people think about them first.  I didn't think unsigned int was
particularly ugly, but now that you point it out I guess it is
needlessly pedantic and longer to type.  So it's fine if you ignore
the patch.

Please don't add the WARN_ON().  WARN_ON()s are uglier than unsigned
ints.  WARN_ON() don't solve any problems, they just make debugging
the crash easier.  Are we going to crash here, and if so, do we
expect that debugging it will be difficult?  Probably not.

In theory, static checkers should be able to look at this code and
know that n_preds can't overflow.  So yeah.  Let's call this a
static checker bug and move on.

regards,
dan carpenter
