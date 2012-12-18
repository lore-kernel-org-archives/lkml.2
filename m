Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab2LRS2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 13:28:45 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49105 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab2LRS2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 13:28:41 -0500
Date: Tue, 18 Dec 2012 19:28:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: Joe Perches <joe@perches.com>
Cc: Michal Marek <mmarek@suse.cz>, Cesar Eduardo Barros <cesarb@cesarb.net>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] scripts: add checkmaintainers.py
Message-ID: <20121218182838.GF31255@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Joe Perches <joe@perches.com>, Michal Marek <mmarek@suse.cz>,
	Cesar Eduardo Barros <cesarb@cesarb.net>,
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Howells <dhowells@redhat.com>
References: <1355523576-7596-1-git-send-email-cesarb@cesarb.net>
 <50CEF080.8010208@suse.cz>
 <20121217102714.GB31947@liondog.tnic>
 <1355758544.13361.14.camel@joe-AO722>
 <20121217170011.GC31866@liondog.tnic>
 <1355770579.13361.41.camel@joe-AO722>
 <1355771383.13361.44.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1355771383.13361.44.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 11:09:43AM -0800, Joe Perches wrote:
> This needs a new test here to avoid chirping
> on files that aren't added, deleted or renamed.
> 
> 		next if ($realfile eq $modifiedfile);

Hmm, I don't think that catches file renames when using the normal 'git
diff' output:

$ git mv README README.old

And this detection should work in the default case with a pre-commit
hook. For example, I have this in .git/hooks/pre-commit:

if git rev-parse --verify HEAD >/dev/null 2>&1
then
        against=HEAD
else
        # Initial commit: diff against an empty tree object
        against=4b825dc642cb6eb9a060e54bf8d69288fbee4904
fi

git diff --cached $against -- | ./scripts/checkpatch.pl --strict --no-signoff -

and when I do this, I get the changes checked:

$ git commit -a
README.old:5: trailing whitespace.
+kernel, and what to do if something goes wrong. 
README.old:19: trailing whitespace.
+  accompanying COPYING file for more details. 
README.old:47: trailing whitespace.
+   these typically contain kernel-specific installation notes for some 
README.old:287: trailing whitespace.
+ - Keep a backup kernel handy in case something goes wrong.  This is 
README.old:301: trailing whitespace.
+   to the place where your regular bootable kernel is found. 
README.old:314: trailing whitespace.
+   Reinstalling LILO is usually a matter of running /sbin/lilo. 
README.old:317: trailing whitespace.
+   work.  See the LILO docs for more information. 
README.old:325: trailing whitespace.
+   recompile the kernel to change these parameters. 
README.old:327: trailing whitespace.
+ - Reboot with the new kernel and enjoy. 
README.old:394: trailing whitespace.
+   interesting one. 
README.old:412: new blank line at EOF.

but not the MAINTAINERS check.

git diff --cached HEAD gives:

diff --git a/README b/README.old
similarity index 100%
rename from README
rename to README.old

so I'd say we're almost there.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
