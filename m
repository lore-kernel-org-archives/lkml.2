Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377Ab1JFXBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 19:01:49 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60779 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab1JFXBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 19:01:47 -0400
Date: Thu, 6 Oct 2011 16:01:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sys_poll(): fix function definition/negative timeout
 values
Message-Id: <20111006160144.cf90307b.akpm@linux-foundation.org>
In-Reply-To: <1316110862.2492.10.camel@edumazet-laptop>
References: <1316090761.6545.70.camel@localhost.localdomain>
	<m27h59g0k7.fsf@firstfloor.org>
	<1316109917.2492.3.camel@edumazet-laptop>
	<20110915181242.GZ7761@one.firstfloor.org>
	<1316110862.2492.10.camel@edumazet-laptop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Sep 2011 20:21:02 +0200
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Le jeudi 15 septembre 2011 __ 20:12 +0200, Andi Kleen a __crit :
> > On Thu, Sep 15, 2011 at 08:05:17PM +0200, Eric Dumazet wrote:
> > > Le jeudi 15 septembre 2011 __ 10:47 -0700, Andi Kleen a __crit :
> > > > Thomas Meyer <thomas@m3y3r.de> writes:
> > > > 
> > > > > Fix negative timeout values for x86 userland on x86_64 kernels.
> > > > > Align sys_poll() definition to glibc's definition.
> > > > 
> > > > Nack. Please write a compat wrapper that sign extends.
> > > > 
> > > 
> > > Why ?
> > 
> > Because we shouldn't change existing interfaces and there could
> > be valid reasons on 64bit for really long delays.
> 
> I disagree.
> 
> Existing interface and POSIX mandates "int delay"
> 
> The kernel part of the contract was fine when we supported 32bit only
> machines, by chance, because sizeof(int) == sizeof(long).
> 
> If you want more than 31 bits delay, then we need a new interface, and
> this new interface must also work on 32bit arches (sort of poll64())

So what's happening here?

If the change will break (or alter) existing code which does

	poll(..., something_greater_than_2g)

then I don't think we can apply the patch.  There may be code out there
which breaks, there may not be.  We don't know.  We screwed up, we get
to wear the cost of having done so.

