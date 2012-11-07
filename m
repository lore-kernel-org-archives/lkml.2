Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab2KGLJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 06:09:47 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:40112 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754641Ab2KGLJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 06:09:45 -0500
Message-ID: <1352286575.4164.2.camel@joe-AO722>
Subject: Re: [PATCH V2 3/3] checkpatch: Emit an warning when floating point
 values are used
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, Adil Mujeeb <mujeeb.adil@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Date: Wed, 07 Nov 2012 03:09:35 -0800
In-Reply-To: <20121106153625.c48ba1f1.akpm@linux-foundation.org>
References: <cover.1351736873.git.joe@perches.com>
	 <359a78054bc0dfaedede95222781b4177d3c33ce.1351736873.git.joe@perches.com>
	 <20121106153625.c48ba1f1.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-06 at 15:36 -0800, Andrew Morton wrote:
> On Thu,  1 Nov 2012 00:12:18 -0700
> Joe Perches <joe@perches.com> wrote:
> > Linux kernel doesn't like floating point, say so. 
[]
> > --- a/scripts/checkpatch.pl
> > +++ b/scripts/checkpatch.pl
> > @@ -2332,6 +2332,13 @@ sub process {
> >  			     "do not add new typedefs\n" . $herecurr);
> >  		}
> >  
> > +# check for floating point constants
> > +
> > +		if ($line =~ /\b$Float\b/) {
> > +			WARN("KERNEL_FLOAT",
> > +			     "Floating point is not supported in linux kernel source\n" . $herecurr);
> > +		}
> > +
> >  # * goes on variable not on type
> >  		# (char*[ const])
> >  		while ($line =~ m{(\($NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)\))}g) {
> 
> The earlier review comments were not addressed.

You didn't read my response in the thread then.
I "addressed" it by saying that the problem exists
without solution.

> In particular, I don't see a problem with people doing
> 
> 	int foo = 1.1 * 2.2;

Neither do I but I know of no way to determine that any
calc is a constant.

