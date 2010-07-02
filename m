Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab0GBTwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 15:52:47 -0400
Received: from puma.mail.utk.edu ([160.36.178.106]:58687 "EHLO
	puma.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757330Ab0GBTwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 15:52:46 -0400
Date: Fri, 2 Jul 2010 15:52:22 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf wrong branches event on AMD
In-Reply-To: <1278080613.1917.258.camel@laptop>
Message-ID: <alpine.DEB.2.00.1007021546150.3405@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1007011526010.23160@cl320.eecs.utk.edu>  <1278070727.1917.253.camel@laptop>  <alpine.DEB.2.00.1007020950420.29784@cl320.eecs.utk.edu> <1278080613.1917.258.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Jul 2010, Peter Zijlstra wrote:

> On Fri, 2010-07-02 at 09:56 -0400, Vince Weaver wrote:
> > You think I have root on this machine?
> 
> Well yeah,.. I'd not want a dev job and not have full access to the
> hardware. But then, maybe I'm picky.

I can see how this support call would go now.

  Me:  Hello, I need you to upgrade the kernel on the
       2.332 petaflop machine with 37,376 processors 
       so I can have the right branch counter on perf.
  Them: Umm... no.
  Me:  Well then can I have root so I can patch
       the kernel on the fly?
  Them: <click>

As a performance counter library developer, it is a bit frustrating having 
to keep a compatibility matrix in my head of all the perf events 
shortcomings.  Especially since the users tend not to have admin
access on their machines.  Need to have at least 2.6.33 if you want
multiplexing.  Need to have 2.6.34 if you want Nehalem-EX.  Need 2.6.35
if you want Pentium 4.  Unfortunately most vendor kernels are stuck at 
2.6.32 :(  Now I'll have to remember whatever kenel the AMD branches
fix is committed at.  And there still isn't the Uncore support that 
everyone is clamoring for.

> You can stick the knowledge in perf if you really want to.. something
> like the below, add something that parses cpuid or /proc/cpuinfo and you
> should be good.

again though, doesn't this defeat the purpose of the whole idea of common 
named events?

> And how would it be different if it the data table lived in userspace?
> They'd still get the wrong thing unless they updated.

because compiling and running an updated user-version of a library is 
possible.  You can compile it in your home directory and link your tools 
against it.  No need to bug the sysadmin.  You can even use LD_PRELOAD
to get other apps to link against it.  Getting a kernel update installed 
is many orders of magnitude harder out in the real world.

Vince
