Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab1ASXQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 18:16:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753250Ab1ASXQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 18:16:32 -0500
Date: Wed, 19 Jan 2011 15:16:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vsprintf: Neaten %pK kptr_restrict, save a bit of code
 space
Message-Id: <20110119151613.cfbd7bb3.akpm@linux-foundation.org>
In-Reply-To: <1295478662.1952.45.camel@Joe-Laptop>
References: <1294950072.4114.172.camel@Joe-Laptop>
	<20110119145024.353ef8a1.akpm@linux-foundation.org>
	<1295478662.1952.45.camel@Joe-Laptop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jan 2011 15:11:02 -0800
Joe Perches <joe@perches.com> wrote:

> On Wed, 2011-01-19 at 14:50 -0800, Andrew Morton wrote:
> > On Thu, 13 Jan 2011 12:21:12 -0800
> > Joe Perches <joe@perches.com> wrote:
> > > If kptr restrictions are on, just set the passed pointer to NULL.
> > > diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> []
> > > +		if (!((kptr_restrict == 0) ||
> > > +		      (kptr_restrict == 1 &&
> > > +		       has_capability_noaudit(current, CAP_SYSLOG))))
> > > +			ptr = NULL;
> > > +		break;
> > This hurts my brain.   Does it work?
> 
> Some say mentally challenging puzzles help deter/delay
> onset of cognitive decline/Alzheimer's.  See: www.dakim.com
> 
> A mentally less challenging perhaps cleaner form is:
> 
> 		if (kptr_restrict == 0)
> 			break;
> 		if (kptr_restrict == 1 &&
> 		    has_capability_noaudit(current, CAP_SYSLOG))
> 			break;
> 		ptr = NULL;
> 		break;
> 
> Your choice. ;)

That wasn't the bit which hurt.

You still haven't told me if it works.  How thoroughly was it tested?
