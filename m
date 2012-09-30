Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab2I3NWi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 09:22:38 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56905 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab2I3NWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 09:22:35 -0400
Date: Sun, 30 Sep 2012 15:22:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Daniel Santos <daniel.santos@pobox.com>,
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
Subject: Re: [PATCH 6/10] bug.h: Replace __linktime_error with
 __compiletime_error
Message-ID: <20120930132233.GB15400@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Daniel Santos <daniel.santos@pobox.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Andi Kleen <ak@linux.intel.com>,
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
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
 <1348874411-28288-7-git-send-email-daniel.santos@pobox.com>
 <20120929002353.GC13907@jtriplet-mobl1>
 <1348880675.22822.102.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348880675.22822.102.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 09:04:35PM -0400, Steven Rostedt wrote:
> On Fri, 2012-09-28 at 17:23 -0700, Josh Triplett wrote:
> > On Fri, Sep 28, 2012 at 06:20:07PM -0500, Daniel Santos wrote:
> > > Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
> > > ---
> > >  include/linux/bug.h |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/include/linux/bug.h b/include/linux/bug.h
> > > index aaac4bb..298a916 100644
> > > --- a/include/linux/bug.h
> > > +++ b/include/linux/bug.h
> > > @@ -73,7 +73,7 @@ extern int __build_bug_on_failed;
> > >  #define BUILD_BUG()						\
> > >  	do {							\
> > >  		extern void __build_bug_failed(void)		\
> > > -			__linktime_error("BUILD_BUG failed");	\
> > > +			__compiletime_error("BUILD_BUG failed");\
> > >  		__build_bug_failed();				\
> > >  	} while (0)
> > 
> > This change should either occur as part of patch 5 or before patch 5,
> > not after.
> 
> I noticed the same thing and was about to comment on it.
> 
> Please do not break bisectablity. All your patches should compile and
> run at every step.

And while we're at it, every patch upstream should have a commit message
explaining why this is done. No matter how trivial it is, because after
a sufficient amount of time passes, everyone tends to forget why this
has been done.

Thanks.

-- 
Regards/Gruss,
    Boris.
