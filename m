Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab1IMH75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 03:59:57 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:37778 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab1IMH7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 03:59:55 -0400
Date: Tue, 13 Sep 2011 16:54:44 +0900
From: Tejun Heo <htejun@gmail.com>
To: Paul Menage <paul@paulmenage.org>
Cc: rjw@sisk.pl, lizf@cn.fujitsu.com, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        fweisbec@gmail.com, matthltc@us.ibm.com, akpm@linux-foundation.org,
        Oleg Nesterov <oleg@redhat.com>, Paul Menage <menage@google.com>
Subject: Re: [PATCH 3/4] threadgroup: extend threadgroup_lock() to cover exit
 and exec
Message-ID: <20110913075444.GE11397@mtj.dyndns.org>
References: <1315159280-25032-1-git-send-email-htejun@gmail.com>
 <1315159280-25032-4-git-send-email-htejun@gmail.com>
 <CALdu-PBhhH0p5QfET4ZHbKVwfVFEME9v7kzUyQiPyykFscB2Ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALdu-PBhhH0p5QfET4ZHbKVwfVFEME9v7kzUyQiPyykFscB2Ng@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 11, 2011 at 09:04:55PM -0700, Paul Menage wrote:
> On Sun, Sep 4, 2011 at 11:01 AM, Tejun Heo <htejun@gmail.com> wrote:
> > From: Tejun Heo <tj@kernel.org>
> >
> > threadgroup_lock() protected only protected against new addition to
> > the threadgroup, which was inherently somewhat incomplete and
> > problematic for its only user cgroup.  On-going migration could race
> > against exec and exit leading to interesting problems - the symmetry
> > between various attach methods, task exiting during method execution,
> > ->exit() racing against attach methods, migrating task switching basic
> > properties during exec and so on.
> >
> > This patch extends threadgroup_lock() such that it protects against
> > all three threadgroup altering operations - fork, exit and exec.  For
> > exit, threadgroup_change_begin/end() calls are added to exit path.
> > For exec, threadgroup_[un]lock() are updated to also grab and release
> > cred_guard_mutex.
> 
> Can you add a comment (either in the commit or in the code) about why
> the cred_guard_mutex change is necessary? Is it simply that exec takes
> cred_guard_mutex and hence this excludes exec, or is there something
> more subtle?

Will do so.  It's just for the exclusion of cred_guard_mutex.  Maybe
we better rename it to exec_mutex or something, I don't know.

Thanks.

-- 
tejun
