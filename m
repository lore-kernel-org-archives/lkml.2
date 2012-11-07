Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab2KGJkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:40:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51804 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab2KGJkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:40:16 -0500
Date: Wed, 7 Nov 2012 09:40:06 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Adil Mujeeb <mujeeb.adil@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 3/3] checkpatch: Emit an warning when floating point
 values are used
Message-ID: <20121107094006.GE3066@dm>
References: <cover.1351736873.git.joe@perches.com>
 <359a78054bc0dfaedede95222781b4177d3c33ce.1351736873.git.joe@perches.com>
 <20121106153625.c48ba1f1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121106153625.c48ba1f1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 03:36:25PM -0800, Andrew Morton wrote:
> On Thu,  1 Nov 2012 00:12:18 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > Linux kernel doesn't like floating point, say so.
> > 
> > ...
> >
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
> 
> In particular, I don't see a problem with people doing
> 
> 	int foo = 1.1 * 2.2;

I thought there was also now a way to enable floats in kernel space and
some use thereof.

-apw
