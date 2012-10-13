Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab2JMJl5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 05:41:57 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:50221 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab2JMJlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 05:41:55 -0400
Date: Sat, 13 Oct 2012 11:41:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-sparse@vger.kernel.org, Ed Cashin <ecashin@coraid.com>,
        Christopher Li <sparse@chrisli.org>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] linux/compiler.h: Add __must_hold macro for functions
	called with a lock held
Message-ID: <20121013094152.GA14763@merkur.ravnborg.org>
References: <20121008020610.GA9197@leaf> <20121009130637.5e61078f.akpm@linux-foundation.org> <20121009203628.GB3616@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121009203628.GB3616@jtriplet-mobl1>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 01:36:28PM -0700, Josh Triplett wrote:
> On Tue, Oct 09, 2012 at 01:06:37PM -0700, Andrew Morton wrote:
> > On Sun, 7 Oct 2012 19:06:10 -0700
> > Josh Triplett <josh@joshtriplett.org> wrote:
> > 
> > > linux/compiler.h has macros to denote functions that acquire or release
> > > locks, but not to denote functions called with a lock held that return
> > > with the lock still held.  Add a __must_hold macro to cover that case.
> > 
> > hum.  How does this work?  Any code examples and sample sparse output? 
> > Does it apply to all lock types, etc?
> 
> It applies to all the same lock types that __acquires and __releases
> apply to: currently everything since Sparse doesn't actually do anything
> with the parameter, just the context value.
> 
> Various code examples already exist in the kernel tree for __acquires
> and __releases, and the mailing list contains many reports of the Sparse
> context warnings.
> 
> Just as __acquires and __release annotate functions that return with a
> lock acquired and get called with a lock that they drop (respectively),
> __must_hold annotates a function called with a lock acquired that return
> with that lock still acquired.
> 
> > IOW, where is all this stuff documented?
> 
> The Sparse manpage documents the context bits reasonably well.  Other
> than that, nowhere that I know of other than the Sparse testsuite and
> the source trees of projects like Linux that use Sparse.

The kernel specific macros should be documented in:

    Documentation/sparse.txt

For now only __bitwise is documentd, but when we introduce new
sparse annotation macros in the kernel the documentation should
be mandatory.

	Sam
