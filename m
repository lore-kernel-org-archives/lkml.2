Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab2BTWdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 17:33:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41066 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420Ab2BTWdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 17:33:15 -0500
Date: Mon, 20 Feb 2012 23:33:13 +0100
From: Jan Kara <jack@suse.cz>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 01/11] perf: Push file_update_time() into
 perf_mmap_fault()
Message-ID: <20120220223313.GD32708@quack.suse.cz>
References: <1329399979-3647-1-git-send-email-jack@suse.cz>
 <1329399979-3647-2-git-send-email-jack@suse.cz>
 <1329400247.2293.219.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329400247.2293.219.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 16-02-12 14:50:47, Peter Zijlstra wrote:
> On Thu, 2012-02-16 at 14:46 +0100, Jan Kara wrote:
> > CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > CC: Ingo Molnar <mingo@elte.hu>
> > CC: Paul Mackerras <paulus@samba.org>
> > CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  kernel/events/core.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index ba36013..61a67f3 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -3316,8 +3316,10 @@ static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
> >  	int ret = VM_FAULT_SIGBUS;
> >  
> >  	if (vmf->flags & FAULT_FLAG_MKWRITE) {
> > -		if (vmf->pgoff == 0)
> > +		if (vmf->pgoff == 0) {
> >  			ret = 0;
> > +			file_update_time(vma->vm_file);
> > +		}
> >  		return ret;
> >  	}
> 
> Its an anon filedesc, there's no actual file and while I guess one could
> probably call fstat() on it, people really shouldn't care.
> 
> So feel free to introduce this patch to the bitbucket.
  Thanks for letting me know. Patch removed.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
