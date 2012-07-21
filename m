Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733Ab2GUCDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 22:03:21 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:40244 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993Ab2GUCDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 22:03:20 -0400
Date: Fri, 20 Jul 2012 22:02:58 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, w@1wt.eu,
        ewust@umich.edu, zakir@umich.edu, greg@kroah.com, mpm@selenic.com,
        nadiah@cs.ucsd.edu, jhalderm@umich.edu, tglx@linutronix.de,
        davem@davemloft.net
Subject: Re: [PATCH] dmi: Feed DMI table to /dev/random driver
Message-ID: <20120721020258.GA12898@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu,
	zakir@umich.edu, greg@kroah.com, mpm@selenic.com,
	nadiah@cs.ucsd.edu, jhalderm@umich.edu, tglx@linutronix.de,
	davem@davemloft.net
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
 <0107910@agluck-desktop.sc.intel.com>
 <20120721005610.GB9399@thunk.org>
 <CA+8MBbKroxc1p8+QOhEd6+gn2BD4ymcS7n7SOMR2=aiMW8waqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBbKroxc1p8+QOhEd6+gn2BD4ymcS7n7SOMR2=aiMW8waqA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 06:19:33PM -0700, Tony Luck wrote:
> On Fri, Jul 20, 2012 at 5:56 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> > The other approach was to add some new interface that random.c would
> > call which would grab the dmi data from rand_initialize().  But that's
> > going to be a lot more complicated, so I guess we should go with the
> > simple/stupid approach.
> 
> It wouldn't be all that hard ... we'd just need to add a new entry point
> to the dmi codefor random to call (and a stub somewhere so that
> CONFIG_DMI=n kernels still build). But getting some per-platform
> data into the random pools earlier is a good thing ... it means that
> users of random data will see the benefit earlier than they do now.

Yeah, what makes it tricky is if we wanted to do things in an arch
independent way, since I assume there are architectures out there
which have something which has the same sort of information as the DMI
tables, but which would be something else.  So we'd need to have some
interface which could be defined by each architecture, and a no-op
function for architectures that didn't provide such a thing.

> So add the big fat comment so that people know not to break this
> useful (if not entirely intentional) functionality.

I agree.  Want to send a revised patch with the comment, and I'll drop
it into the random.git tree?

Thanks,

						- Ted

