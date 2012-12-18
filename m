Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab2LRUgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 15:36:41 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:54046 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753678Ab2LRUgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 15:36:37 -0500
Message-ID: <1355862997.30366.36.camel@joe-AO722>
Subject: Re: [PATCH] scripts: add checkmaintainers.py
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Michal Marek <mmarek@suse.cz>, Cesar Eduardo Barros <cesarb@cesarb.net>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Date: Tue, 18 Dec 2012 12:36:37 -0800
In-Reply-To: <20121218203159.GI31255@liondog.tnic>
References: <1355523576-7596-1-git-send-email-cesarb@cesarb.net>
	 <50CEF080.8010208@suse.cz> <20121217102714.GB31947@liondog.tnic>
	 <1355758544.13361.14.camel@joe-AO722> <20121217170011.GC31866@liondog.tnic>
	 <1355770579.13361.41.camel@joe-AO722> <1355771383.13361.44.camel@joe-AO722>
	 <20121218182838.GF31255@liondog.tnic> <1355859281.30366.29.camel@joe-AO722>
	 <20121218203159.GI31255@liondog.tnic>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-18 at 21:31 +0100, Borislav Petkov wrote:
> On Tue, Dec 18, 2012 at 11:34:41AM -0800, Joe Perches wrote:
> > If no patch is attached, you should get
> >
> > ERROR: Does not appear to be a unified-diff format patch
> 
> Well, it needs to handle the case where a patch simply and only renames
> a file.
> 
> Then, even if a patch follows:
> 
> diff --git a/README b/README.old
> similarity index 99%
> rename from README
> rename to README.old
> index a24ec89ba442..b0a7aa56c3cc 100644
> --- a/README
> +++ b/README.old
> @@ -1,3 +1,6 @@
> +TEST
> +
> +
>          Linux kernel release 3.x <http://kernel.org/>
>  
>  These are the release notes for Linux version 3.  Read them carefully,
> --
> 
> it says:
> 
> $ git diff --cached HEAD -- | ./scripts/checkpatch.pl --strict -
> Must be run from the top-level dir. of a kernel tree
> 
> If I comment out the following hunk:
> 
>         if (!defined $root) { 
>                 print "Must be run from the top-level dir. of a kernel tree\n";
>                 exit(2);
>         }
> 
> then it works, albeit with a bunch of warnings:
> 
> Use of uninitialized value $root in concatenation (.) or string at ./scripts/checkpatch.pl line 1558.
> Use of uninitialized value $root in concatenation (.) or string at ./scripts/checkpatch.pl line 1558.
> Use of uninitialized value $root in concatenation (.) or string at ./scripts/checkpatch.pl line 1304.
> Use of uninitialized value $root in concatenation (.) or string at ./scripts/checkpatch.pl line 1304.
> Use of uninitialized value $root in concatenation (.) or string at ./scripts/checkpatch.pl line 1304.
> Use of uninitialized value $root in concatenation (.) or string at ./scripts/checkpatch.pl line 1304.
> Use of uninitialized value $root in concatenation (.) or string at ./scripts/checkpatch.pl line 1304.
> Use of uninitialized value $root in concatenation (.) or string at ./scripts/checkpatch.pl line 1304.
> CHECK: Patch renames README to README.old, update MAINTAINERS?

You renamed README which is one of the filenames used
when checkpatch verifies the top-level dir kernel tree.

Don't do that, README is a required filename.

Try another file in drivers or somewhere other than root.


