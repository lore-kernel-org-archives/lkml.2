Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab0I3UYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 16:24:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:53923 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab0I3UY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 16:24:29 -0400
Date: Thu, 30 Sep 2010 22:24:28 +0200
From: Michal Marek <mmarek@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: build warning after merge of the kbuild tree
Message-ID: <20100930202428.GB25629@sepie.suse.cz>
References: <20100930105222.d1dd6606.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930105222.d1dd6606.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 10:52:22AM +1000, Stephen Rothwell wrote:
> After merging the kbuild tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> In file included from scripts/kconfig/zconf.tab.c:2485:
> scripts/kconfig/symbol.c: In function 'sym_expand_string_value':
> scripts/kconfig/symbol.c:881: warning: ignoring return value of 'realloc', declared with attribute warn_unused_result
> 
> Introduced by commit 76a540958af5390a94b7f68c46cb7f2aed34ccf1 ("kconfig:
> add a symbol string expansion helper").

Thanks a lot for spotting it, fixed with

From: Michal Marek <mmarek@suse.cz>
Subject: kconfig: Fix realloc usage()

Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/kconfig/symbol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index dc5dcf2..c0efe10 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -878,7 +878,7 @@ const char *sym_expand_string_value(const char *in)
 		newlen = strlen(res) + strlen(symval) + strlen(src);
 		if (newlen > reslen) {
 			reslen = newlen;
-			realloc(res, reslen);
+			res = realloc(res, reslen);
 		}
 
 		strcat(res, symval);

Actually dealing with OOM condition would be another patch, right now
most of kconfig ignores it.

Michal
