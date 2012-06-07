Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab2FGU5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:57:15 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47651 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab2FGU5M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:57:12 -0400
MIME-Version: 1.0
Message-ID: <08d98de0-2f1b-4461-8197-9700bc3e0c65@default>
Date: Thu, 7 Jun 2012 13:56:57 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Konrad Wilk <konrad.wilk@oracle.com>,
        Sasha Levin <levinsasha928@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: RE: [PATCH 06/11] mm: frontswap: make all branches of if statement in
 put page consistent
References: <1338980115-2394-1-git-send-email-levinsasha928@gmail.com>
 <1338980115-2394-6-git-send-email-levinsasha928@gmail.com>
 <20120607183022.GA9472@phenom.dumpdata.com>
In-Reply-To: <20120607183022.GA9472@phenom.dumpdata.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Konrad Rzeszutek Wilk
> Subject: Re: [PATCH 06/11] mm: frontswap: make all branches of if statement in put page consistent
> 
> On Wed, Jun 06, 2012 at 12:55:10PM +0200, Sasha Levin wrote:
> > Currently it has a complex structure where different things are compared
> > at each branch. Simplify that and make both branches look similar.
> >
> > Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> > ---
> >  mm/frontswap.c |   10 +++++-----
> >  1 files changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/mm/frontswap.c b/mm/frontswap.c
> > index 618ef91..f2f4685 100644
> > --- a/mm/frontswap.c
> > +++ b/mm/frontswap.c
> > @@ -119,16 +119,16 @@ int __frontswap_put_page(struct page *page)
> >  		frontswap_succ_puts++;
> >  		if (!dup)
> >  			atomic_inc(&sis->frontswap_pages);
> > -	} else if (dup) {
> > +	} else {
> >  		/*
> >  		  failed dup always results in automatic invalidate of
> >  		  the (older) page from frontswap
> >  		 */
> > -		frontswap_clear(sis, offset);
> > -		atomic_dec(&sis->frontswap_pages);
> > -		frontswap_failed_puts++;
> 
> Hmm, you must be using an older branch b/c the frontswap_failed_puts++
> doesn't exist anymore. Could you rebase on top of linus/master please.

Reminds me... at some point I removed the ability to observe
and set frontswap_curr_pages from userland, which is very useful
in testing and could be useful for future userland sysadmin tools.
IIRC, when transitioning from sysfs to debugfs (akpm's feedback),
I couldn't figure out how to make it writeable from debugfs, so
just dropped it and never added it back.

Writing the value is like a partial (or full) swapoff of the
pages stored via frontswap into zcache/ramster/tmem.  So kinda
similar to drop_caches?

I'd sure welcome a patch to add that back in!
