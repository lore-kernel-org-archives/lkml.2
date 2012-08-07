Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab2HGPWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 11:22:54 -0400
Received: from lobo.ruivo.org ([173.14.175.98]:60528 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab2HGPWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 11:22:50 -0400
Date: Tue, 7 Aug 2012 11:22:30 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, Aristeu Rozanski <aris@redhat.com>,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Hillf Danton <dhillf@gmail.com>, lennart@poettering.net
Subject: Re: [PATCH v3 0/3] cgroup: add xattr support
Message-ID: <20120807152230.GE20962@cathedrallabs.org>
References: <20120702142925.795007114@napanee.usersys.redhat.com>
 <20120717204126.GE24336@google.com>
 <alpine.LSU.2.00.1207181237010.2160@eggly.anvils>
 <20120718221044.GJ24336@google.com>
 <alpine.LSU.2.00.1207181736020.3323@eggly.anvils>
 <20120720175959.GA32741@cathedrallabs.org>
 <20120720180459.GJ32763@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120720180459.GJ32763@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Added Lennart to the discussion so he can help explaining how systemd will
use the xattrs)

On Fri, Jul 20, 2012 at 11:04:59AM -0700, Tejun Heo wrote:
> Hello, Hugh, Aristeu.
> 
> On Fri, Jul 20, 2012 at 01:59:59PM -0400, Aristeu Rozanski wrote:
> > hm, not sure that's what Tejun meant. tmpfs uses anonymous memory for the file
> > contents, so reuse that infrastructure to allocate space for the extended
> > attributes the same way, instead of using kmem.
> > 
> > First thing I can think of is to use whole pages for it to prevent further
> > complexity. Shouldn't make much difference considering the usecases we have
> > now (systemd and containers), right?
> 
> Yeah, that's what I meant.  The internal fragmentation is ugly but I
> think that should do for now at least.

while talking to Lennart, it seems there're a lot of ways the xattrs can be
used in systemd. If we're concerned with the amount of memory used, why not
create a new namespace just for this, limiting by definition the maximum value
size?

-- 
Aristeu

