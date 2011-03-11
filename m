Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482Ab1CKFrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 00:47:20 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:40450 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab1CKFrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 00:47:18 -0500
Date: Fri, 11 Mar 2011 06:47:15 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] kbuild: reenable section mismatch analysis
Message-ID: <20110311054715.GA32246@merkur.ravnborg.org>
References: <20110216200734.GA25184@merkur.ravnborg.org> <1298062040-2774-1-git-send-email-u.kleine-koenig@pengutronix.de> <20110310164100.5af81e3b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110310164100.5af81e3b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 04:41:00PM -0800, Andrew Morton wrote:
> On Fri, 18 Feb 2011 21:47:20 +0100
> Uwe Kleine-K__nig  <u.kleine-koenig@pengutronix.de> wrote:
> 
> > This was disabled in commit
> > 
> > 	e5f95c8 (kbuild: print only total number of section mismatces found)
> > 
> > because there were too many warnings.  Now we're down to a reasonable
> > number again, so we start scaring people with the details.
> > 
> > Signed-off-by: Uwe Kleine-K__nig <u.kleine-koenig@pengutronix.de>
> > ---
> >  lib/Kconfig.debug |    4 ----
> >  1 files changed, 0 insertions(+), 4 deletions(-)
> > 
> > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > index 2b97418..0f77ed1 100644
> > --- a/lib/Kconfig.debug
> > +++ b/lib/Kconfig.debug
> > @@ -102,11 +102,7 @@ config HEADERS_CHECK
> >  
> >  config DEBUG_SECTION_MISMATCH
> >  	bool "Enable full Section mismatch analysis"
> > -	depends on UNDEFINED || (BLACKFIN)
> >  	default y
> > -	# This option is on purpose disabled for now.
> > -	# It will be enabled when we are down to a reasonable number
> > -	# of section mismatch warnings (< 10 for an allyesconfig build)
> >  	help
> >  	  The section mismatch analysis checks if there are illegal
> >  	  references from one section to another section.
> 
> eaaaargh!  650 lines of crap added to my i386 allmodconfig build output.
> 
> I'll be locally opting out of this one, thanks.

How about that we enable this in the merge window.
And if it continue to be unreasonable then drop it again
around rc5 time?

The likelyhood that warnings are fixed is bigger if people
see them and get annoyed.

	Sam
