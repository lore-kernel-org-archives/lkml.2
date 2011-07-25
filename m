Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab1GYNhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 09:37:51 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:56083 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab1GYNht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 09:37:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap0EAHRwLU5bdWOb/2dsb2JhbAA0AQEEATgBJyUFDAwOBAY6FAEqAxAaF6hOiHwCwA+FYF8Eo1I
X-IronPort-AV: E=Sophos;i="4.67,261,1309730400"; 
   d="scan'208";a="863070522"
Date: Mon, 25 Jul 2011 15:37:46 +0200
From: =?iso-8859-1?Q?V=EDctor_M=2E_J=E1quez_L=2E?= <vjaquez@igalia.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Jianbin Kang <kjbmail@gmail.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] kbuild: incremental tags updating with GNU GLOBAL
Message-ID: <20110725133746.GD15684@lit.local.igalia.com>
References: <1310379990-4367-1-git-send-email-vjaquez@igalia.com>
 <4E1AE9E2.2000603@suse.cz>
 <20110711131725.GA26907@lit.local.igalia.com>
 <20110725132040.GE4482@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110725132040.GE4482@sepie.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 03:20:40PM +0200, Michal Marek wrote:
> On Mon, Jul 11, 2011 at 03:17:25PM +0200, Víctor M. Jáquez L. wrote:
> > On Mon, Jul 11, 2011 at 02:17:38PM +0200, Michal Marek wrote:
> > > On 11.7.2011 12:26, Víctor Manuel Jáquez Leal wrote:
> > > >Instead of generating the tag database each time the target is ran, is better
> > > >just update incrementally the database. It will expend less time.
> > > >
> > > >Signed-off-by: Víctor Manuel Jáquez Leal<vjaquez@igalia.com>
> > > >---
> > > >  scripts/tags.sh |    6 +++++-
> > > >  1 files changed, 5 insertions(+), 1 deletions(-)
> > > >
> > > >diff --git a/scripts/tags.sh b/scripts/tags.sh
> > > >index 75c5d24..6a2fedc 100755
> > > >--- a/scripts/tags.sh
> > > >+++ b/scripts/tags.sh
> > > >@@ -116,7 +116,11 @@ docscope()
> > > >
> > > >  dogtags()
> > > >  {
> > > >-	all_sources | gtags -f -
> > > >+	if global -p; then
> > > >+		global -u
> > > >+	else
> > > >+		all_sources | gtags -f -
> > > >+	fi
> > > 
> > > Will this handle new source files properly?
> > 
> > I ran a quick test and yes, it does.
> 
> I installed global and tried it myself:

Thanks a lot for the review and the testing!

> 1) The first 'make gtags' run prints a rather confusing message (fixable)
>  $ make gtags
>    GEN     gtags
>    global: GTAGS not found.
>  $

yep, I guess a 2>&1 > /dev/null could do it

> 2) A second run indexes the _whole_ tree, including everything under
> arch/. The point of the tags.sh script is that it indexes only files
> relevant to the current architecture. If someone wants to index the
> whole tree, they can run global directly.

nice catch! 

Well, that makes this patch a bit pointless :( 

Thanks again for the review and sorry for noise.

vmjl
