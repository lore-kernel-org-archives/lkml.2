Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab2EPPKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:10:42 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59839 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753957Ab2EPPKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:10:40 -0400
X-Sasl-enc: MFtfHCkq6vI13PTNso6L6Kal+1LDamUpoS/MmR6yOFJg 1337181040
Date: Wed, 16 May 2012 08:10:38 -0700
From: Greg KH <greg@kroah.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-ID: <20120516151038.GD3293@kroah.com>
References: <20120516200659.000314e53de07a7a7fda46b8@canb.auug.org.au>
 <20120516124924.GB32064@kroah.com>
 <c3a17d64-0d63-4948-8e1b-d170626adff5@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3a17d64-0d63-4948-8e1b-d170626adff5@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 07:17:02AM -0700, Dan Magenheimer wrote:
> > From: Greg KH [mailto:greg@kroah.com]
> > Subject: Re: linux-next: build failure after merge of the final tree (staging tree related)
> > 
> > On Wed, May 16, 2012 at 08:06:59PM +1000, Stephen Rothwell wrote:
> > > Hi Greg,
> > >
> > > After merging the final tree, today's linux-next build (powerpc
> > > allyesconfig) failed like this:
> > >
> > > drivers/staging/zsmalloc/zsmalloc-main.c: In function 'zs_map_object':
> > > drivers/staging/zsmalloc/zsmalloc-main.c:704:3: error: implicit declaration of function 'set_pte' [-
> > Werror=implicit-function-declaration]
> > > drivers/staging/zsmalloc/zsmalloc-main.c: In function 'zs_unmap_object':
> > > drivers/staging/zsmalloc/zsmalloc-main.c:738:3: error: implicit declaration of function
> > '__flush_tlb_one' [-Werror=implicit-function-declaration]
> > >
> > > Presumably caused by commit 49b81a3c7415 ("ramster: switch over to
> > > zsmalloc and crypto interface") which now has CONFIG_RAMSTER selecting
> > > CONFIG_ZSMALLOC explicitly which in turn ignores the dependency of
> > > CONFIG_ZSMALLOC on X86 ...
> > >
> > > I have reverted that commit for today.
> > 
> > Ick, sorry about that.
> > 
> > Dan, care to send me a follow-on patch, or do you just want me to revert
> > this patch from my tree for now?
> 
> Rats.  Sorry.
> 
> Greg, given that the solution for making zsmalloc portable
> is still being debated[1] and it doesn't look like it will
> be finalized before the looming window,  I guess the
> best choice is to revert the patch and ramster will fall
> back to its captive copy of the less-efficient-but-portable
> xvmalloc for now. :-(

Ok, now reverted, thanks.

greg k-h
