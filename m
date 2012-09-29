Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310Ab2I2Aux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 20:50:53 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:58258 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759228Ab2I2Auv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 20:50:51 -0400
X-Originating-IP: 217.70.178.147
X-Originating-IP: 50.43.46.74
Date: Fri, 28 Sep 2012 17:50:43 -0700
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
Subject: Re: [PATCH 7/10] compiler{,-gcc4}.h: Introduce __flatten function
 attribute
Message-ID: <20120929005043.GD14293@jtriplet-mobl1>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
 <1348874411-28288-8-git-send-email-daniel.santos@pobox.com>
 <20120929002626.GD13907@jtriplet-mobl1>
 <50664308.6020601@att.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50664308.6020601@att.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 07:38:32PM -0500, Daniel Santos wrote:
> On 09/28/2012 07:26 PM, Josh Triplett wrote:
> > On Fri, Sep 28, 2012 at 06:20:08PM -0500, Daniel Santos wrote:
> >> --- a/include/linux/compiler-gcc4.h
> >> +++ b/include/linux/compiler-gcc4.h
> >> @@ -15,7 +15,12 @@
> >>  
> >>  #if GCC_VERSION >= 40102
> >>  # define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
> >> -#endif
> >> +
> >> +/* flatten introduced in 4.1, but broken in 4.6.0 (gcc bug #48731)*/
> >> +# if GCC_VERSION != 40600
> >> +#  define __flatten __attribute__((flatten))
> >> +# endif
> >> +#endif /* GCC_VERSION >= 40102 */
> > Same comment as before: why 40102 rather than 40100?
> Again, I'm presuming building with 4.1.0 or 4.1.1 will always have the
> build broken earlier.  I don't have any objections to changing this, but
> it would seem that the issue with the __weak attribute needs to be resolved.

That issue doesn't relate to __flatten, though; it only relates to
__weak.  Since __flatten (and __compiletime_object_size) will work fine
on 4.1.0 and 4.1.1, don't exclude them just because the definition for
__weak elsewhere in the file excludes them.  That just makes it harder
for anyone who might want to work on the issue with __weak.

- Josh Triplett
