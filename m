Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934349Ab1IOSVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 14:21:07 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43267 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab1IOSVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 14:21:05 -0400
Subject: Re: [PATCH] sys_poll(): fix function definition/negative timeout
 values
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20110915181242.GZ7761@one.firstfloor.org>
References: <1316090761.6545.70.camel@localhost.localdomain>
	 <m27h59g0k7.fsf@firstfloor.org> <1316109917.2492.3.camel@edumazet-laptop>
	 <20110915181242.GZ7761@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 20:21:02 +0200
Message-ID: <1316110862.2492.10.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 15 septembre 2011 à 20:12 +0200, Andi Kleen a écrit :
> On Thu, Sep 15, 2011 at 08:05:17PM +0200, Eric Dumazet wrote:
> > Le jeudi 15 septembre 2011 à 10:47 -0700, Andi Kleen a écrit :
> > > Thomas Meyer <thomas@m3y3r.de> writes:
> > > 
> > > > Fix negative timeout values for x86 userland on x86_64 kernels.
> > > > Align sys_poll() definition to glibc's definition.
> > > 
> > > Nack. Please write a compat wrapper that sign extends.
> > > 
> > 
> > Why ?
> 
> Because we shouldn't change existing interfaces and there could
> be valid reasons on 64bit for really long delays.

I disagree.

Existing interface and POSIX mandates "int delay"

The kernel part of the contract was fine when we supported 32bit only
machines, by chance, because sizeof(int) == sizeof(long).

If you want more than 31 bits delay, then we need a new interface, and
this new interface must also work on 32bit arches (sort of poll64())




