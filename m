Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab0EQMoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 08:44:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244Ab0EQMoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 08:44:10 -0400
Subject: Re: [PATCH] cache last free vmap_area to avoid restarting beginning
From: Steven Whitehouse <swhiteho@redhat.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100505161632.GB5378@laptop>
References: <1271262948.2233.14.camel@barrios-desktop>
	 <1271320388.2537.30.camel@localhost>
	 <1271350270.2013.29.camel@barrios-desktop>
	 <1271427056.7196.163.camel@localhost.localdomain>
	 <1271603649.2100.122.camel@barrios-desktop>
	 <1271681929.7196.175.camel@localhost.localdomain>
	 <h2g28c262361004190712v131bf7a3q2a82fd1168faeefe@mail.gmail.com>
	 <1272548602.7196.371.camel@localhost.localdomain>
	 <1272821394.2100.224.camel@barrios-desktop>
	 <1273063728.7196.385.camel@localhost.localdomain>
	 <20100505161632.GB5378@laptop>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Mon, 17 May 2010 13:42:12 +0100
Message-Id: <1274100132.3158.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2010-05-06 at 02:16 +1000, Nick Piggin wrote:
> On Wed, May 05, 2010 at 01:48:48PM +0100, Steven Whitehouse wrote:
> > Hi,
> > 
> > On Mon, 2010-05-03 at 02:29 +0900, Minchan Kim wrote:
> > > Hi, Steven. 
> > > 
> > > Sorry for lazy response.
> > > I wanted to submit the patch which implement Nick's request whole.
> > > And unfortunately, I am so busy now. 
> > > But if it's urgent, I want to submit this one firstly and 
> > > at next version, maybe I will submit remained TODO things 
> > > after middle of May.
> > > 
> > > I think this patch can't make regression other usages.
> > > Nick. What do you think about?
> > > 
> > I guess the question is whether the remaining items are essential for
> > correct functioning of this patch, or whether they are "it would be nice
> > if" items. I suspect that they are the latter (I'm not a VM expert, but
> > from the brief descriptions it looks like that to me) in which case I'd
> > suggest send the currently existing patch first and the following up
> > with the remaining changes later.
> > 
> > We have got a nice speed up with your current patch and so far as I'm
> > aware not introduced any new bugs or regressions with it.
> > 
> > Nick, does that sound ok?
> 
> Just got around to looking at it again. I definitely agree we need to
> fix the regression, however I'm concerned about introducing other
> possible problems while doing that.
> 
> The following patch should (modulo bugs, but it's somewhat tested) give
> no difference in the allocation patterns, so won't introduce virtual
> memory layout changes.
> 
> Any chance you could test it?
> 

Apologies for the delay. I tried the patch on my test box and it worked
perfectly ok. When the original test was tried which triggered the
investigation in the first place, it failed to boot. Since that box is
remote and with limited remote console access, all I've been able to
find out is "it didn't work" which isn't very helpful.

I'm currently trying to figure out how we can work out whats wrong. It
isn't at all certain that it is an issue with this patch - it could be
almost anything :(

Steve.



