Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab2LSPHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 10:07:43 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60250 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab2LSPHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 10:07:36 -0500
Date: Wed, 19 Dec 2012 16:07:32 +0100
From: Borislav Petkov <bp@alien8.de>
To: Joe Perches <joe@perches.com>
Cc: Michal Marek <mmarek@suse.cz>, Cesar Eduardo Barros <cesarb@cesarb.net>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] scripts: add checkmaintainers.py
Message-ID: <20121219150732.GD24895@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Joe Perches <joe@perches.com>, Michal Marek <mmarek@suse.cz>,
	Cesar Eduardo Barros <cesarb@cesarb.net>,
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Howells <dhowells@redhat.com>
References: <1355758544.13361.14.camel@joe-AO722>
 <20121217170011.GC31866@liondog.tnic>
 <1355770579.13361.41.camel@joe-AO722>
 <1355771383.13361.44.camel@joe-AO722>
 <20121218182838.GF31255@liondog.tnic>
 <1355859281.30366.29.camel@joe-AO722>
 <20121218203159.GI31255@liondog.tnic>
 <1355862997.30366.36.camel@joe-AO722>
 <20121218204716.GJ31255@liondog.tnic>
 <1355866399.3297.2.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1355866399.3297.2.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 01:33:19PM -0800, Joe Perches wrote:
> On Tue, 2012-12-18 at 21:47 +0100, Borislav Petkov wrote:
> > Oh well, enough games for today.
> 
> Maybe try this tomorrow?

$ git diff --cached HEAD -- | ./scripts/checkpatch.pl --strict -
Use of uninitialized value $herecurr in concatenation (.) or string at ./scripts/checkpatch.pl line 1333.
CHECK: Patch renames arch/x86/Kconfig to arch/x86/Kconfig.old, update MAINTAINERS?

yes, except the warning.

$ git commit -a
arch/x86/Kconfig.old:451: trailing whitespace.
+         Internet Device(MID) platform.

This doesn't seem to work although I have the same pre-commit hook as
the above line: " git diff --cached HEAD -- | ./scripts/checkpatch.pl --strict -"

$ git diff --cached HEAD
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig.old
similarity index 100%
rename from arch/x86/Kconfig
rename to arch/x86/Kconfig.old

and this is probably the reason - you said checkpatch needs an unified
diff after the initial lines.

So this is getting closer except checkpatch needs to still warn in the
case where there's no unified diff following *but* a single file rename.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
