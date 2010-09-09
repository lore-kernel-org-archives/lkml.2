Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815Ab0IICcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 22:32:24 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:41980 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751228Ab0IICcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 22:32:18 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+YRQERGgCYGTbHXsg+eHE0gEGcvkkPW3c4zrbMXE
	HYjtgRJ/S0inWm
Subject: Re: [process scheduler] Possible bug in context_swich()?
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: fabio de francesco <fabio@metanix.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1283961258.23762.33.camel@laptop>
References: <201009081728.18227.fabio@metanix.org>
	 <1283961258.23762.33.camel@laptop>
Content-Type: text/plain
Date: Thu, 09 Sep 2010 04:32:19 +0200
Message-Id: <1283999539.9103.54.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-08 at 17:54 +0200, Peter Zijlstra wrote:
> On Wed, 2010-09-08 at 17:28 +0200, fabio de francesco wrote:
> 
> > In context_switch() (in linux/kernel/sched.c), starting with release 2.6.33, 
> > two "unlikely" macro  have been changed to "likely". I think the previous 
> > logic was right while the latter is wrong.
> > 
> > In case I am missing something I, please, ask someone to explain the above 
> > mentioned inversion of logic through releases.
> 
> It helps if you CC people, LKML alone is a bit of a gamble.
> 
> git blame kernel/sched.c, will tell you that the change you refer to
> comes from:
> 
> commit 710390d90f143a9ebb87a475215140f426792efd
> Author: Tim Blechmann <tim@klingt.org>
> Date:   Tue Nov 24 11:55:27 2009 +0100
> 
>     sched: Optimize branch hint in context_switch()
>     
>     Branch hint profiling on my nehalem machine showed over 90%
>     incorrect branch hints:

That change never made any sense to me, seems Tim must have been
measuring a kthread load.  I benched at the time, and saw absolutely
zero difference one way or the other wrt max ctx rate on my Q6600.

	-Mike

