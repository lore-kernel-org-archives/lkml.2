Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab1E0Mk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:40:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39801 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996Ab1E0Mk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:40:26 -0400
Date: Fri, 27 May 2011 14:40:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] x86, UV: Reformat uv_mmrs.h - no code changes
Message-ID: <20110527124017.GA2126@elte.hu>
References: <20110512133308.GA17113@sgi.com>
 <20110513124029.GB3924@elte.hu>
 <20110525161634.GA13451@sgi.com>
 <20110525204523.GA28397@elte.hu>
 <20110526171710.GA8056@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526171710.GA8056@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jack Steiner <steiner@sgi.com> wrote:

> No code changes.  Reformat file to eliminate errors caught
> by checkpatch.pl
> 
> Signed-off-by: Jack Steiner <steiner@sgi.com>
> 
> ---
> V2 - this patch applies on top of "[PATCH] x86, UV: Support for SGI UV2 hub chip".
> 
> I fixed alignment of comments in the structure definitions. All checkpatch.pl
> ERRORS & WARNINGS are also fixed.
> 
> Some of the symbol names are still quite long. The file is based on post-processing
> of verilog definitions that are used for the node controller chip design. Although
> some symbol names are not what I would chose, I would like to maintain compatibility
> with the names used by the chip designers. We have a number of cross-reference
> utilities & having common names is important. Hope this is ok...
> 
> V3 - Aligned comments and most field definitions & values. Also sorted the
> #defines for the SHIFT & MASK values for each MMR. This make the file visually
> much more acceptible.

It looks better now, but one final detail i can still see is that 
this feedback i gave in the uv_tlb.c discussion still applies:

 - In uv_bau.h there's no need to break the comment lines in such an
   ugly way:

        unsigned long   s_ntarglocals;          /* targets of cpus on the local
                                                   blade */

   Just leave the comment in a single line! It's not a problem to
   have lines longer than 80 cols - length up to 100 colums is fine
   in such cases. The place where we frown upon too long lines is
   *code*, because there the too long lines indicate various
   structural problems.

I hindsight you were not Cc:-ed so you probably didnt see it? Below 
is the whole mail i wrote to Cliff.

So there's still many lines that are needlessly broken. The point is 
*NOT* to make checkpatch happy, but to make any random developer who 
looks at that file happy.

Also, could you please use a more informative changelog like:

---------------------------->
Subject: x86, UV: Clean up uv_mmrs.h
From: Jack Steiner <steiner@sgi.com>
Date: Thu, 26 May 2011 12:17:10 -0500

No code changes. Reformat definitions to make it more readable.

I fixed alignment of comments in the structure definitions.

Also aligned comments and most field definitions & values. Also
sorted the defines for the SHIFT & MASK values for each MMR. This
make the file visually much more acceptable.

Some of the symbol names are still quite long. The file is based on
post-processing of verilog definitions that are used for the node
controller chip design. Although some symbol names are not what I
would chose, I would like to maintain compatibility with the names
used by the chip designers. We have a number of cross-reference
utilities & having common names is important.
<----------------------------

(i changed the title as well)

Thanks,

	Ingo

----- Forwarded message from Ingo Molnar <mingo@elte.hu> -----

Date: Wed, 25 May 2011 14:32:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v6] x86: UV uv_tlb.c cleanup


* Cliff Wickman <cpw@sgi.com> wrote:

> General readability cleanup of tlb_uv.c. Now:

Ok, so this is clearly a big step forward so i've applied it and 
started testing it - hopefully we can work with small patches from 
now on.

I looked at uv_bau.h and tlb_uv.c and there's still sporadic 
problems:

 - Found at least one non-standard multi-line comment

 - Found at least one case where local variables were not followed by 
   an extra empty line

 - Sentences within comments are not capitalized consisently - some 
   start properly capitalized, some not.

 - In uv_bau.h there's no need to break the comment lines in such an 
   ugly way:

        unsigned long   s_ntarglocals;          /* targets of cpus on the local
                                                   blade */

   Just leave the comment in a single line! It's not a problem to 
   have lines longer than 80 cols - length up to 100 colums is fine 
   in such cases. The place where we frown upon too long lines is 
   *code*, because there the too long lines indicate various 
   structural problems.

 - There's still obscenely long field names such as
   socket_acknowledge_count. Why isnt that sock_ack_count? Note, 
   there's other such places, please try to find them an improve them
   where possible sanely. If you think there's no sane short name 
   available then obviously we want to live with the long name.

There might be other, easily noticeable problem in the file - please 
look yourself and try to improve it instead of forcing me to do this 
for you.

Thanks,

	Ingo
