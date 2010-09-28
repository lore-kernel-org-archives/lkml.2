Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab0I1WPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 18:15:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48291 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab0I1WPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 18:15:51 -0400
Date: Tue, 28 Sep 2010 23:15:46 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Namhyung Kim <namhyung@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: cleanup gfp_zone()
Message-ID: <20100928221546.GI19804@ZenIV.linux.org.uk>
References: <1285676624-1300-1-git-send-email-namhyung@gmail.com>
 <20100928143239.5fe34e1e.akpm@linux-foundation.org>
 <20100928214141.GG19804@ZenIV.linux.org.uk>
 <20100928144518.0eaf1099.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100928144518.0eaf1099.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 02:45:18PM -0700, Andrew Morton wrote:
> On Tue, 28 Sep 2010 22:41:42 +0100
> > > hm.  I hope these sparse warnings are sufficiently useful to justify
> > > all the gunk we're adding to support them.
> > > 
> > > Is it actually finding any bugs?
> > 
> > FWIW, bitwise or done in the right-hand argumet of shift looks ugly as hell;
> > what the hell is that code _doing_?
> 
> There's a nice fat comment a few lines up...

[snip]

Egads...  IMO the cleanest way to deal with that is to add integer
constants, not to be used anywhere else (e.g. ___GFP_DMA, with
#define __GFP_DMA ((__force gfp_t)___GFP_DMA) and use them in that
horror.

As for the gfp_t warnings - yes, they'd caught a bunch of bugs at
some point; considering the bitrot rates... might be worth rechecking.
