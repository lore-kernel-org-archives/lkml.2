Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab1AIPKq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 10:10:46 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:55738 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab1AIPKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 10:10:44 -0500
Date: Sun, 9 Jan 2011 16:10:41 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        linux arch <linux-arch@vger.kernel.org>,
        Guan Xuetao <guanxuetao@mprc.pku.edu.cn>,
        Michal Marek <mmarek@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 1/2] kbuild: asm-generic support
Message-ID: <20110109151041.GA17237@merkur.ravnborg.org>
References: <20110108130302.GA21698@merkur.ravnborg.org> <20110109082851.GA10463@merkur.ravnborg.org> <20110109083125.GA17045@merkur.ravnborg.org> <201101091503.34783.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101091503.34783.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 09, 2011 at 03:03:33PM +0100, Arnd Bergmann wrote:
> Hi Sam,
> 
> Looks much cleaner to me now, but I still don't see why we even need
> the new generic-export-y variable in addition to export-y. Can't we
> just simply install all $(filter-out, $(generated-y), $(header-y))
> from arch/$(SRCARCH)/include/asm and all $(filter, $(generated-y),
> $(header-y)) from rch/$(SRCARCH)/include/generated/asm?

Like this:

diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index 3a630c2..7c06dcf 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -31,10 +31,10 @@ check-file    := $(install)/.check
 # generic-export-y list all generic headers to be exported
 # generic-y list all files an architecture uses from asm-generic
 # Use this to build a list of headers which require a wrapper
-wrapper-files := $(filter $(generic-export-y), $(generic-y))
+wrapper-files := $(filter $(header-y), $(generic-y))
 
 # all headers files for this dir
-header-y      := $(filter-out $(wrapper-files), $(header-y))
+header-y      := $(filter-out $(generic-y), $(header-y))
 all-files     := $(header-y) $(objhdr-y) $(generic-y)
 input-files   := $(addprefix $(_src)/,$(header-y)) \
                  $(addprefix $(objtree)/$(obj)/,$(objhdr-y))


And then reverting the changes to Kbuild.asm.
Yes this works - and is much simpler. Good!

I originally wanted to know wat set of files I worked
with but this is not needed.

I will test it a bit more tonight and post a v3 of the patchset.

Thanks for the review!

	Sam
