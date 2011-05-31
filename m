Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab1EaQkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 12:40:07 -0400
Received: from jaguar.mail.utk.edu ([160.36.0.84]:58502 "EHLO
	jaguar.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1EaQkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 12:40:05 -0400
Date: Tue, 31 May 2011 12:39:37 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Vince Weaver <vince@deater.net>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, paulus@samba.org, acme@redhat.com
Subject: Re: perf: [patch] regression with PERF_EVENT_IOC_REFRESH
In-Reply-To: <1306857173.2353.162.camel@twins>
Message-ID: <alpine.DEB.2.00.1105311235080.2204@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1105231555490.17453@cl320.eecs.utk.edu>  <1306182141.2497.5.camel@laptop>  <alpine.DEB.2.00.1105240212590.28546@cl320.eecs.utk.edu>  <1306233036.2497.15.camel@laptop>  <alpine.DEB.2.00.1105272332400.9313@cl320.eecs.utk.edu> 
 <1306578144.1200.1150.camel@twins>  <alpine.DEB.2.00.1105291253270.6774@cl320.eecs.utk.edu>  <Pine.LNX.4.64.1105302129210.7601@pianoman.cluster.toy>  <1306826593.2530.7.camel@twins>  <Pine.LNX.4.64.1105310942410.9995@pianoman.cluster.toy>
 <1306857173.2353.162.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011, Peter Zijlstra wrote:
> 
> IOC_REFRESH sets event->event_limit, not wakeup_events.

ahh, yes. 

So it's a userspace "bug".

The test code called a "IOC_REFRESH, 3" whenever it got signalled.
It didn't distinguish between whether it was a plain overflow or if it was 
a ring-buffer overflow (can it distinguish?).

Thus the watermark bug was confusing the user-space code into refreshing 
when it was not necessary.

> > I'm also bisecting the other problem I mentioned, the one where overflows 
> > are 10x too large on 3.0-rc1.  I'm at work with a Nehalem machine so the 
> > bisect should go faster than the bisect I had to do on an atom machine 
> > this weekend.  
> 
> It wouldn't be the SIGIO fix would it?, with that every overflow
> generates a SIGIO, not only the poll() wakeups. And ouch at bisecting
> (or even building a kernel) on an Atom, those things are horridly slow.

Oh, it could be the SIGIO fix.  I hadn't realized that got merged already.

And yes, bisect on atom is painful, but my alternatives were a 1.7GHz P4 
(with small disk, so would have been over NFS), a 600MHz G3 iBook, or an 
armv6 machine.  So atom it was.

Vince
vweaver1@eecs.utk.edu
