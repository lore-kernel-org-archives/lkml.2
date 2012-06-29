Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab2F2Q6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:58:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61193 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855Ab2F2Q6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:58:14 -0400
Date: Fri, 29 Jun 2012 09:58:09 -0700
From: "tj@kernel.org" <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: shyju pv <shyju.pv@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Sanil kumar <sanil.kumar@huawei.com>,
        Masanari Iida <standby24x7@gmail.com>
Subject: Re: 3.5-rc3: BUG: Dentry still in use (1) [unmount of cgroup
 cgroup]
Message-ID: <20120629165809.GB21048@google.com>
References: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com>
 <20120627182903.GP15811@google.com>
 <4FEBF4B7.2070105@huawei.com>
 <20120628180712.GC22641@google.com>
 <4FED10DB.7040500@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FED10DB.7040500@huawei.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Fri, Jun 29, 2012 at 10:20:11AM +0800, Li Zefan wrote:
> > Can you please elaborate a bit?  I'm not really following?  Where does
> > the last root->d_count-- come from?
> 
> 
> From my limited knowledge about vfs internal, seems the parent's refcnt won't go down
> to 0 before its children. When mkdir, the parent's refcnt will be incremented, and
> after rmdir, dput(subdir) will drop subdir's refcnt and then drop parent's.
> 
> So when dropping the subdir's refcnt and leading the superblock to be killed, the root's
> dentry is still > 0.

Heh, yeah, I thought you found who was holding out on the refcnt. :)

> >> I use this script to reproduce the bug:
> >>
> >> mount -t cgroup -o cpu xxx /mnt
> >> mkdir /mnt/sub
> >> sleep 100 < /mnt/sub &
> >> kill $!
> >> wait $!
> >> rmdir /mnt/sub
> >> umount /mnt
> > Unfortunately, this doesn't reproduce the bug here either. :(
> 
> I can reproduce the bug reliably.. Try s/cpu/perf or s/cpu/net_cls, which have fewer
> cgroup files?

Hmm... weird.  Maybe some debug config option I have is preventing the
race from occurring as reliably?  Can you please attach your .config?

Thanks.

-- 
tejun
