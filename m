Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030443Ab2I2BEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 21:04:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21229 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030216Ab2I2BEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 21:04:38 -0400
X-Authority-Analysis: v=2.0 cv=Hsb06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=CzhNhiOeKFUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=mtZY8E7kI-gA:10 a=ybZZDoGAAAAA:8 a=bU3p2L20sEzuArcpNXAA:9 a=PUjeQqilurYA:10 a=qIVjreYYsbEA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1348880675.22822.102.camel@gandalf.local.home>
Subject: Re: [PATCH 6/10] bug.h: Replace __linktime_error with
 __compiletime_error
From: Steven Rostedt <rostedt@goodmis.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Daniel Santos <daniel.santos@pobox.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 28 Sep 2012 21:04:35 -0400
In-Reply-To: <20120929002353.GC13907@jtriplet-mobl1>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
	 <1348874411-28288-7-git-send-email-daniel.santos@pobox.com>
	 <20120929002353.GC13907@jtriplet-mobl1>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-28 at 17:23 -0700, Josh Triplett wrote:
> On Fri, Sep 28, 2012 at 06:20:07PM -0500, Daniel Santos wrote:
> > Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
> > ---
> >  include/linux/bug.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/linux/bug.h b/include/linux/bug.h
> > index aaac4bb..298a916 100644
> > --- a/include/linux/bug.h
> > +++ b/include/linux/bug.h
> > @@ -73,7 +73,7 @@ extern int __build_bug_on_failed;
> >  #define BUILD_BUG()						\
> >  	do {							\
> >  		extern void __build_bug_failed(void)		\
> > -			__linktime_error("BUILD_BUG failed");	\
> > +			__compiletime_error("BUILD_BUG failed");\
> >  		__build_bug_failed();				\
> >  	} while (0)
> 
> This change should either occur as part of patch 5 or before patch 5,
> not after.

I noticed the same thing and was about to comment on it.

Please do not break bisectablity. All your patches should compile and
run at every step.

-- Steve


