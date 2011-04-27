Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab1D0I57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 04:57:59 -0400
Received: from rackplans.net ([209.44.101.17]:43239 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755168Ab1D0I55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 04:57:57 -0400
X-Greylist: delayed 616 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Apr 2011 04:57:57 EDT
Date: Wed, 27 Apr 2011 04:47:40 -0400 (EDT)
From: gmack@innerfire.net
X-X-Sender: gmack@mtl.rackplans.net
To: Christoph Hellwig <hch@infradead.org>
cc: "Ted Ts'o" <tytso@mit.edu>, Thiago Farina <tfransosi@gmail.com>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
In-Reply-To: <20110427064719.GB597@infradead.org>
Message-ID: <alpine.DEB.2.00.1104270445210.7570@mtl.rackplans.net>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com> <20110427005243.GI9486@thunk.org> <20110427064719.GB597@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011, Christoph Hellwig wrote:

> Date: Wed, 27 Apr 2011 02:47:19 -0400
> From: Christoph Hellwig <hch@infradead.org>
> To: Ted Ts'o <tytso@mit.edu>, Thiago Farina <tfransosi@gmail.com>,
>     linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
> Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
> 
> On Tue, Apr 26, 2011 at 08:52:43PM -0400, Ted Ts'o wrote:
> > I don't think this is not a good idea.
> > 
> > First of all, changing 2800 instances of strcmp will induce a huge
> > amount of code churn, that will cause patches to break, etc.  And
> > whether streq() looks better is going to be very much a case of
> > personal preference.  I'm so used to !strcmp(a, b) that streq(a, b)
> > would be harder for me, just because I'm not used to it.
> > 
> > So I'd NACK a change like this to any parts of the kernel that I'm
> > maintaining.  If another people feel that way, it's not clear that
> > having two different conventions in the kernel would necessarily help...
> 
> Same here.  Diverging from standard ANSI C just for the sake of being
> different is an utterly bad idea.  strcmp might not be the most natural
> calling convention, but it's been in the wild for 30 years, and everyone
> taking a C 101 course should know about it.
> 
> And if you get it wrong and don't notice it just means your testing
> coverage sucks badly.

Knowing about it and not screwing it up are two different things. I was 
working on a project a few years ago and we made this exact change thanks 
to the backwards logic of strcmp constantly screwing people up and the bug 
count went down considerably.


	Gerhard


--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
