Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268Ab2I2Aml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 20:42:41 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:46439 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758306Ab2I2Amk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 20:42:40 -0400
X-Originating-IP: 217.70.178.139
X-Originating-IP: 50.43.46.74
Date: Fri, 28 Sep 2012 17:42:32 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Bulk] Re: [PATCH 4/10] compiler-gcc{3,4}.h: Use GCC_VERSION
 macro
Message-ID: <20120929004231.GB14293@jtriplet-mobl1>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
 <1348874411-28288-5-git-send-email-daniel.santos@pobox.com>
 <20120929002029.GA13907@jtriplet-mobl1>
 <50664179.5090608@att.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50664179.5090608@att.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 07:31:53PM -0500, Daniel Santos wrote:
> On 09/28/2012 07:20 PM, Josh Triplett wrote:
> > On Fri, Sep 28, 2012 at 06:20:05PM -0500, Daniel Santos wrote:
> >> --- a/include/linux/compiler-gcc4.h
> >> +++ b/include/linux/compiler-gcc4.h
> >> @@ -13,11 +13,11 @@
> >>  #define __must_check 		__attribute__((warn_unused_result))
> >>  #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
> >>  
> >> -#if __GNUC_MINOR__ > 0
> >> +#if GCC_VERSION >= 40102
> >>  # define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
> >>  #endif
> > You've changed the semantics of this one; if literally translated, this
> > should have become #if GCC_VERSION >= 40100.  If you intended to change
> > that, could you please document why?  And in any case, could you make
> > that semantic change in a separate commit from the switch to
> > GCC_VERSION?
> hmm, it looks like somebody commented out the #error that would normally
> prevent that test from ever occurring on 4.1.0 or 4.1.1.
> When I had written this patch, it wasn't commented out and I had assumed
> that it was obvious from the context.

GCC 4.1.0 and 4.1.1 miscompiling __weak has nothing to do with
__compiletime_object_size; why should *this* version check exclude those
versions?

- Josh Triplett
