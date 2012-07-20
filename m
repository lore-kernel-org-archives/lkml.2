Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab2GTSA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 14:00:26 -0400
Received: from lobo.ruivo.org ([173.14.175.98]:36533 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030Ab2GTSAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 14:00:18 -0400
Date: Fri, 20 Jul 2012 13:59:59 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>, Aristeu Rozanski <aris@redhat.com>,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v3 0/3] cgroup: add xattr support
Message-ID: <20120720175959.GA32741@cathedrallabs.org>
References: <20120702142925.795007114@napanee.usersys.redhat.com>
 <20120717204126.GE24336@google.com>
 <alpine.LSU.2.00.1207181237010.2160@eggly.anvils>
 <20120718221044.GJ24336@google.com>
 <alpine.LSU.2.00.1207181736020.3323@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1207181736020.3323@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh,
On Wed, Jul 18, 2012 at 06:11:32PM -0700, Hugh Dickins wrote:
> > But why do we need something completely new?  Can't we hijack some
> > inodes used by tmpfs and use them for xattr storage?  ie. Would it be
> > difficult to use tmpfs as backend storage for on-memory xattr?  With
> > that, we would already have the mechanism and interface(!) for
> > limiting the size.
> 
> That sounds just like what I was suggesting in my last sentence:
> let userspace manage a tmpfs hierarchy parallel to the cgroupfs one.
> 
> Except, perhaps, where I assume "userspace" should be doing the hard work.

hm, not sure that's what Tejun meant. tmpfs uses anonymous memory for the file
contents, so reuse that infrastructure to allocate space for the extended
attributes the same way, instead of using kmem.

First thing I can think of is to use whole pages for it to prevent further
complexity. Shouldn't make much difference considering the usecases we have
now (systemd and containers), right?

--
Aristeu

