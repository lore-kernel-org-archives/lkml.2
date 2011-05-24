Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021Ab1EXVsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:48:25 -0400
Received: from leopard.mail.utk.edu ([160.36.0.85]:43873 "EHLO
	leopard.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab1EXVsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:48:24 -0400
Date: Tue, 24 May 2011 17:48:04 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-kernel@vger.kernel.org, fbuihuu@gmail.com, mingo@elte.hu,
        paulus@samba.org, acme@redhat.com
Subject: Re: perf: regression with PERF_EVENT_IOC_REFRESH
In-Reply-To: <1306250318.18455.44.camel@twins>
Message-ID: <alpine.DEB.2.00.1105241742020.30737@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1105231555490.17453@cl320.eecs.utk.edu>  <1306182141.2497.5.camel@laptop>  <alpine.DEB.2.00.1105240212590.28546@cl320.eecs.utk.edu>  <1306233036.2497.15.camel@laptop>  <alpine.DEB.2.00.1105241041490.10575@cl320.eecs.utk.edu> 
 <1306249914.18455.43.camel@twins> <1306250318.18455.44.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, Peter Zijlstra wrote:

> On Tue, 2011-05-24 at 17:11 +0200, Peter Zijlstra wrote:
> > On Tue, 2011-05-24 at 11:04 -0400, Vince Weaver wrote:
> > > As an aside, I also wasted 6 hours last night finding out that you don't 
> > > get signaled on overflow if you don't have a ring-buffer mmap()ed, even
> > > if you never read from the buffer and you only are interested in counting
> > > the number of overflows. 
> > 
> > That sounds like something we could fix, let me investigate.
> 
> Does the below cure this?
> 

well that was an interesting interaction between debian-unstable and 
linus-git.  Luckily a udev update seemed to help.

Anyway, your patch did not fix the problem.  I still don't get overflow 
signals if the fd doesn't have a ring-buffer mmap()ed to it.

For a test case you can take my previous test case and comment out the 
mmap call.  Since this test case is probably the only code in the world 
trying to do this, maybe it's not that important.

I can test further patches, but my fastest build machine here at home 
takes 3 hours to build a kernel so there will be some latency in the 
response.

Vince

