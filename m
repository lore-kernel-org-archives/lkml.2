Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660Ab0JLQsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 12:48:24 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63133 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab0JLQsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 12:48:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wOsPw7+Q5YJ1ohgjG6Xh4gXQ0M/LfzI+Ihqx9wF1gC9/0hTChnzN8IIG/uMg0lFjAX
         4kv6fgKwTQzMllwa4GEj1715f0rzhyLMBjqmxkfSP1jSuoewJSkJVj183+KmPS1yKNh+
         YbpovVCn0HnQKIkyjRORxeXpJXdLfAk0rU5cc=
Date: Tue, 12 Oct 2010 20:48:15 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: tidspbridge: fix signess error
Message-ID: <20101012164815.GA28276@albatros>
References: <1286827491.2762.69.camel@dan>
 <1286828643.2762.76.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286828643.2762.76.camel@dan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 16:24 -0400, Dan Rosenberg wrote:
> It seems to me that in a lot of cases, signed types were used initially
> with checks that the value was not below zero, but then unsigned types
> were substituted due to problems later on (potentially security
> related), and the checks were never removed.  Just because a check
> doesn't make sense doesn't necessarily mean it's safe to revert an
> unsigned type to a signed one - just be careful to make sure you're not
> introducing any problems when you make these kinds of changes.  I have
> no idea whether or not this is the case in this particular example.

i is used as the store for get_user_pages() result, which may be
-EFAULT.

> > i was unsigned, so check for (i < 0) made no sense.  Made it signed.
> > 
> > Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> > ---
> >  I cannot compile this driver, so it is not tested.
> >  drivers/staging/tidspbridge/core/dsp-mmu.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > diff --git a/drivers/staging/tidspbridge/core/dsp-mmu.c b/drivers/staging/tidspbridge/core/dsp-mmu.c
> > index 3c978f9..983c95a 100644
> > --- a/drivers/staging/tidspbridge/core/dsp-mmu.c
> > +++ b/drivers/staging/tidspbridge/core/dsp-mmu.c
> > @@ -219,7 +219,8 @@ u32 user_to_dsp_map(struct iommu *mmu, u32 uva, u32 da, u32 size,
> >  				struct page **usr_pgs)
> >  {
> >  	int res, w;
> > -	unsigned pages, i;
> > +	unsigned pages;
> > +	int i;
> >  	struct vm_area_struct *vma;
> >  	struct mm_struct *mm = current->mm;
> >  	struct sg_table *sgt;
> > -- 
> > 1.7.0.4
> 
> 

-- 
Vasiliy
