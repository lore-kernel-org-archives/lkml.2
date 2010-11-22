Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab0KVRgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 12:36:07 -0500
Received: from tarap.cc.columbia.edu ([128.59.29.7]:60174 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab0KVRgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 12:36:05 -0500
Date: Mon, 22 Nov 2010 12:34:54 -0500 (EST)
From: Oren Laadan <orenl@cs.columbia.edu>
X-X-Sender: orenl@takamine.ncl.cs.columbia.edu
To: Gene Cooperman <gene@ccs.neu.edu>
cc: Tejun Heo <tj@kernel.org>, Kapil Arya <kapil@ccs.neu.edu>,
        linux-kernel@vger.kernel.org, xemul@sw.ru,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Containers <containers@lists.osdl.org>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
In-Reply-To: <20101121081853.GA21672@sundance.ccs.neu.edu>
Message-ID: <Pine.LNX.4.64.1011221222260.14320@takamine.ncl.cs.columbia.edu>
References: <20101107184927.GF31077@sundance.ccs.neu.edu> <4CD72150.9070705@cs.columbia.edu>
 <4CE3C334.9080401@kernel.org> <20101117153902.GA1155@hallyn.com>
 <4CE3F8D1.10003@kernel.org> <20101119041045.GC24031@hallyn.com>
 <4CE683E1.6010500@kernel.org> <4CE69B8C.6050606@cs.columbia.edu>
 <Pine.LNX.4.64.1011201312470.15662@takamine.ncl.cs.columbia.edu>
 <4CE8228C.3000108@kernel.org> <20101121081853.GA21672@sundance.ccs.neu.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Nov 2010, Gene Cooperman wrote:

> Below, we'll summarize the four major questions that we've understood from
> this discussion so far.  But before doing so, I want to point out that a single
> process or process tree will always have many possible interactions with
> the rest of the world.  Within our own group, we have an internal slogan:
>   "You can't checkpoint the world."
> A virtual machine can have a relatively closed world, which makes it more
> robust, but checkpointing will always have some fragile parts.

That depends of what your definition of "world". One definition
is "world := VM", as you state above. Another is "world := container"
which I stated in my post(s). You can checkpoint both.

For those cases where the "world" cannot be fully checkpointed, 
I explicitly pointed  that we should focus on the core c/r 
functionality, because the "glue" can be done either way.

> We give four examples below: 
> a.  time virtualization

IMHO, irrelevant to current discussion. And btw, this is done in
linux-cr for live migration of tcp connections.

> b.  external database
> c.  NSCD daemon

This falls within the category of "glue", and is - as I try once
again to remind - tentirely oorthogonal to the topic of where
to do c/r.

> d.  screen and other full-screen text programs
> These are not the only examples of difficult interactions with the
> rest of the world.

This actually never required a userspace "component" with Zap
or linux-cr (to the best of my knowledge)..

Even if it did - the question is not how to deal with "glue"
(you demonstrated quite well how to do that with DMTCP), but 
how should teh basic, core c/r functionality work - which is
below, and orthogonal to the "glue".

Let us please focus on the base c/r engine functionality...

(gotta disconnect now .. more later)

Oren.
