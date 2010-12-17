Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab0LQCKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 21:10:16 -0500
Received: from smtp-out.google.com ([216.239.44.51]:45873 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab0LQCKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 21:10:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=TsYH1QUpMjS6qFJz9nnNXG6nVuEV5YIxuRbBZoc+4c8OZV5N7jifOb69gKSCyp1zZ3
         faH9qNKFWanROkmuwi0A==
Date: Thu, 16 Dec 2010 18:10:02 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hughd@tigran.mtv.corp.google.com
To: Minchan Kim <minchan.kim@gmail.com>
cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: add replace_page_cache_page() function
In-Reply-To: <AANLkTinhkZKWkthN1R39+6nDbN0xZq-g7jP5-LVLxZ3E@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1012161804280.4484@tigran.mtv.corp.google.com>
References: <E1PStc6-0006Cd-0Z@pomaz-ex.szeredi.hu> <AANLkTikXQmsgZ8Ea-GoQ4k2St6yCJj8Z3XthuBQ9u+EV@mail.gmail.com> <E1PTCV4-0007sR-SO@pomaz-ex.szeredi.hu> <20101216220457.GA3450@barrios-desktop> <alpine.LSU.2.00.1012161708260.3351@tigran.mtv.corp.google.com>
 <AANLkTinhkZKWkthN1R39+6nDbN0xZq-g7jP5-LVLxZ3E@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Dec 2010, Minchan Kim wrote:
> On Fri, Dec 17, 2010 at 10:21 AM, Hugh Dickins <hughd@google.com> wrote:
> >
> > I disagree with you there: I like the way Miklos made it symmetric,
> > I like the way delete_from_swap_cache drops the swap cache reference,
> > I dislike the way remove_from_page_cache does not - I did once try to
> > change that, but did a bad job, messed up reiserfs or reiser4 I forget
> > which, retreated in shame.
> 
> I agree symmetric is good. I just said current fact which is that
> remove_from_page_cache doesn't release ref.
> So I thought we have to match current semantic to protect confusing.
> Okay. I will not oppose current semantics.
> Instead of it, please add it (ex, caller should hold the page
> reference) in function description.
> 
> I am happy to hear that you tried it.
> Although it is hard, I think it's very valuable thing.
> Could you give me hint to googling your effort and why it is failed?

http://lkml.org/lkml/2004/10/24/140

Hugh
