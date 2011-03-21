Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1CUKRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 06:17:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:37672 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab1CUKRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 06:17:51 -0400
Date: Mon, 21 Mar 2011 11:17:49 +0100
From: Michal Marek <mmarek@suse.cz>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, bp@alien8.de, dot@dotat.at,
        mikew@google.com, randy.dunlap@oracle.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [GIT] kbuild core updates for 2.6.39-rc1
Message-ID: <20110321101749.GA5228@sepie.suse.cz>
References: <20110319085802.GA18336@sepie.suse.cz>
 <AANLkTin5vYaU83K0YOdD1OgCS24LA8XBSvNfmGFnjhGF@mail.gmail.com>
 <20110321074748.GF27124@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110321074748.GF27124@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 08:47:48AM +0100, Uwe Kleine-König wrote:
> On Sun, Mar 20, 2011 at 05:53:24PM -0700, Linus Torvalds wrote:
> > On Sat, Mar 19, 2011 at 1:58 AM, Michal Marek <mmarek@suse.cz> wrote:
> > >
> > > * Section mismatch analysis enabled by default
> > >  - there are only a few warnings for defconfig builds,
> > >    all{yes,mod}config still has a lot of them. Depending on the general
> > >    perception of this change, we might disable it later in the rc phase
> > >    again.
> > 
> > No.
> > 
> > We don't enable stuff like this by default. Not when it actually
> > changes some really fundamental compiler flags, and thus the whole "we
> > can disable it late in -rc again" is a totally broken option, since if
> > we have any compiler issues, we'd want to know it early.

OK, point taken.


> Michal, do you want just remove the default y and squash it into the
> commit?

I'm about to add this to the kbuild branch. Linus, would you pull such
version?

From: Michal Marek <mmarek@suse.cz>
Subject: [PATCH] kbuild: Make DEBUG_SECTION_MISMATCH selectable, but not on by default

CONFIG_DEBUG_SECTION_MISMATCH has also runtime effects due to the
-fno-inline-functions-called-once compiler flag, so forcing it on
everyone is not a good idea.

Signed-off-by: Michal Marek <mmarek@suse.cz>

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8b6a4f1..5a24805 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -102,7 +102,6 @@ config HEADERS_CHECK
 
 config DEBUG_SECTION_MISMATCH
 	bool "Enable full Section mismatch analysis"
-	default y
 	help
 	  The section mismatch analysis checks if there are illegal
 	  references from one section to another section.

Michal
