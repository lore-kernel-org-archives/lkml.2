Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655Ab2CLWK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 18:10:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56982 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab2CLWK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 18:10:56 -0400
Date: Mon, 12 Mar 2012 15:10:50 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Michal Schmidt <mschmidt@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120312221050.GG23255@google.com>
References: <20120221211938.GE12236@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120221211938.GE12236@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

Thanks a lot for the discussion and here are my take aways:

* At least to me, nobody seems to have strong enough justification for
  orthogonal multiple hierarchies, so, yeah, unless something else
  happens, I'm scheduling multiple hierarchy support for the chopping
  block.  This is a long term thing (think years), so no need to panic
  right now and as is life plans may change and fail to materialize,
  but I intend to at least move away from it.

* Several people pointed out that it would be inconvenient to require
  cgroup hierarchy to be a strict super-imposed tree on top of process
  tree and that program groups / sessions aren't like that either.  I
  agree, so it will hopefully be single hierarchy which more or less
  behaves the same as the current hierarchy.

* How to map controllers which aren't aware of full hierarchy is still
  an open question but I'm still standing by one active node on any
  root-to-leaf path w/ root group serving as the special rest group.

  This should happen first for the long migration to begin.  I might
  get to it someday but if anyone can beat me to it, please go ahead.
  I'll be ecstatic to review and merge the patches.

Also, I'll slowly be marking features which don't seem essential,
especially the convenience features for multiple hierarchies, as
deprecated and eventually chop them.

Thank you.

-- 
tejun
