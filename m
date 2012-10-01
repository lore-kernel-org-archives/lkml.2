Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab2JAAWZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 20:22:25 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43833 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab2JAAWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 20:22:24 -0400
X-Originating-IP: 217.70.178.130
X-Originating-IP: 50.43.46.74
Date: Sun, 30 Sep 2012 17:22:13 -0700
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
        Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 3/10] compiler-gcc.h: Add gcc-recommended GCC_VERSION
 macro
Message-ID: <20121001002213.GA16784@leaf>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
 <1348874411-28288-4-git-send-email-daniel.santos@pobox.com>
 <5068D185.9000802@att.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5068D185.9000802@att.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2012 at 06:11:01PM -0500, Daniel Santos wrote:
> So in light of feedback I've been getting on this patch set, it leaves
> me with
> this question.
> > +#define GCC_VERSION (__GNUC__ * 10000 \
> > +		   + __GNUC_MINOR__ * 100 \
> > +		   + __GNUC_PATCHLEVEL__)
> This macro presumes you are using gcc 3.0 or later, which introduced the
> __GNUC_PATCHLEVEL__ predefined macro.  Should you be using a version of gcc
> prior to 3.0 (where the macro is undefined), you would get an error that
> __GNUC_PATCHLEVEL__ is undefined prior to getting the error trying to
> include
> "linux/compiler-gcc2.h".  So it presumes the compiler is 3.0+, when another
> part of the code may allow it from a future change.  Should it be
> modified to
> do account for this or would that be overkill?

Overkill, since Linux requires GCC 3.2 or newer.  From compiler-gcc3.h:

#if __GNUC_MINOR__ < 2
# error Sorry, your compiler is too old - please upgrade it.
#endif

- Josh Triplett
