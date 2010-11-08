Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab0KHCdL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 21:33:11 -0500
Received: from mail.lang.hm ([64.81.33.126]:39838 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681Ab0KHCdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 21:33:09 -0500
Date: Sun, 7 Nov 2010 18:32:40 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Davide Libenzi <davidel@xmailserver.org>
cc: Matt Helsley <matthltc@us.ibm.com>, Tejun Heo <tj@kernel.org>,
        Oren Laadan <orenl@cs.columbia.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
In-Reply-To: <alpine.DEB.2.00.1011071032001.29896@davide-lnx1>
Message-ID: <alpine.DEB.2.00.1011071817560.24952@asgard.lang.hm>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu> <4CD08419.5050803@kernel.org> <4CD23087.30900@cs.columbia.edu> <4CD28033.1000700@kernel.org> <20101106101209.GD11535@count0.beaverton.ibm.com>
 <alpine.DEB.2.00.1011071032001.29896@davide-lnx1>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Nov 2010, Davide Libenzi wrote:

> Please, do not compare things like single file systems, drivers, or
> otherwise fairly isolated components, with this "thing".
> This thing touches a freaky-large number of subsystems, effectively
> adding a glueage between them, which can might end up causing problems
> (and/or restrict design choices) in the future.

I've got a question about the ABI that would be created

I see two possible areas that could be considered an ABI

1. control of the C/R process

   This is very clearly a userspace ABI, to be figured out and locked down 
like any other ABI

2. the details of how things are stored and added back into a system

   This is not as clear. at one extreme, this could be like the module 
interface, (the checkpointed image is only guaranteed to work on a new 
system with a kernel compiled with the same config options as the system 
it was checkpointed from). At the other extreme, this could be something 
that allows you to ckeckpoint an image on 2.6.40 and restore it on 2.6.80. 
Or it could be something in between.

I don't see any way that it is sane to make the C/R image defiition and 
interface (#2) be an ABI that is guaranteed to never change without 
hurting future kernel development (exactly the type of things that Davide 
is worried about above), but what sort of guarantee are people interested 
in?

is it enough to sa that it must be the same kernel version compiled with 
the same options? (or at least the same options for some list of things 
that matter, most device drivers probably would not matter for example)

or would you need compatibility across all compile options for a kernel 
release?

would you require compatibility between 2.6.x.y and 2.6.x.z?

would you require compatibility between 2.6.x and 2.6.x+n (for some value 
of n)?

is this something that could go in with the weakest guarantee initially, 
and then as everyone is more comfortable with it, start extending the 
guarantee (and as-needed adding code to the kernel to maintain 
compatibility with old images)?

would you require compatibility between 2.6.x and 2.6.x-n?

David Lang
