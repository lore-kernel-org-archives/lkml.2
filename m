Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab2LQTJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:09:46 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:46145 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753597Ab2LQTJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:09:44 -0500
Message-ID: <1355771383.13361.44.camel@joe-AO722>
Subject: Re: [PATCH] scripts: add checkmaintainers.py
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Michal Marek <mmarek@suse.cz>, Cesar Eduardo Barros <cesarb@cesarb.net>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Date: Mon, 17 Dec 2012 11:09:43 -0800
In-Reply-To: <1355770579.13361.41.camel@joe-AO722>
References: <1355523576-7596-1-git-send-email-cesarb@cesarb.net>
	 <50CEF080.8010208@suse.cz> <20121217102714.GB31947@liondog.tnic>
	 <1355758544.13361.14.camel@joe-AO722> <20121217170011.GC31866@liondog.tnic>
	 <1355770579.13361.41.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-17 at 10:56 -0800, Joe Perches wrote:
> On Mon, 2012-12-17 at 18:00 +0100, Borislav Petkov wrote:
> > On Mon, Dec 17, 2012 at 07:35:44AM -0800, Joe Perches wrote:
> > > Perhaps Cesar can use his script as a starting point to find those
> > > pattern invalidating commits or maybe add the capability (or a
> > > --strict check) to checkpatch.

> > So, yeah, I can see how checkpatch saying: "you've just renamed a
> > file and thusly invalidated a pattern in MAINTAINERS. Pls, consider
> > correcting the pattern" could make sense. And I would even add it to
> > default functionality since the MAINTAINERS patterns are something we
> > want to always have up-to-date, IMO.
> 
> Maybe something like this:

A trivial correction:

>  scripts/checkpatch.pl |   20 ++++++++++++++++++--
>  1 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -1556,6 +1559,19 @@ sub process {
>  				ERROR("MODIFIED_INCLUDE_ASM",
>  				      "do not modify files in include/asm, change architecture specific files in include/asm-<architecture>\n" . "$here$rawline\n");
>  			}

This needs a new test here to avoid chirping
on files that aren't added, deleted or renamed.

		next if ($realfile eq $modifiedfile);

> +
> +			my $action = "renames $modifiedfile to $realfile";
> +			$action = "creates file $realfile" if ($modifiedfile =~ m@dev/null@);
> +			$action = "deletes file $modifiedfile" if ($realfile =~ m@dev/null@);
> +
> +			CHK("MAINTAINERS",
> +			    "Patch $action, update MAINTAINERS?\n");


