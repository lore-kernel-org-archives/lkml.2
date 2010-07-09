Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab0GINbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 09:31:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535Ab0GINbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 09:31:01 -0400
Date: Fri, 9 Jul 2010 09:30:19 -0400
From: Jason Baron <jbaron@redhat.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Hannes Reinecke <hare@suse.de>
Subject: Re: Dynamic Debug broken on 2.6.35-rc3?
Message-ID: <20100709133019.GA2856@redhat.com>
References: <201007011744.19564.trenn@suse.de>
 <20100708213927.GB2934@redhat.com>
 <20100708145300.d36cf006.akpm@linux-foundation.org>
 <201007091303.08693.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007091303.08693.trenn@suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 09, 2010 at 01:03:08PM +0200, Thomas Renninger wrote:
> Hi,
> 
> I can confirm that this patch fixes the issue for me.
> 
> On Thursday 08 July 2010 23:53:00 Andrew Morton wrote:
> > On Thu, 8 Jul 2010 17:39:28 -0400
> > Jason Baron <jbaron@redhat.com> wrote:
> > 
> > > Make sure we properly call ddebug_remove_module() when a module fails to
> > > load. In addition, pass the pointer to the "debug table", to both
> > > ddebug_add_module(), and ddebug_remove_module() so that we can uniquely
> > > identify each set of debug statements. In this way even modules with the
> > > same name can be properly identified and removed.
> > > 
> > > 
> > > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > 
> > It'd be nice to track the Reported-by:s.  And the Tested-by:s if/when
> > they arrive.  SighIllDoIt.
> > 
> > The patch (almost) applies to 2.6.34.  So are we missing a Cc:stable tag
> > as well?
> I'll resubmit with some more meta info and will include stable@kernel.org.
> 
> Could it be that this isn't a regression, but a bug that was always present,
> but only gets exposed if you add modules with a specific implementation,
> e.g. specific declarations of functions missing, etc.?
> 

Hi Thomas,

yes, this race has likely been present for a while (i'd have to look at
specific kernel versions to verify). I suspect its getting exposed now
due to more usage of this feature, and the proliferation of kernel
modules...

> I tried to patch this into a 2.6.32.X kernel. While some hunks did not
> succeed, it looks like an adjusted patch should get submitted for older
> stable kernels as well?:
> 

if nobody else has done the 2.6.32 stable patch, I can do it, just let
me know.

thanks again for reporting this to me.

thanks,

-Jason
