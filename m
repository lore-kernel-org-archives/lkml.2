Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab0KBVr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 17:47:26 -0400
Received: from verein.lst.de ([213.95.11.210]:38451 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab0KBVrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 17:47:25 -0400
Date: Tue, 2 Nov 2010 22:47:06 +0100
From: Christoph Hellwig <hch@lst.de>
To: Tejun Heo <tj@kernel.org>
Cc: Oren Laadan <orenl@cs.columbia.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
Message-ID: <20101102214706.GA28593@lst.de>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu> <4CD08419.5050803@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD08419.5050803@kernel.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Tejun,

your writeup brought up a lot of the same issues that I see with
the in-kernel C/R.  Various C/R implementations that are entirely
in userspace or with limited kernel assistance have been in production
in HPC environments for years.  I think especially for these workloads
C/R is an extremly useful feature, and a standard implementation would
do Linux well.

But I think the "transparent" in-kernel one is the wrong approach.  It
tries to give the illusion that C/R will just work, while a lot of
things are simply not support.  In this case whitelisting the allowed
state by requiring special APIs for all I/O (or even just standard
APIs as long as they are supposed by the C/R lib you're linked against)
is the more pragmatic, and I think faithful aproach.  In addition to
the amount of state not supported despite looking transparant the
other big problem with the patchset is that it saves the kernel internal
state which changes all the time from one release to another.  The
handwaiving is that a userspace tool will solve it.  I'm pretty sure
that's not the case; it might solve a few cases but the general
version n to version m conversion is impossible to maintain.  Just look
at the problem qemu has migration between just a handfull of version
of the relatively well (compared to random kernel state) defined vmstate
format.


