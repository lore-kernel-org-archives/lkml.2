Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab0DISMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 14:12:14 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:58311 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab0DISMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 14:12:09 -0400
Date: Fri, 9 Apr 2010 14:11:08 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, John Berthels <john@humyo.com>,
       linux-kernel@vger.kernel.org, Nick Gregory <nick@humyo.com>,
       Rob Sanderson <rob@humyo.com>, xfs@oss.sgi.com, linux-mm@kvack.org
Subject: Re: PROBLEM + POSS FIX: kernel stack overflow, xfs, many disks,
 heavy write load, 8k stack, x86-64
Message-ID: <20100409181108.GG13327@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <david@fromorbit.com>, John Berthels <john@humyo.com>,
	linux-kernel@vger.kernel.org, Nick Gregory <nick@humyo.com>,
	Rob Sanderson <rob@humyo.com>, xfs@oss.sgi.com, linux-mm@kvack.org
References: <4BBC6719.7080304@humyo.com>
 <20100407140523.GJ11036@dastard>
 <4BBCAB57.3000106@humyo.com>
 <20100407234341.GK11036@dastard>
 <20100408030347.GM11036@dastard>
 <4BBDC92D.8060503@humyo.com>
 <4BBDEC9A.9070903@humyo.com>
 <20100408233837.GP11036@dastard>
 <20100409113850.GE13327@think>
 <4BBF6C51.5030203@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBF6C51.5030203@sandeen.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.4BBF6DDE.00D0:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 01:05:05PM -0500, Eric Sandeen wrote:
> Chris Mason wrote:
> 
> > shrink_zone on my box isn't 500 bytes, but lets try the easy stuff
> > first.  This is against .34, if you have any trouble applying to .32,
> > just add the word noinline after the word static on the function
> > definitions.
> > 
> > This makes shrink_zone disappear from my check_stack.pl output.
> > Basically I think the compiler is inlining the shrink_active_zone and
> > shrink_inactive_zone code into shrink_zone.
> > 
> > -chris
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 79c8098..c70593e 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -620,7 +620,7 @@ static enum page_references page_check_references(struct page *page,
> >  /*
> >   * shrink_page_list() returns the number of reclaimed pages
> >   */
> > -static unsigned long shrink_page_list(struct list_head *page_list,
> > +static noinline unsigned long shrink_page_list(struct list_head *page_list,
> 
> FWIW akpm suggested that I add:
> 
> /*
>  * Rather then using noinline to prevent stack consumption, use
>  * noinline_for_stack instead.  For documentaiton reasons.
>  */
> #define noinline_for_stack noinline
> 
> so maybe for a formal submission that'd be good to use.

Oh yeah, I forgot about that one.  If the patch actually helps we can
switch it.

-chris
