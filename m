Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab2HWT6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 15:58:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818Ab2HWT6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 15:58:36 -0400
Date: Thu, 23 Aug 2012 15:58:26 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Lennart Poettering <lpoetter@redhat.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v6 3/4] cgroup: add xattr support
Message-ID: <20120823195826.GB18688@redhat.com>
References: <20120816174453.154143248@napanee.usersys.redhat.com>
 <20120816174454.087507415@napanee.usersys.redhat.com>
 <20120816200006.GG24861@google.com>
 <50340110.50607@redhat.com>
 <20120821214856.GC32596@google.com>
 <alpine.LSU.2.00.1208211606580.2383@eggly.anvils>
 <20120823194423.GC14962@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120823194423.GC14962@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 12:44:23PM -0700, Tejun Heo wrote:
> Hello, Hugh.
> 
> On Tue, Aug 21, 2012 at 04:29:53PM -0700, Hugh Dickins wrote:
> > Are we expecting Aristeu+Zefan's simple_xattr patches to go into 3.7?
> 
> Yeah, probably.
> 
> > I don't have anything planned for shmem.c for 3.7 beyond a bugfix,
> > which shouldn't interact with the simple_xattr changes at all
> > (I could remove info->lock, but will not do so this time around,
> > precisely so as not to interfere with those patches).
> > 
> > So it should be perfectly workable for you to take Aristeu+Zefan's
> > shmem patches into your cgroup tree, then any further mods from
> > mmotm will get layered on top.
> 
> I think this approach would be simpler.  Once Aristeu posts the
> updated version, I'll route the whole series through cgroup/for-3.7.

I'm about to submit it, just doing last build and testing round. Merged
back the changes Hugh asked in patch 1.

Also found why the list reinitialization was needed in the past; one of
the old iterations had a bug in the remount code and was cleaning the
xattrs out of the cgroup directory but not actually removing the
directory, thus new xattrs got added to a list of freed xattrs.

So I believe we're good to go.

-- 
Aristeu

